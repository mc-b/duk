Kubernetes
==========

Umgebung zum Kurs: [Docker und Kubernetes – Übersicht und Einsatz](https://github.com/mc-b/duk).

Die VMs wurden bereits erstellt. Um die VMs zu einem Kubernetes Cluster zu verbinden ist wie folgt vorzugehen:

Auf dem Master (${ip}) folgenden Befehl ausführen:

    sudo kubeadm token create --print-join-command
    
Die Ausgabe ist dann auf jedem Worker (${ip_01} etc.), mittels Voranstellung von `sudo`, auszuführen.    
    
    sudo <Ausgabe von oben>
    
Zusätzlich müssen sich die Worker, via NFS, mit dem Master verbinden. Ansonsten funktionieren die Beispiele, die Persistenz verwenden, nicht.

    sudo mount -t nfs ${ip}:/data /data    
    
Dashboard
---------

Das Kubernetes Dashboard ist wie folgt erreichbar.

    https://${fqdn}:8443
    
Der benötigte Token steht in der Datei `~/data/token.txt`.    

Beispiele
---------

Die Umgebung beinhaltet eine Vielzahl von Beispielen als Juypter Notebooks. Die Jupyter Notebook Oberfläche ist wie folgt erreichbar:

    http://${fqdn}:32188

Share
-----

Auf dem Master wird ein NFS Share `data` eingerichtet. Dieser ist wie folgt ansprechbar

    \\${fqdn}\data
