Prometheus
----------

![](https://prometheus.io/assets/architecture.png)

Quelle: [Prometheus](https://prometheus.io) 

- - -

[Prometheus](https://prometheus.io) ist ein Open-Source-Toolkit zur Systemüberwachung und -Alamierung, das ursprünglich bei SoundCloud entwickelt wurde.

Prometheus trat der [Cloud Native Computing Foundation](https://www.cncf.io/) im Jahr 2016 als zweites gehostetes Projekt nach Kubernetes bei.

### Installation

    kubectl create namespace monitoring
    helm repo add stable https://kubernetes-charts.storage.googleapis.com
    helm install prometheus-operator stable/prometheus-operator --namespace=monitoring

Um die entsprechenden UIs ansprechen zu können muss der jeweilige Port an `localhost` weitergeleitet werden:

Für den **Grafana (Service: prometheus-operator-grafana)** mit URL [http://localhost:3000](http://localhost:3000) ist der Befehl:

    kubectl port-forward  --namespace=monitoring $(kubectl get pods --selector=app=grafana --namespace=monitoring --output=jsonpath="{.items..metadata.name}") 3000
    
Username/Password: admin/prom-operator

Dann kann z.B. die Informationen zu den Nodes mittels -> Nodes statt Home angezeigt werden.    

Für den **Prometheus (Service: prometheus-operator-prometheus)** mit URL [http://localhost:9090](http://localhost:9090) ist der Befehl:

    kubectl -n monitoring port-forward $(kubectl -n monitoring get pod -l app=prometheus -o jsonpath={.items[0].metadata.name}) 9090
    
Die verwalteten Ressourcen sind unter -> Status -> Targets ersichtlich.    

### Links

* [Original Blogeintrag](https://dev.to/reoring/deploy-prometheus-grafana-to-kubernetes-by-helm-3-1485)
* [Beispiel Applikation (evtl. veraltet)](https://coreos.com/blog/the-prometheus-operator.html ).
 