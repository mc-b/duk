# Beispiele zum Kurs: [Docker und Kubernetes – Übersicht und Einsatz ](https://www.digicomp.ch/trends/docker-trainings/docker-und-kubernetes-uebersicht-und-einsatz)

### Lernziele

* Grundkenntnisse zu Container, Cluster, Orchestratoren und Service Discovery, deren Nutzen, Einsatzmöglichkeiten und Einschränkungen
* Verstehen, Beurteilen und Einschätzen des Einsatzes von Container, Cluster, Orchestrierung und Service Discovery in Ihren Projekten
* Umsetzen von Container-Umgebungen

### Quick Start

Installiert [Git/Bash](https://git-scm.com/downloads), [Multipass](https://multipass.run/) und [Terraform](https://www.terraform.io/).

Git/Bash Kommandozeile (CLI) starten und dieses Repository clonen.

    git clone https://github.com/mc-b/duk
    cd duk
    
Terraform Initialisieren und VMs erstellen

    terraform init
    terraform apply
    
Terraform verwendet [Multipass](https://multipass.run/) um mehrere VMs zu erstellen.

Nach erfolgreicher Installation werden weitere Informationen für den Zugriff auf die VMs angezeigt.

### Beispiele und Übungen

* [Jupyter Notebooks](data/jupyter/)

Um die Beispiele vom lokalen Client zu verwenden, kann auf Windows ein Verzeichnis in die VM gelinkt werden.

Beispiel: wir haben ein lokales Verzeichnis `D:/Sourcen/ws` und wollen dieses in der VM als `/ubuntu/home/ws` zur Verfügung stellen.

    multipass set local.privileged-mounts=true
    multipass mount D:/sourcen/ws control-01-default:/home/ubuntu/ws
    
### Lizenz (Attribution-NonCommercial-ShareAlike 4.0 International)

![](http://www.creativecommons.ch/wp-content/uploads/2014/03/by-nc-sa1.png)

Quelle [Creative Commons](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.de)

- - -

* Name muss genannt werden
* keine kommerzielle Nutzung erlaubt
* gleiche Lizenz vorgeschrieben

* Copyright (c) Marcel Bernet, Zürich