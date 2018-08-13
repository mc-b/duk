Gemeinsames Datenverzeichnis
----------------------------

Gemeinsames Datenverzeichnis welches von Kubernetes Master und Nodes genützt wird. Z.B. für
* Kanboard - Datenbank (Plug-Ins im Container, weil sonst Probleme mit Persistent Volume in Kubernetes)
* Gogs - Git Repositories und Datenbank

Details siehe [lernkube](https://github.com/mc-b/lernkube/tree/master/data)