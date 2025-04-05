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
cat <<'EOF' > "$CLOUD_INIT_DIR/duk.user-data"
#cloud-config
users:
  - name: ubuntu
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: users, admin
    shell: /bin/bash
    lock_passwd: false
    plain_text_passwd: 'insecure'
# login ssh and console with password
ssh_pwauth: true
disable_root: false
write_files:
- path: /etc/wsl.conf
  append: true
  content: |
    [user]
    default=ubuntu
packages:
  - jq
runcmd:
  - curl -sfL https://raw.githubusercontent.com/mc-b/lerncloud/main/services/nfsshare.sh | bash -  
  - curl -sfL https://raw.githubusercontent.com/mc-b/lerncloud/main/services/vpn.sh | bash -
  - curl -sfL https://raw.githubusercontent.com/mc-b/lerncloud/main/services/microk8s.sh | bash -
  - curl -sfL https://raw.githubusercontent.com/mc-b/lerncloud/main/services/microk8saddons.sh | bash -
  - sudo su - ubuntu -c "curl -sfL https://raw.githubusercontent.com/mc-b/lerncloud/main/services/repository.sh | bash -s https://github.com/mc-b/duk"
  - sudo su - ubuntu -c "curl -sfL https://raw.githubusercontent.com/mc-b/lerncloud/main/services/istio-zipkin.sh | bash -"
  - sudo su - ubuntu -c "curl -sfL https://raw.githubusercontent.com/mc-b/lerncloud/main/services/istio-patch.sh | bash -"
  - sudo su - ubuntu -c "curl -sfL https://raw.githubusercontent.com/mc-b/lerncloud/main/services/knative.sh | bash -"    
  - sudo su - ubuntu -c "curl -sfL https://raw.githubusercontent.com/mc-b/lerncloud/main/services/knative-patch.sh | bash -"     
  - sudo su - ubuntu -c "curl -sfL https://raw.githubusercontent.com/mc-b/lerncloud/main/services/vault.sh | bash -"
  - sudo su - ubuntu -c "curl -sfL https://raw.githubusercontent.com/mc-b/duk/master/scripts/jupyter-notebook.sh | bash -"  
  - curl -sfL https://raw.githubusercontent.com/mc-b/lerncloud/main/services/k8stools.sh | bash -   
EOF

echo "Importiere duk..."
wsl --import duk "${WSL_BASE_DIR}/duk" "$BASE_IMAGE" --version 2
wait_for_cloud_init duk
wsl -t duk
echo "Instanz duk wurde erstellt."
