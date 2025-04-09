#!/bin/bash
set -e

# Basis-Variablen
BASE_DISTRO="Ubuntu-24.04"
BASE_IMAGE="D:/WSL/ubuntu.tar"
WSL_BASE_DIR="D:/WSL"
BUILDER_DISTRO="ubuntu-builder"
VM_NAME="dukmaster"
VHDX_PATH_WIN="D:\\Hyper-V\\$VM_NAME\\disk.vhdx"
DISK_SIZE="32G"

# 1. Prüfe, ob Ubuntu-24.04 als Basisdistro vorhanden ist
if ! wsl.exe --list | iconv -f UTF-16LE -t UTF-8 | grep -q "$BASE_DISTRO"; then
    echo "🚀 Installiere $BASE_DISTRO ..."
    wsl --install --no-launch -d "$BASE_DISTRO"
    wsl --terminate "$BASE_DISTRO"
    sleep 15
fi

# 2. Exportieren, falls nicht vorhanden
if [[ ! -f "$BASE_IMAGE" ]]; then
    echo "📦 Exportiere $BASE_DISTRO → $BASE_IMAGE ..."
    wsl.exe --export "$BASE_DISTRO" "$BASE_IMAGE"
else
    echo "📦 Export bereits vorhanden – überspringe Export."
fi

# 3. Importiere ubuntu-builder, falls noch nicht vorhanden
if wsl.exe --list | iconv -f UTF-16LE -t UTF-8 | grep -q "^$BUILDER_DISTRO$"; then
    echo "📦 WSL-Instanz '$BUILDER_DISTRO' bereits vorhanden – überspringe Import."
else
    echo "📥 Importiere '$BUILDER_DISTRO'..."
    wsl.exe --import "$BUILDER_DISTRO" "$WSL_BASE_DIR/$BUILDER_DISTRO" "$BASE_IMAGE" --version 2

    echo "⚙️ Konfiguriere /mnt Unterstützung in '$BUILDER_DISTRO'..."
    wsl -d "$BUILDER_DISTRO" -- bash <<'EOF'
sudo tee /etc/wsl.conf >/dev/null <<EOCONF
[automount]
enabled = true
root = /mnt/
options = metadata

[user]
default = root
EOCONF
EOF

    echo "🔄 Starte '$BUILDER_DISTRO' neu..."
    wsl --terminate "$BUILDER_DISTRO"

    echo "🔧 Installiere benötigte Tools..."
    wsl -d "$BUILDER_DISTRO" -- bash <<'EOF'
set -e
sudo apt update
sudo apt install -y qemu-utils genisoimage curl parted
EOF
fi

# 4. Image-Vorbereitung in WSL-Builder-Instanz
echo "🐧 Starte Image-Vorbereitung in '$BUILDER_DISTRO'..."

wsl -d "$BUILDER_DISTRO" -- bash <<'EOF'
set -e

IMG_NAME="ubuntu-24.04-server.img"
IMG_URL="https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.img"
DISK_SIZE="32G"
VM_NAME="dukmaster"

# Image herunterladen
if [[ ! -f "$IMG_NAME" ]]; then
    echo "⬇️ Lade Ubuntu Cloud Image..."
    curl -s -L -o "$IMG_NAME" "$IMG_URL"
fi

if [[ -f "../cloud-init-dukmaster.yaml" ]]; then
    echo "📋 Füge cloud-init user-data hinzu..."
    sudo modprobe nbd max_part=8
    sudo qemu-nbd --connect=/dev/nbd0 "$IMG_NAME" || echo "⚠️ Warnung ignoriert: Image evtl. bereits verbunden"
    sleep 2

    sudo mkdir -p /mnt/disk
    echo "instance-id: iid-local01" > meta-data
    echo "local-hostname: dukmaster" >> meta-data

    # Hole erste Partition aus parted (WSL-sicher!)
    PART=$(sudo parted -s /dev/nbd0 print | awk '/^ 1/ {print $1}')
    if [[ -z "$PART" ]]; then
        echo "❌ Keine Partition erkannt – breche ab."
        sudo qemu-nbd --disconnect /dev/nbd0
        exit 1
    fi

    DEV="/dev/nbd0p$PART"

    echo "🧷 Mount $DEV ..."
    sudo mount "$DEV" /mnt/disk || {
        echo "❌ Mount fehlgeschlagen – breche ab."
        sudo qemu-nbd --disconnect /dev/nbd0
        exit 1
    }

    sudo mkdir -p /mnt/disk/var/lib/cloud/seed/nocloud-net
    sudo cp "../cloud-init-dukmaster.yaml" /mnt/disk/var/lib/cloud/seed/nocloud-net/user-data
    sudo cp "meta-data"        /mnt/disk/var/lib/cloud/seed/nocloud-net/meta-data    
    sudo umount /mnt/disk
    sudo qemu-nbd --disconnect /dev/nbd0
fi

# Jetzt vergrößern
echo "📏 Vergrößere Image auf $DISK_SIZE..."
qemu-img resize "$IMG_NAME" "$DISK_SIZE"

# Konvertieren zu VHDX
echo "💾 Konvertiere zu VHDX..."
mkdir -p /mnt/d/Hyper-V/"$VM_NAME"
qemu-img convert -O vhdx "$IMG_NAME" "/mnt/d/Hyper-V/$VM_NAME/disk.vhdx"
EOF

# 5. Hyper-V VM erstellen und starten
echo "💻 Erstelle Hyper-V VM '$VM_NAME'..."

powershell.exe -NoProfile -Command "
\$vmName = '$VM_NAME'
\$vmPath = 'D:\\Hyper-V\\$VM_NAME'
if (-not (Get-VM -Name \$vmName -ErrorAction SilentlyContinue)) {
    New-VM -Name \$vmName -MemoryStartupBytes 4096MB -Generation 2 -VHDPath '$VHDX_PATH_WIN' -SwitchName 'Default Switch' -Path \$vmPath
    Set-VM -Name \$vmName -AutomaticStartAction StartIfRunning
    Set-VMFirmware -VMName \$vmName -EnableSecureBoot Off
}
Start-VM -Name \$vmName
"


echo "✅ Hyper-V VM '$VM_NAME' ist bereit."
