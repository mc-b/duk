
# Unterlagen
resource "null_resource" "desktop_url_documents" {
  provisioner "local-exec" {
    interpreter = ["PowerShell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command"]

    command = <<EOT
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$ShortcutPath = Join-Path $DesktopPath "Unterlagen.url"

@"
[InternetShortcut]
URL=http://control-01-default.mshome.net:18888/lab/tree/Documents
IconFile=C:\Windows\System32\shell32.dll
IconIndex=220
"@ | Set-Content -Path $ShortcutPath -Encoding ASCII
EOT
  }

  provisioner "local-exec" {
    when        = destroy
    interpreter = ["PowerShell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command"]

    command = <<EOT
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$ShortcutPath = Join-Path $DesktopPath "Unterlagen.url"

if (Test-Path $ShortcutPath) {
  Remove-Item -Path $ShortcutPath -Force
}
EOT
  }
}

# Übungen
resource "null_resource" "desktop_url_exercises" {
  provisioner "local-exec" {
    interpreter = ["PowerShell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command"]

    command = <<EOT
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$ShortcutPath = Join-Path $DesktopPath "Übungen.url"

@"
[InternetShortcut]
URL=http://control-01-default.mshome.net:18888/lab/tree/duk
IconFile=C:\Windows\System32\shell32.dll
IconIndex=220
"@ | Set-Content -Path $ShortcutPath -Encoding ASCII
EOT
  }
  provisioner "local-exec" {
    when        = destroy
    interpreter = ["PowerShell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command"]

    command = <<EOT
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$ShortcutPath = Join-Path $DesktopPath "Übungen.url"

if (Test-Path $ShortcutPath) {
  Remove-Item -Path $ShortcutPath -Force
}
EOT
  }
}

# K8s Dashboard
resource "null_resource" "desktop_url_dashboard" {
  provisioner "local-exec" {
    interpreter = ["PowerShell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command"]

    command = <<EOT
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$ShortcutPath = Join-Path $DesktopPath "Dashboard.url"

@"
[InternetShortcut]
URL=https://control-01-default.mshome.net:30443
IconFile=C:\Windows\System32\shell32.dll
IconIndex=220
"@ | Set-Content -Path $ShortcutPath -Encoding ASCII
EOT
  }
  provisioner "local-exec" {
    when        = destroy
    interpreter = ["PowerShell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command"]

    command = <<EOT
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$ShortcutPath = Join-Path $DesktopPath "Dashboard.url"

if (Test-Path $ShortcutPath) {
  Remove-Item -Path $ShortcutPath -Force
}
EOT
  }
}

# Headlamp
resource "null_resource" "desktop_url_headlamp" {
  provisioner "local-exec" {
    interpreter = ["PowerShell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command"]

    command = <<EOT
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$ShortcutPath = Join-Path $DesktopPath "Headlamp.url"

@"
[InternetShortcut]
URL=http://control-01-default.mshome.net:30444
IconFile=C:\Windows\System32\shell32.dll
IconIndex=220
"@ | Set-Content -Path $ShortcutPath -Encoding ASCII
EOT
  }
  provisioner "local-exec" {
    when        = destroy
    interpreter = ["PowerShell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command"]

    command = <<EOT
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$ShortcutPath = Join-Path $DesktopPath "Headlamp.url"

if (Test-Path $ShortcutPath) {
  Remove-Item -Path $ShortcutPath -Force
}
EOT
  }
}