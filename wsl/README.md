# DUK VM

Erstellt in einer WSL Instanz eine DUK Umgebung mit microk8s, Jupyter Notebooks etc.

Installation
* Git/Bash Installieren
* Ubuntu 24.04 installieren `winget install --id Canonical.Ubuntu.2404`
* `bash -x setup-duk.sh`
* `$HOME/AppData/Local/Microsoft/WindowsApps` muss sich im PATH befinden

Nach der Installation die WSL Instanz neu starten

    wsl -d duk
    
Mittels Browser Juypter-Notebook öffnen

* [http://localhost:32188/tree/data/jupyter](http://localhost:32188/tree/data/jupyter)
    
### Aufräumen

    wsl --unregister duk    