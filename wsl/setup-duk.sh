#!/usr/bin/env bash

set -e

BASE_DISTRO="Ubuntu-24.04"
EXPORT_PATH="/d/wsl/ubuntu.tar"
WSL_ROOT="/d/wsl"
NODES=("duk-cp1" "duk-cp2" "duk-cp3")

# MicroK8s Setupscript (läuft innerhalb der WSL-Instanz als root)
MICROK8S_SETUP=$(cat <<'EOF'
#!/bin/bash
echo "🔧 Setze Snap und MicroK8s auf..."
apt update
apt install -y snapd
snap install microk8s --classic
usermod -aG microk8s ubuntu
runuser -l ubuntu -c 'microk8s status --wait-ready'
EOF
)

# Optional: Erweiterung für duk-cp1 (z. B. DNS etc.)
MICROK8S_EXTRA=$(cat <<'EOF'
runuser -l ubuntu -c 'microk8s enable dns ingress dashboard storage'
EOF
)

# 1. Distro prüfen & ggf. installieren
if ! wsl.exe --list | iconv -f UTF-16LE -t UTF-8 | grep -q "$BASE_DISTRO"; then
  echo "⬇️  Installiere '$BASE_DISTRO' ..."
  wsl.exe --install -d "$BASE_DISTRO"
  sleep 15
fi

# 2. Exportieren falls nicht vorhanden
if [[ ! -f "$EXPORT_PATH" ]]; then
  echo "📦 Exportiere $BASE_DISTRO → $EXPORT_PATH ..."
  wsl.exe --export "$BASE_DISTRO" "$EXPORT_PATH"
else
  echo "📦 Export bereits vorhanden – überspringe Export."
fi

# 3. Importieren & MicroK8s Setup ausführen
for NODE in "${NODES[@]}"; do
  TARGET_DIR="$WSL_ROOT/$NODE"
  echo "📁 Importiere $NODE nach $TARGET_DIR ..."
  mkdir -p "$TARGET_DIR"
  wsl.exe --import "$NODE" "$TARGET_DIR" "$EXPORT_PATH"

  echo "📝 Setze WSL Konfiguration in $NODE ..."
  wsl.exe -d "$NODE" -- bash -c "echo -e '[user]\ndefault=ubuntu\n[wsl2]\nguiApplications=false' | sudo tee /etc/wsl.conf > /dev/null"

  echo "📜 Erzeuge Init-Skript in $NODE ..."
  echo "$MICROK8S_SETUP" | wsl.exe -d "$NODE" -- bash -c "sudo tee /root/init.sh > /dev/null"
  [[ "$NODE" == "duk-cp1" ]] && echo "$MICROK8S_EXTRA" | wsl.exe -d "$NODE" -- bash -c "sudo tee -a /root/init.sh > /dev/null"
  wsl.exe -d "$NODE" -- bash -c "sudo chmod +x /root/init.sh"

  echo "🚀 Führe MicroK8s Setup in $NODE aus ..."
  wsl.exe -d "$NODE" -- bash -c "sudo /root/init.sh"
done

echo
echo "✅ Alle MicroK8s-WSL-Instanzen wurden erfolgreich eingerichtet:"
for NODE in "${NODES[@]}"; do
  echo "  🖥️  $NODE"
done

echo
echo "👉 Weiter mit:"
echo "    wsl -d duk-cp1"
echo "    microk8s kubectl get nodes"
