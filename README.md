# Beispiele zum Kurs: [Docker und Kubernetes – Übersicht und Einsatz ](https://www.digicomp.ch/trends/docker-trainings/docker-und-kubernetes-uebersicht-und-einsatz)

### Quick Start

Installiert [Git/Bash](https://git-scm.com/downloads), [Vagrant](https://www.vagrantup.com/) und [VirtualBox](https://www.virtualbox.org/).

Projekt [lernkube](https://github.com/mc-b/lernkube), auf der Git/Bash Kommandozeile (CLI), klonen, Konfigurationsdatei `DOK.yaml` kopieren und Installation starten. 

	git clone https://github.com/mc-b/lernkube
	cd lernkube
	cp templates/DOK.yaml config.yaml
	vagrant plugin install vagrant-disksize
	vagrant up

Öffnet die Interaktive Lernumgebung mittels [http://localhost:32188](http://localhost:32188), wechselt in das Verzeichnis `work` und wählt ein Notebook (ipynp Dateien) an.	

**Weitere Installationsmöglichkeiten und Details** zur Installation siehe Projekt [lernkube](https://github.com/mc-b/lernkube).

### Weitere Beispiele

* [Internet der Dinge](iot)
* [OS Ticket](osticket)
* [MySQL und Adminer](mysql)
* [Compiler](compiler)
* [Big Data](bigdata)
* [Helm](helm)
* [DevOps Umgebung](devops)
* [Microservice Beispiele](https://github.com/mc-b/misegr)
* [Interaktives Lernen mit Jupyter/BeakerX](jupyter)
* [Tests - ohne Beschreibung](test)
* [Docker Registry (insecure!)](registry/)

### Hilfsscripts

Nach der Installation stehen im Verzeichnis `master-01` folgende Scripts zur Verfügung:

* `dashboard` - Öffnet das Kubernets Dashboard
* `dockerps.bat` - Setzt die Umgebungsvariablen für den Zugriff auf K8s und startet PowerShell
* `dockersh.bat` - Setzt die Umgebungsvariablen für den Zugriff auf K8s und startet die Git/Bash Shell (Git/Bash muss Installiert sein).

Nach dem Starten von PowerShell oder Bash stehen zusätzlich, folgende Befehle zur Verfügung:

* `runbash <name>` - Wechselt in die Bash eines Laufenden Pods (braucht ein Deployment)
* `startsvc <name>` - Öffnet die Weboberfläche eines Services
* `weave` - Öffnet die Weave Scope Weboberfläche

### Starten und Stoppen von Containern/Pods

Nach der Installation können Container/Pods mittels dem CLI [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) oder via Weboberfläche gestartet werden.

Am einfachsten ist es wenn eine Beschreibung im YAML Format, z.B. [fhem.yaml](iot/fhem.yaml) vorhanden ist.

Z.B. FHEM Hausautomation Service starten

	kubectl create -f iot/fhem-port.yaml
	
Alle erstellte Objekte anzeigen lassen

	kubectl get all -o wide	
	
oder 

	kubectl get pods,service,deployment,replicaset -o wide --selector=app=fhem-port
	
Es sollte ein Pod, mit einem Replica-Set, einem Deployment und einen Service, jeweils mit `fhem-port` gelabbelt, vorhanden sein. Dem Services wurde der nächste freie Port der Node zugewiesen. 

	kubectl get service -o wide --selector=app=fhem-port
	
Der URL ergibt sich aus der IP-Adresse der Node und dem Angezeigten Port, z.B. 

    http://192.168.137.100:30252
    
Oder wenn NodePort IP und Port automatisch ermittelt werden soll:
 
	echo "http"$(kubectl config view -o=jsonpath='{ .clusters[0].cluster.server }' \
	| sed -e 's/https//g' -e 's/:6443//g')":"$(kubectl get svc fhem-port -o=jsonpath='{ .spec.ports[0].nodePort }') 
	
In Kombination mit `curl`

	curl $(echo "http"$(kubectl config view -o=jsonpath='{ .clusters[0].cluster.server }' \
	| sed -e 's/https//g' -e 's/:6443//g')":"$(kubectl get svc fhem-port -o=jsonpath='{ .spec.ports[0].nodePort }')"/fhem")	 
	
In in `PowerShell` mit Start Standard Browser

	start (kubectl config view -o=jsonpath='{ .clusters[0].cluster.server }' | `
	%{ $_-replace "https:","http:"} | `
	%{ $_-replace "6443", (kubectl get svc fhem-port -o=jsonpath='{ .spec.ports[0].nodePort }')})/fhem

Stoppen und Löschen (löscht den Service, die Bereitstellung und den Zugriff via /path).

	kubectl delete service,deployments,ingresses fhem

Alternativ kann ein Container/Pod zum Arbeiten auf der CLI gestartet werden:

	kubectl create -f test/debian.yaml
	
Wechsel in das CLI des Containers/Pods

	kubectl exec -it debian -- bash

	