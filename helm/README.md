Helm
----

![](https://helm.sh/img/chart-illustration.png)

Quelle: https://helm.sh/
- - - 

[Helm](https://helm.sh/) ist ein Werkzeug zur Verwaltung von Kubernetes-Charts. 

[Kubernetes-Charts](https://github.com/helm/charts) sind Pakete vorkonfigurierter Kubernetes-Ressourcen, welche wie Gesamthaft mittels eines Befehles installiert werden können

Helm Einsatzgebiete:
* Suchen und verwenden Sie beliebte Software, die als Kubernetes-Charts verpackt ist
* Teilen Sie Ihre eigenen Anwendungen als Kubernetes-Charts
* Erstellen Sie reproduzierbare Builds Ihrer Kubernetes-Anwendungen
* Verwalten Sie Ihre Kubernetes-Manifestdateien auf intelligente Weise
* Verwalten Sie Releases von Helm-Paketen

### Installation 

Erstellen der nötigen Services Accounts

    kubectl create serviceaccount --namespace kube-system tiller
    kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
    
Initialisierung Tiller auf dem K8s Cluster. Tiller nimmt die Befehle von Helm entgegen und führt diese aus:

    helm init --service-account=tiller --debug

### Services starten

#### Drupal

Quelle: https://github.com/kubernetes/charts/tree/master/stable/drupal

Installation

	helm install --name mydrupal stable/drupal --set serviceType=LoadBalancer
	
Userinterface aufrufen

	startsvc mydrupal-drupal
	
* User: user
* Password: `kubectl get secret --namespace default mydrupal-drupal -o jsonpath="{.data.drupal-password}" | base64 --decode`

#### Jenkins

	helm install --name myjenkins stable/jenkins
	
* User: admin
* Password: `kubectl get secret --namespace default myjenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode`

Userinterface aufrufen

    startsvc myjenkins

### FAQ

* [Helm: Error: no available release name found](https://stackoverflow.com/questions/43499971/helm-error-no-available-release-name-found)


