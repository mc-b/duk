Logging
=======

UI von Kibana mit Testdaten läuft.

TODO
----

* Verbindung fluent-bit nach ElasticSearch - broken connection to quickstart-es-http:9200 
* fluent-bit-ds.yaml - Password aus Secrets holen
* Namespace Verwendung bereinigen

ElasticSearch und Kibana
------------------------

    kubectl apply -f https://download.elastic.co/downloads/eck/1.0.1/all-in-one.yaml
    
    cat <<EOF | kubectl apply -f -
    apiVersion: elasticsearch.k8s.elastic.co/v1
    kind: Elasticsearch
    metadata:
      name: quickstart
    spec:
      version: 7.6.0
      nodeSets:
      - name: default
        count: 1
        config:
          node.master: true
          node.data: true
          node.ingest: true
          node.store.allow_mmap: false
    EOF
    
Monitor cluster health and creation progress

    kubectl get elasticsearch 
    
Password und Test ob bereit

    kubectl port-forward service/quickstart-es-http 9200
    
in einem anderen Fenster
    
    PASSWORD=$(kubectl get secret quickstart-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode)
    curl -u "elastic:$PASSWORD" -k "https://localhost:9200"
    kubectl -n elastic-system logs -f statefulset.apps/elastic-operator

### Deploy a Kibana instance

    cat <<EOF | kubectl apply -f -
    apiVersion: kibana.k8s.elastic.co/v1
    kind: Kibana
    metadata:
      name: quickstart
    spec:
      version: 7.6.0
      count: 1
      elasticsearchRef:
        name: quickstart
    EOF

    kubectl get kibana 
    
Password (User: elastic) und Port forward

    kubectl get secret quickstart-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode; echo
    kubectl port-forward service/quickstart-kb-http 5601
    
### Links    
    
* [ElasticSearch und Kubernetes](https://www.elastic.co/de/downloads/elastic-cloud-kubernetes)
* [QuickStart](https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-quickstart.html)

Fluent
------

    kubectl create namespace logging
    kubectl apply -f duk/logging/fluent-bit-service-account.yaml
    kubectl apply -f duk/logging/fluent-bit-role.yaml
    kubectl apply -f duk/logging/fluent-bit-role-binding.yaml
    kubectl apply -f duk/logging/fluent-bit-configmap.yaml
    kubectl apply -f duk/logging/fluent-bit-ds.yaml    
    
### Links

* [Installation](https://docs.fluentbit.io/manual/installation/kubernetes/) 
* [What you need to know about cluster logging in Kubernetes](https://opensource.com/article/21/11/cluster-logging-kubernetes)