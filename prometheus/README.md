Prometheus
----------

![](https://prometheus.io/assets/architecture.png)

Quelle: [Prometheus](https://prometheus.io) 

- - -

[Prometheus](https://prometheus.io) ist ein Open-Source-Toolkit zur Systemüberwachung und -Alamierung, das ursprünglich bei SoundCloud entwickelt wurde.

Prometheus trat der [Cloud Native Computing Foundation](https://www.cncf.io/) im Jahr 2016 als zweites gehostetes Projekt nach Kubernetes bei.

### Installation

    helm repo add coreos https://s3-eu-west-1.amazonaws.com/coreos-charts/stable/
    helm install coreos/prometheus-operator --name prometheus-operator --namespace monitoring
    helm install coreos/kube-prometheus --name kube-prometheus --namespace monitoring
    helm install --name="kube-metrics" stable/kube-state-metrics --namespace=monitoring

Um die entsprechenden UIs ansprechen zu können muss der jeweilige Port an `localhost` weitergeleitet werden:

Für Grafana (Service: kube-prometheus-grafana) ist dies und das UI mit URL [http://localhost:3000](http://localhost:3000) ist das:

    kubectl -n monitoring port-forward $(kubectl -n monitoring get pod -l app=kube-prometheus-grafana -o jsonpath={.items[0].metadata.name}) 3000

Für Prometheus (Service: kube-prometheus) und das UI mit URL [http://localhost:9090](http://localhost:9090) ist das:

    kubectl -n monitoring port-forward $(kubectl -n monitoring get pod -l app=prometheus -o jsonpath={.items[0].metadata.name}) 9090
    
Die verwalteten Ressourcen sind unter -> Status -> Targets ersichtlich.    

### Beispielapplikation

Für Details siehe [https://coreos.com/blog/the-prometheus-operator.html](https://coreos.com/blog/the-prometheus-operator.html ).
 