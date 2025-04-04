#!/usr/bin/env bash

set -e

BASE_DISTRO="Ubuntu-24.04"
EXPORT_PATH="/d/wsl/ubuntu.tar"
WSL_ROOT="/d/wsl"
CP1_USER_DATA="ubuntu-cp1.user-data"
WORKER_USER_DATA="ubuntu-worker.user-data"
NODES=("duk-cp1" "duk-cp2" "duk-cp3")

# 1. Cloud-init für CP1
if [[ ! -f "$CP1_USER_DATA" ]]; then
  echo "📝 Erstelle cloud-init für CP1: $CP1_USER_DATA"
  cat > "$CP1_USER_DATA" <<EOF
#cloud-config
package_update: true
packages:
  - snapd
write_files:
  - path: /etc/wsl.conf
    append: true
    content: |
      [user]
      default=ubuntu
      [wsl2]
      guiApplications=false
runcmd:
  - snap install microk8s --classic
  - usermod -aG microk8s ubuntu
  - newgrp microk8s
  - snap run microk8s status --wait-ready
  - snap run microk8s enable dns ingress dashboard storage
EOF
fi

# 2. Cloud-init für Worker
if [[ ! -f "$WORKER_USER_DATA" ]]; then
  echo "📝 Erstelle cloud-init für Worker: $WORKER_USER_DATA"
  cat > "$WORKER_USER_DATA" <<EOF
#cloud-config
package_update: true
packages:
  - snapd
write_files:
  - path: /etc/wsl.conf
    append: true
    content: |
      [user]
      default=ubuntu
      [wsl2]
      guiApplications=false
runcmd:
  - snap install microk8s --classic
  - usermod -aG microk8s ubuntu
  - newgrp microk8s
  - snap run microk8s status --wait-ready
EOF
fi

# 3. Distro prüfen & ggf. installieren
if ! wsl.exe --list | iconv -f UTF-16LE -t UTF-8 | grep -q "$BASE_DISTRO"; then
  echo "⬇️ '$BASE_DISTRO' ist nicht installiert – installiere..."
  wsl.exe --install -d "$BASE_DISTRO"
  sleep 15
fi

# 4. Exportieren falls nicht vorhanden
if [[ ! -f "$EXPORT_PATH" ]]; then
  echo "📦 Exportiere $BASE_DISTRO nach $EXPORT_PATH ..."
  wsl.exe --export "$BASE_DISTRO" "$EXPORT_PATH"
else
  echo "📦 Export bereits vorhanden – überspringe Export."
fi

# 5. Importieren & initialisieren
for NODE in "${NODES[@]}"; do
  TARGET_DIR="$WSL_ROOT/$NODE"
  echo "📁 Importiere $NODE nach $TARGET_DIR ..."
  mkdir -p "$TARGET_DIR"
  wsl.exe --import "$NODE" "$TARGET_DIR" "$EXPORT_PATH"

  USER_DATA="$WORKER_USER_DATA"
  [[ "$NODE" == "duk-cp1" ]] && USER_DATA="$CP1_USER_DATA"

  META_DATA="${NODE}-meta-data.yaml"
  echo "instance-id: $NODE" > "$META_DATA"

  echo "☁️  Bereite cloud-init Umgebung in $NODE vor ..."
  wsl.exe -d "$NODE" -- bash -c "sudo mkdir -p /var/lib/cloud/seed/nocloud-net"
  wsl.exe -d "$NODE" -- bash -c "sudo rm -f /etc/cloud/cloud-init.disabled"
  wsl.exe -d "$NODE" -- bash -c "echo 'datasource_list: [ NoCloud ]' | sudo tee /etc/cloud/cloud.cfg.d/99-force-nocloud.cfg > /dev/null"

  echo "📤 Übertrage user-data & meta-data nach $NODE ..."
  cat "$USER_DATA" | wsl.exe -d "$NODE" -- bash -c "sudo tee /var/lib/cloud/seed/nocloud-net/user-data > /dev/null"
  cat "$META_DATA" | wsl.exe -d "$NODE" -- bash -c "sudo tee /var/lib/cloud/seed/nocloud-net/meta-data > /dev/null"

  echo "🚀 Starte cloud-init manuell in $NODE ..."
  # wsl.exe -d "$NODE" -- bash -c "sudo env CLOUD_INIT_DATASOURCE=NoCloud cloud-init single --file /var/lib/cloud/seed/nocloud-net/user-data --name cc_scripts_user --frequency always" || echo "⚠️ cloud-init single fehlgeschlagen in $NODE"
  wsl.exe -d duk-cp1 -- bash -c "sudo cloud-init init"
  
done

echo
echo "✅ Alle MicroK8s-WLS-Instanzen wurden erfolgreich eingerichtet:"
for NODE in "${NODES[@]}"; do
  echo "  🖥️  $NODE"
done

echo
echo "👉 Starte z. B. mit:"
echo "    wsl -d duk-cp1"
echo "    microk8s kubectl get nodes"
