Jupyter
-------

![](https://jupyter.org/assets/main-logo.svg)

- - -

### Jupyter

Project Jupyter hat sich zum Ziel gesetzt, Open-Source-Software, offene Standards und Services, für interaktives Computing, in Dutzenden von Programmiersprachen zu entwickeln.

Starten:

	kubectl create -f duk/jupyter/jupyter.yaml
	
Web Oberfläche mittels [Cluster-IP:32388](http://localhost:32388) anwählen.

Das Verzeichnis `work` zeigt ins lokale Verzeichnis `data/jupyter`, d.h. die Daten bleiben auch nach Beenden des Containers, der VM erhalten. Siehe auch [Gemeinsames Datenverzeichnis](../data/).

Beispiele für Machine Learning findet man auf [https://notebooks.azure.com/djcordhose/libraries/buch](https://notebooks.azure.com/djcordhose/libraries/buch). Diese können mittels Download und Upload in die Jupyter Umgebung importiert werden.

### BeakerX

BeakerX ist eine Sammlung von Kerneln und Erweiterungen der interaktiven Jupyter- Computerumgebung. Es bietet JVM-Unterstützung, interaktive Diagramme, Tabellen, Formulare, Publizierung und mehr. 

Starten:

	kubectl create -f duk/jupyter/beakerx.yaml
	
Web Oberfläche mittels [Cluster-IP:32088](http://localhost:32088) anwählen.

Das Verzeichnis `work` zeigt ins lokale Verzeichnis `data/jupyter`, d.h. die Daten bleiben auch nach Beenden des Containers, der VM erhalten. Siehe auch [Gemeinsames Datenverzeichnis](../data/).

### Jupyter Base

Abgespeckte Variante von Jupyter nur mit Python und Bash Unterstützung, u.a. für Docker Kurse verwendet.

Starten:

	kubectl create -f duk/jupyter/jupyter-base.yaml
	
Web Oberfläche mittels [Cluster-IP:32188](http://localhost:32188) anwählen.

Das Verzeichnis `work` zeigt ins lokale Verzeichnis `data/jupyter`, d.h. die Daten bleiben auch nach Beenden des Containers, der VM erhalten. Siehe auch [Gemeinsames Datenverzeichnis](../data/).
