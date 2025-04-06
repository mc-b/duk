# DUK VM

Erstellt in einer WSL Instanz eine DUK Umgebung mit microk8s, Jupyter Notebooks etc.

Installation
* Git/Bash Installieren
* `./setup-duk.sh`

Nach der Installation die WSL Instanz neu starten

    wsl -d duk
    
Mittels Browser Juypter-Notebook öffnen

* [http://localhost:32188/tree/data/jupyter](http://localhost:32188/tree/data/jupyter)
    
### Aufräumen

    wsl --unregister duk    