# 📝 Hyper-V VM Setup mit WSL und Ubuntu Cloud Image (Unsupported!!!)

Dieses Skript automatisiert die Erstellung einer Hyper-V VM auf Windows unter Verwendung von WSL2, einem Ubuntu Cloud Image und einem optionalen Cloud-Init Script. Es basiert auf Ubuntu 24.04 und konfiguriert automatisch alle notwendigen Schritte bis zum Start der VM.

---

## 📦 Voraussetzungen

- Windows mit **WSL2** aktiviert
- **Ubuntu 24.04** als unterstützte WSL-Distribution
- **Hyper-V** aktiviert
- **cloud-init User-Data YAML Datei** im übergeordneten Verzeichnis (`../cloud-init-dukmaster.yaml`)
- PowerShell und Git/Bash

---

## 🧾 Übersicht der Schritte

1. **Prüfen & Installieren von Ubuntu 24.04 (WSL)**
2. **Exportieren der Basis-WSL-Instanz in ein TAR-Image**
3. **Importieren und Konfigurieren einer neuen WSL-Instanz (`ubuntu-builder`)**
4. **Vorbereitung des Ubuntu Cloud Images inklusive Cloud-Init**
5. **Erstellung & Start der Hyper-V VM**

---

## ⚙️ Konfiguration

| Variable         | Beschreibung                                         |
|------------------|------------------------------------------------------|
| `BASE_DISTRO`    | Name der Basis-WSL-Distro                            |
| `BASE_IMAGE`     | Pfad zum exportierten Basis-Image                    |
| `WSL_BASE_DIR`   | Zielverzeichnis für importierte WSL-Instanzen        |
| `BUILDER_DISTRO` | Name der temporären WSL-Instanz zur Image-Vorbereitung |
| `VM_NAME`        | Name der Hyper-V VM                                  |
| `VHDX_PATH_WIN`  | Pfad zur erzeugten VHDX-Datei                        |
| `DISK_SIZE`      | Zielgröße des Cloud Images                           |

---

## 🚀 Schritt-für-Schritt Beschreibung

### 1. Ubuntu 24.04 installieren

- Falls noch nicht vorhanden, wird die Distribution via `wsl --install` installiert.
- Danach wird sie sofort beendet, um sie für den Export vorzubereiten.

### 2. Export des Basis-Images

- Die Distribution wird als `.tar` Datei gespeichert (falls noch nicht vorhanden).

### 3. Import und Setup von `ubuntu-builder`

- Falls noch nicht vorhanden, wird `ubuntu-builder` aus dem `.tar`-Image importiert.
- Ein benutzerdefiniertes `wsl.conf` wird eingerichtet (inkl. `/mnt` Unterstützung und Root-User).
- Installation benötigter Tools innerhalb der WSL-Instanz (`qemu-utils`, `curl`, etc.)

### 4. Vorbereitung des Cloud-Images

- Herunterladen des offiziellen Ubuntu 24.04 Cloud Images.
- Falls vorhanden, wird die Datei `cloud-init-dukmaster.yaml` eingebunden.
- Verwendung von `qemu-nbd` zum Mounten der Image-Partition.
- Cloud-Init-Konfiguration (User-Data & Meta-Data) wird hinzugefügt.
- Image wird auf gewünschte Größe vergrößert.
- Konvertierung zu VHDX-Format für Hyper-V.

### 5. Erstellung & Start der Hyper-V VM

- VM wird mit PowerShell erstellt, falls nicht bereits vorhanden.
- Einstellungen: 4GB RAM, Generation 2, Secure Boot deaktiviert.
- Die VM wird anschließend automatisch gestartet.

---

## 📁 Verzeichnisstruktur

```
.
├── cloud-init-dukmaster.yaml   # Optional, für benutzerdefinierte Cloud-Init Config
├── ubuntu-builder/             # WSL-Builder Instanzverzeichnis
└── D:/Hyper-V/dukmaster/       # Zielverzeichnis für Hyper-V VM und VHDX
```

---

## 🛠️ Wichtige Tools & Befehle

- `wsl.exe --export` / `--import` – für Backup & Wiederherstellung von Distros
- `qemu-img` / `qemu-nbd` – für Image-Verarbeitung
- `parted` – zur Partitions-Analyse im Image
- `powershell.exe` – zur Erstellung der VM

---

## ✅ Ergebnis

Nach erfolgreicher Ausführung:

- Eine Hyper-V VM namens `dukmaster` mit einem vorkonfigurierten Ubuntu 24.04 Image
- Optional vorkonfiguriert mit Cloud-Init
- Sofort einsatzbereit über Hyper-V Manager oder `Start-VM`
