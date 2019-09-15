Prometheus
----------

[Prometheus](https://prometheus.io) ist ein Open-Source-Toolkit zur Systemüberwachung und -Alamierung, das ursprünglich bei SoundCloud entwickelt wurde.

Prometheus trat der [Cloud Native Computing Foundation](https://www.cncf.io/) im Jahr 2016 als zweites gehostetes Projekt nach Kubernetes bei.

### Installation

    helm repo add coreos https://s3-eu-west-1.amazonaws.com/coreos-charts/stable/
    helm install coreos/prometheus-operator --name prometheus-operator --namespace monitoring
    helm install coreos/kube-prometheus --name kube-prometheus --namespace monitoring
    helm install --name="kube-metrics" stable/kube-state-metrics --namespace=monitoring

### Beispielapplikation

Für Details siehe [https://coreos.com/blog/the-prometheus-operator.html](https://coreos.com/blog/the-prometheus-operator.html ).
 