# Fehler stoppen wie bei 'set -e'
$ErrorActionPreference = "Stop"

# Basis-Variablen (Pfade ggf. anpassen)
$BASE_DISTRO    = "Ubuntu-24.04"
$BASE_IMAGE     = "D:/WSL/ubuntu.tar"
$WSL_BASE_DIR   = "D:/WSL"
$CLOUD_INIT_DIR = "$env:USERPROFILE\.cloud-init"

# Funktion: Warte auf cloud-init in der angegebenen Instanz
function Wait-ForCloudInit {
    param (
        [string]$instance
    )
    Write-Host "⏳ Warte auf cloud-init in Instanz '$instance'..."

    while ($true) {
        $output = & wsl -d $instance -- cloud-init status 2>$null
        $match = $output | Select-String -Pattern "status:\s*(\S+)"
        if ($match) {
            $status = $match.Matches[0].Groups[1].Value.Trim()
            if ($status -eq "done") {
                Write-Host "✅ cloud-init abgeschlossen."
                return
            } elseif ($status -eq "error") {
                Write-Host "❌ cloud-init Fehler erkannt!"
                throw "cloud-init error"
            }
        }
        Start-Sleep -Seconds 1
    }
}

###############################
# Instanz: Ubuntu 24.04
###############################

# Prüfen, ob Distribution existiert
$distros = & wsl.exe --list
if ($distros -notcontains $BASE_DISTRO) {
    Write-Host "📥 Installiere $BASE_DISTRO ..."
    & wsl --install --no-launch -d $BASE_DISTRO
    & wsl --terminate $BASE_DISTRO
    Start-Sleep -Seconds 15
}

# Exportieren, wenn nötig
if (-not (Test-Path $BASE_IMAGE)) {
    Write-Host "📦 Exportiere $BASE_DISTRO → $BASE_IMAGE ..."
    & wsl.exe --export $BASE_DISTRO $BASE_IMAGE
} else {
    Write-Host "📦 Export bereits vorhanden – überspringe Export."
}

# cloud-init Verzeichnis anlegen
if (-not (Test-Path $CLOUD_INIT_DIR)) {
    New-Item -ItemType Directory -Path $CLOUD_INIT_DIR -Force | Out-Null
}

###############################
# Instanz: duk
###############################

Write-Host "📝 Erstelle cloud-init Skript für duk..."
Copy-Item -Path "../cloud-init-dukmaster.yaml" -Destination "$CLOUD_INIT_DIR\duk.user-data" -Force

# YAML-Anhang
$appendContent = @'
write_files:
- path: /etc/wsl.conf
  append: true
  content: |
    [user]
    default=ubuntu
'@
Add-Content -Path "$CLOUD_INIT_DIR\duk.user-data" -Value $appendContent

# Importieren, wenn nötig
$existingDistros = & wsl -l -q
if ($existingDistros -contains "duk") {
    Write-Host "📦 Distribution 'duk' ist bereits vorhanden – überspringe Import."
} else {
    Write-Host "📥 Importiere 'duk'..."
    & wsl --import duk "$WSL_BASE_DIR\duk" $BASE_IMAGE --version 2
    Wait-ForCloudInit -instance "duk"
    & wsl -t duk
    Write-Host "✅ Instanz 'duk' wurde erstellt."
}

###############################
# Instanz: Intro
###############################

# IP-Adresse von "duk" holen
$output = & wsl -d duk -- hostname -I
$ip = ($output.Split(" ", [System.StringSplitOptions]::RemoveEmptyEntries))[0]

# Ausgabe
Write-Host ""
Write-Host "Docker und Kubernetes"
Write-Host "====================="
Write-Host ""
Write-Host "Umgebung zum Kurs: [Docker und Kubernetes – Übersicht und Einsatz](https://github.com/mc-b/duk)."
Write-Host ""
Write-Host "    wsl -d duk"
Write-Host ""
Write-Host "Dashboard"
Write-Host "---------"
Write-Host ""
Write-Host "Das Kubernetes Dashboard ist erreichbar unter:"
Write-Host "    https://$ip:30443"
Write-Host ""
Write-Host "Beispiele"
Write-Host "---------"
Write-Host ""
Write-Host "Jupyter Notebooks sind erreichbar unter:"
Write-Host "    http://localhost:32188/tree/data/jupyter"
