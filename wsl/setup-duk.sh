#!/bin/bash
set -e

# Basis-Variablen (Passe den Pfad ggf. an)
BASE_DISTRO="Ubuntu-24.04"
BASE_IMAGE="D:/WSL/ubuntu.tar"
WSL_BASE_DIR="D:/WSL"
CLOUD_INIT_DIR="$HOME/.cloud-init"

# Funktion, um auf cloud-init Abschluss zu warten
wait_for_cloud_init() {
    local instance="$1"
    echo "Warte auf cloud-init in Instanz '$instance'..."
    wsl -d "$instance" -- bash -c 'while ! cloud-init status 2>/dev/null | grep -q "status: done"; do sleep 1; done'
}

###############################
# Instanz: Ubuntu 24.04
###############################

# 1. Distro prüfen & ggf. installieren
if ! wsl.exe --list | iconv -f UTF-16LE -t UTF-8 | grep -q "$BASE_DISTRO"; then
    echo "Installiere $BASE_DISTRO ..."
    wsl --install --no-launch -d "$BASE_DISTRO"
    ubuntu2404.exe install --root
    wsl --terminate "$BASE_DISTRO"
    sleep 15
fi

# 2. Exportieren falls nicht vorhanden
if [[ ! -f "$BASE_IMAGE" ]]; then
  echo "📦 Exportiere $BASE_DISTRO → $BASE_IMAGE ..."
  wsl.exe --export "$BASE_DISTRO" "$BASE_IMAGE"
else
  echo "📦 Export bereits vorhanden – überspringe Export."
fi

# Sicherstellen, dass das cloud-init Verzeichnis existiert
mkdir -p "$CLOUD_INIT_DIR"

###############################
# Instanz: duk
###############################

echo "Erstelle cloud-init Skript für duk..."
cat ../cloud-init-dukmaster.yaml >"$CLOUD_INIT_DIR/duk.user-data"
cat <<'EOF' >> "$CLOUD_INIT_DIR/duk.user-data"

write_files:
- path: /etc/wsl.conf
  append: true
  content: |
    [user]
    default=ubuntu
EOF

echo "Importiere duk..."
wsl --import duk "${WSL_BASE_DIR}/duk" "$BASE_IMAGE" --version 2
wait_for_cloud_init duk
wsl -t duk
echo "Instanz duk wurde erstellt."
