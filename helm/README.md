Helm
----

![](https://helm.sh/img/chart-illustration.png)

Quelle: https://helm.sh/
- - - 

[Helm](https://helm.sh/) ist ein Werkzeug zur Verwaltung von Kubernetes-Charts. 

[Kubernetes-Charts](https://github.com/helm/charts) sind Pakete vorkonfigurierter Kubernetes-Ressourcen, welche wie Gesamthaft mittels eines Befehles installiert werden können.

Der [Helm Hub](https://hub.helm.sh) enthält Dokumentationen und Konfigurationenen für die von Helm gehosteten Charts.

Helm Einsatzgebiete:
* Suchen und verwenden Sie beliebte Software, die als Kubernetes-Charts verpackt ist
* Teilen Sie Ihre eigenen Anwendungen als Kubernetes-Charts
* Erstellen Sie reproduzierbare Builds Ihrer Kubernetes-Anwendungen
* Verwalten Sie Ihre Kubernetes-Manifestdateien auf intelligente Weise
* Verwalten Sie Releases von Helm-Paketen

### Installation (ab Version 3.x)

Download von Helm, verschieben nach `/usr/local/bin` und hinzufügen des Standard Repositories:

    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
    helm repo add stable https://kubernetes-charts.storage.googleapis.com/

### Services starten

#### Jenkins

	helm install myjenkins stable/jenkins
	
Anschliessend ist zu Verfahren wie auf der Console angezeigt wird.

### FAQ

* [Helm: Error: no available release name found](https://stackoverflow.com/questions/43499971/helm-error-no-available-release-name-found)


