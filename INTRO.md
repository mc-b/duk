Kubernetes
==========

Kubernetes Cluster
------------------

Mit Master verbinden und `kubeadm token create` ausführen. 

    sudo kubeadm token create --print-join-command
    
Die Ausgabe von oben ist, mittels Voranstellung von `sudo`, auf den Worker(s) auszuführen.    
    
    sudo <Ausgabe von oben>
    
Zusätzlich müssen sich die Worker, via NFS, mit dem Master verbinden.

    sudo mount -f nfs ${ip}:/data /data    

Beispiele
---------

Die Umgebung beinhaltet eine Vielzahl von Juypter Notebooks. Die Jupyter Notebook Oberfläche ist wie folgt erreichbar:

    http://${ip}:32188/notebooks

Share
-----

Auf dem Master wird ein NFS Share `data` eingerichtet. Dieser ist wie folgt ansprechbar

    \\${ip}\data
