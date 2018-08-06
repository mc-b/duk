# Beispiele zum Kurs: [Docker und Kubernetes – Übersicht und Einsatz ](https://www.digicomp.ch/trends/docker-trainings/docker-und-kubernetes-uebersicht-und-einsatz)

### Benötigte Software

* [Git](https://git-scm.com/)
* [VirtualBox](https://www.virtualbox.org/)
* [Vagrant](https://www.vagrantup.com/) Installation 

**Hinweis:** Git auf Windows ohne CR/LF Umwandlung installieren.

Für die weitergehenden Beispiele wird die Ausführbare Datei `docker` benötigt. Trick: Download neuste [Zip-Datei](https://download.docker.com/win/static/stable/x86_64/), diese entpacken und `docker.exe` im PATH ablegen.  

### Installation- Single Node

Projekte [lernkube](https://github.com/mc-b/lernkube), auf der Git/Bash Kommandozeile (CLI), klonen, Konfigurationsdatei `DOK.yaml` kopieren und Installation starten. 

	git clone https://github.com/mc-b/lernkube
	cd lernkube
	cp templates/DOK.yaml config.yaml
	vagrant up

### Installation - Cluster

Bei einem Cluster wird ein Master und 1-n Worker Nodes mit fixen IP-Adressen und einen Default-Gateway benötigt. Ansonsten kann der Cluster zwar eingerichtet werden, die Pods auf den Worker Nodes sind aber nicht erreichbar.

Vorgehen wie **Installation** aber statt `DOK.yaml` Datei `templates/cluster-small.yaml` oder `templates/cluster-large.yaml` nach `config.yaml` kopieren.

Anschliessend sind die fixen IP-Adressen für `master` und `worker` (wird fortlaufend aufgezählt) und `default_router` in `config.yaml` anzupassen. Die Löschung `route del` des Default-Gateway bleibt unverändert lassen. Werden mehr Worker Nodes gewünscht, ist `count` anzupassen.

	worker:
	  count: 1
	...
	ip:
	  master:   192.168.178.200
	  worker:   192.168.178.201
	net:
	  ...
	  default_router: "route add default gw 192.168.178.1 enp0s8 && route del default gw 10.0.2.2 enp0s3"

VM's mittels `vagrant up` erstellen lassen.

Um die Nodes mit einnander zu verbinden, ist in der Master VM der Join Befehl auszuführen. Die Ausgabe Join Befehls ist dann auf den Worker Node(s) auszuführen.

	vagrant ssh master-01 -c "sudo kubeadm token create --print-join-command"
	vagrant ssh worker-01 -c "sudo <Befehlausgabe von oben>"
	
### Testen

Jupyter Oberfläche mittels [Cluster-IP:32188](http://localhost:32188) aufrufen.


	