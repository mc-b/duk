# Beispiele zum Kurs: [Docker und Kubernetes – Übersicht und Einsatz ](https://www.digicomp.ch/trends/docker-trainings/docker-und-kubernetes-uebersicht-und-einsatz)

### Benötigte Software

* [Git](https://git-scm.com/)
* [VirtualBox](https://www.virtualbox.org/)
* [Vagrant](https://www.vagrantup.com/) Installation 

**Hinweis:** Git auf Windows ohne CR/LF Umwandlung installieren.

Für die weitergehenden Beispiele wird die Ausführbare Datei `docker` benötigt. Trick: Download neuste [Zip-Datei](https://download.docker.com/win/static/stable/x86_64/), diese entpacken und `docker.exe` im PATH ablegen.  

### Installation

Projekte [lernkube](https://github.com/mc-b/lernkube), auf der Git/Bash Kommandozeile (CLI), klonen, Konfigurationsdatei `DOK.yaml` kopieren und Installation starten. 

	git clone https://github.com/mc-b/lernkube
	cd lernkube
	cp templates/DOK.yaml config.yaml
	vagrant up

### Cluster einrichten

Dazu ist zuerst, in Git/Bash CLI, in der Master VM der Join Befehl auszuführen. Die Ausgabe Join Befehls ist dann auf den Worker Node(s) auszuführen.

	vagrant ssh master-01 -c "	sudo kubeadm token create --print-join-command"
	vagrant ssh worker-01 -c "sudo <Befehlausgabe von oben>"
	
### Testen

Jupyter Oberfläche mittels [Cluster-IP:32188](http://localhost:32188) aufrufen.


	