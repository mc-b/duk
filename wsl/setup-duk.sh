#!/bin/bash
set -e

# Basis-Variablen (Passe den Pfad ggf. an)
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

wsl --install --no-launch -d Ubuntu-24.04
ubuntu2404.exe install --root
wsl --terminate Ubuntu-24.04
wsl --export Ubuntu-24.04 ${WSL_BASE_DIR}/ubuntu.tar

# Sicherstellen, dass das cloud-init Verzeichnis existiert
mkdir -p "$CLOUD_INIT_DIR"

###############################
# Instanz: duk-cp1
###############################

echo "Erstelle cloud-init Skript für duk-cp1..."
cat <<'EOF' > "$CLOUD_INIT_DIR/duk-cp1.user-data"
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
  - curl -sfL https://raw.githubusercontent.com/mc-b/lerncloud/main/services/microk8s.sh | bash -
  - curl -sfL https://raw.githubusercontent.com/mc-b/lerncloud/main/services/microk8saddons.sh | bash -
EOF

echo "Importiere duk-cp1..."
wsl --import duk-cp1 "${WSL_BASE_DIR}/duk-cp1" "$BASE_IMAGE" --version 2
wait_for_cloud_init duk-cp1
wsl -t duk-cp1
echo "Instanz duk-cp1 wurde erstellt."

###############################
# Instanz: duk-cp2
###############################

echo "Erstelle cloud-init Skript für duk-cp2..."
cat <<'EOF' > "$CLOUD_INIT_DIR/duk-cp2.user-data"
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
  - curl -sfL https://raw.githubusercontent.com/mc-b/lerncloud/main/services/nfsclient.sh | bash -
  - curl -sfL https://raw.githubusercontent.com/mc-b/lerncloud/main/services/microk8s.sh | bash -
EOF

echo "Importiere duk-cp2..."
wsl --import duk-cp2 "${WSL_BASE_DIR}/duk-cp2" "$BASE_IMAGE" --version 2
wait_for_cloud_init duk-cp2
wsl -t duk-cp2
echo "Instanz duk-cp2 wurde erstellt."

###############################
# Instanz: duk-cp3
###############################

echo "Erstelle cloud-init Skript für duk-cp3..."
cat <<'EOF' > "$CLOUD_INIT_DIR/duk-cp3.user-data"
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
  - curl -sfL https://raw.githubusercontent.com/mc-b/lerncloud/main/services/nfsclient.sh | bash -
  - curl -sfL https://raw.githubusercontent.com/mc-b/lerncloud/main/services/microk8s.sh | bash -
EOF

echo "Importiere duk-cp3..."
wsl --import duk-cp3 "${WSL_BASE_DIR}/duk-cp3" "$BASE_IMAGE" --version 2
wait_for_cloud_init duk-cp3
wsl -t duk-cp3
echo "Instanz duk-cp3 wurde erstellt."

echo "Alle Instanzen wurden erfolgreich erstellt."
