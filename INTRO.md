Kubernetes
==========

Umgebung zum Kurs: [Docker und Kubernetes – Übersicht und Einsatz](https://github.com/mc-b/duk).

Mit Master verbinden und `microk8s add-node` ausführen. Die Ausgabe ist dann jeweils, mittels Voranstellung von `sudo`, auf dem Worker auszuführen.

    ssh ubuntu@${ip}
    
    microk8s add-node --token-ttl 3600
    exit
    
    ssh ubuntu@${worker_01_ip}
    sudo <Ausgabe von oben>
    exit
    
Die obigen Befehle sind für jeden Worker zu wiederholen.  

Zusätzlich müssen sich die Worker, via NFS, mit dem Master verbinden. Ansonsten funktionieren die Beispiele, die Persistenz verwenden, nicht.

    sudo mount -t nfs ${ip}:/data /data      
    
Dashboard
---------

Das Kubernetes Dashboard ist wie folgt erreichbar.

    https://${fqdn}:8443

Beispiele
---------

Die Umgebung beinhaltet eine Vielzahl von Beispielen als Juypter Notebooks. Die Jupyter Notebook Oberfläche ist wie folgt erreichbar:

    http://${fqdn}:32188/tree
