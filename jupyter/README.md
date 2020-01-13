Jupyter
-------

![](https://jupyter.org/assets/main-logo.svg)

- - -

### Jupyter Base

Abgespeckte Variante von Jupyter nur mit Python und Bash Unterstützung, u.a. für Docker Kurse verwendet.

Starten:

    kubectl create -f duk/jupyter/jupyter-base.yaml
    
Web Oberfläche mittels [Cluster-IP:32188](http://localhost:32188) anwählen.

Das Verzeichnis `work` zeigt ins lokale Verzeichnis `data/jupyter`, d.h. die Daten bleiben auch nach Beenden des Containers, der VM erhalten. Siehe auch [Gemeinsames Datenverzeichnis](../data/).

### BeakerX

BeakerX ist eine Sammlung von Kerneln und Erweiterungen der interaktiven Jupyter- Computerumgebung. Es bietet JVM-Unterstützung, interaktive Diagramme, Tabellen, Formulare, Publizierung und mehr. 

Starten:

	kubectl create -f duk/jupyter/beakerx.yaml
	
Web Oberfläche mittels [Cluster-IP:32088](http://localhost:32088) anwählen.

Das Verzeichnis `work` zeigt ins lokale Verzeichnis `data/jupyter`, d.h. die Daten bleiben auch nach Beenden des Containers, der VM erhalten. Siehe auch [Gemeinsames Datenverzeichnis](../data/).

### Weitere Beispiele

* [Machine Learning](https://github.com/mc-b/mlg)
* [Unterrichten mit Jupyter Notebooks](https://github.com/tbz-k8s/vertiefungsarbeit), Vertiefungsarbeit an der TBZ HF.

