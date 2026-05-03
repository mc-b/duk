Docker und Kubernetes – Übersicht und Einsatz
=============================================

Umgebung zum Kurs: [Docker und Kubernetes – Übersicht und Einsatz](https://github.com/mc-b/duk).

Dashboard bzw. neu Headlamp
---------------------------

Das Kubernetes Dashboard/Headlamp ist wie folgt erreichbar:

    https://${fqdn}:30443
    http://${fqdn}:30444
    
Zugriffstoken für Headlamp erstellen:

    kubectl create token Headlamp-admin -n kube-system   

Beispiele
---------

Die Umgebung beinhaltet eine Vielzahl von Beispielen als Juypter Notebooks. Die Jupyter Lab Oberfläche ist wie folgt erreichbar:

    http://${fqdn}:32188/lab/tree/duk
