Linux Namespaces
================

Die Aufgabe von Linux Namespaces ist es die Ressourcen des Kernsystems (in diesem Falle also des Kernels) voneinander zu isolieren.

### Arten von Namespaces

* IPC -Interprozess-Kommunikation
* NET - Netzwerkressourcen
* PID -Prozess-IDs
* USER - Benutzer/Gruppen-Ids
* (UTS - Systemidentifikation): Über diesen Namespace kann jeder Container einen eigenen Host- und Domänennamen erhalten.

## Beispiele

Die folgenden Befehle sind in einer (Ubuntu) Linux Umgebung ausführen.

### Wechsel in eigener Namespace mit eigenem Netzwerk und Prozess-IDs

    sudo unshare -n  -p --fork  --mount-proc sh
    
Testen ob Prozesse und Netzwerk isoliert sind:

    pstree -p               # zeigt nur Prozess in meinem Namespace
    ping google.com         # kann nicht aufgelöst werden, weil Netzwerk fehlt
    ip addr                 # nur loopback Netzwerkadapter vorhanden
    exit

Verwendung von docker statt sudo unshare und Ausführen der drei obigen Befehle:

    docker run -it alpine sh
    pstree -p               # zeigt nur Prozess in diesem Container
    ping google.com         # kann  aufgelöst werden, weil Docker ein Netzwerk Adapter installiert
    ip addr                 # loopback und Docker Netzwerk Adapter vorhanden
    exit

        
### unshare -Alpine Linux in Linux Namespace betreiben

Folgendes Beispiel holt das Container Image von Alpine Linux entpackt diese im Verzeichnis `myalpine` und wechselt mittels `unshare` 
den Linux Namespaces und setzt den Root `/` auf `myalpine`.

    mkdir myalpine
    docker export $(docker create alpine) | tar -C myalpine -xvf -
    sudo unshare -n -p --fork --mount-proc -R myalpine sh
    cat /etc/issue
    pstree -p -n                # schlägt fehl, kein ubuntu Linux
    pstree -p
    exit
    
### Docker - Wechsel in Container mittels `nsenter` von Linux

    docker run --name mycontainer --rm -d dockercloud/hello-world
    sudo nsenter -t $(docker inspect --format '{{ .State.Pid }}' mycontainer) -a sh
    ps aux  # Sicht innerhalb  des Containers (Namespace)
    exit
    
Prozess-Id ausserhalb des Containers anzeigen
    
    docker inspect --format '{{ .State.Pid }}' mycontainer
    pstree -n -p -T -A
    
### Docker - Wo legt der Container seine Dateien ab?

    sudo -i
    cd $(docker inspect --format '{{ .GraphDriver.Data.MergedDir }}' mycontainer)
    ls -l

### Docker - Netzwerk Adapter im Container

Im Container wird ein Netzwerk Adapter angelegt, welcher, wie eine Pipe, mit dem Container Host Netzwerk verbunden ist.

    sudo -i
    sudo nsenter -t $(docker inspect --format '{{ .State.Pid }}' mycontainer) -a ip addr
    
    # Netzwerk Adapter ausserhalb des Containers
    ip addr

Die Nummer hinter `eth0@if` zeigt auf den Netzwerk Adapter im Container Host.


    
    


    

