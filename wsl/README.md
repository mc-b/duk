## DUK VM

Erstellt in einer WSL Instanz eine DUK Umgebung mit microk8s, Jupyter Notebooks etc.

### Installation

Git/Bash Umgebung

    ./setup-duk.sh`

PowerShell (Buggy!)

    powershell.exe Unblock-File .\setup-duk.ps1
    powershell.exe -ExecutionPolicy Unrestricted .\setup-duk.ps1
    .\setup-duk.ps1

Nach der Installation die WSL Instanz neu starten

    wsl -d duk
    
Mittels Browser Juypter-Notebook öffnen

* [http://localhost:32188/tree/data/jupyter](http://localhost:32188/tree/data/jupyter)
    
### Aufräumen

    wsl --unregister Ubuntu-24.04
    rm D:/wsl/ubuntu.tar 
    wsl --unregister duk
    wsl --shutdown
    
     