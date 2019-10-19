Istio
=====

Cloud-Plattformen bieten den Unternehmen, die sie verwenden, zahlreiche Vorteile.

Dazu müssen Entwickler das Architekturmuster Microservices verwenden, was dazu führt das schnell Unterschiedliche Versionen von Microservices parallel betrieben werden müssen.

Mit den vielfältigen Funktionen von [Istio](http://istio.io) kann man eine verteilte Microservice-Architektur erfolgreich und effizient ausführen und auf einheitliche Weise Microservices absichern, verbinden und überwachen.

Es ist ein vollständiger Open-Source-Service-Mesh, das auf vorhandenen verteilten Anwendungen aufbaut.

Was ist ein Service-Mesh?
-------------------------

Der Begriff Service-Mesh beschreibt das Netzwerk von Microservices und die Wechselwirkungen zwischen ihnen. 

Je grösser und komplexer ein Service-Mesh wird, desto schwieriger ist es, es zu verstehen und zu verwalten. 

Zu den Anforderungen zählen Erkennung, Lastenausgleich, Fehlerbehebung, Metriken und Überwachung. 

Ein Service-Mesh hat häufig komplexere betriebliche Anforderungen, wie A/B-Tests (Bewertung zweier Varianten), Canary-Rollouts, Beschränkungen, Zugangskontrolle und End-to-End-Authentifizierung.

Weitere Informationen: [Istio Homepage](https://istio.io/docs/concepts/what-is-istio/)

Installation
------------

Vor der Installation müss Sichergestellt werden, dass der Cluster min. 4 CPU pro Node und min. 16 GB haben. 

Wechsel in der Virtuelle Machine mit Kubernetes und folgendes darin ausführen:

    vagrant ssh master-01
    curl -L https://git.io/getLatestIstio | ISTIO_VERSION=1.3.3 sh -
    cd istio-1.3.3
    export PATH=$PWD/bin:$PATH
    
Anschliessend können wir die [Demo Installation Variante](https://istio.io/docs/setup/install/kubernetes/#installation-steps) installieren:

    for i in install/kubernetes/helm/istio-init/files/crd*yaml; do kubectl apply -f $i; done
    kubectl apply -f install/kubernetes/istio-demo.yaml
    
Mittels den nachfolgenden Befehlen können wir kontrollieren ob die Installation erfolgreich war:

    kubectl get pods,services -n istio-system 
    
Es müssten > 10 Pods und 2 Jobs laufen und eine etwa gleiche Anzahl von Services erstellt worden sein.

Mittels den zwei nachfolgenden Befehlen bekommen wir die IP-Adresse des Kubernetes Cluster und der Istio Port:

    kubectl cluster-info
    kubectl get service -n istio-system istio-ingressgateway   -o=jsonpath='{.spec.ports[1].nodePort}'

Beide Informationen brauchen um den URL der Beispiele zusammen zu setzen.

Um die Installation abzuschliessen, müssen wir festlegen welche Namespaces von Istio verwaltet werden. Dazu ist der Namespace mit dem Label `istio-injection=enabled` zu kennzeichnen, z.B.:

    kubectl label namespace default istio-injection=enabled
    
Alle Pods in diesem Namespace bekommen automatisch einen *Side Car* und der Netzwerkverkehr wird über Istio abgehandelt.    

Istio Beispielanwendung
-----------------------

Die Beispielanwendung zeigt Informationen zu einem Buch an, ähnlich einem einzelnen Katalogeintrag eines Online-Buchladens. Auf der Seite werden eine Beschreibung des Buches, Buchdetails (ISBN, Seitenzahl usw.) und einige Buchbesprechungen angezeigt.

Für Details siehe [Bookinfo Application](https://istio.io/docs/examples/bookinfo/)

    kubectl create namespace bookinfo
    kubectl label namespace bookinfo istio-injection=enabled
    kubectl apply -f istio-1.3.3/samples/bookinfo/platform/kube/bookinfo.yaml -n bookinfo
    kubectl apply -f istio-1.3.3/samples/bookinfo/networking/bookinfo-gateway.yaml -n bookinfo
    kubectl apply -f istio-1.3.3/samples/bookinfo/networking/destination-rule-all.yaml -n bookinfo
    
Die Applikation kann mittels [http://<cluster>:<port istio>/productpage](http://192.168.137.100:31380/productpage) erreicht werden.

Beispiel Web Server V1 und V2
-----------------------------

Das Beispiel startet zwei Pods mit Version 1 und Version 2 eines Services.

    kubectl create namespace web
    kubectl label namespace web istio-injection=enabled    
    kubebctl apply -f duk/istio/ -n web

Der Service wird mittels `Gateway` und `VirtualService` auf dem URL [http://<cluster>:<port istio>/web/](http://192.168.137.100:31380/web/) veröffentlicht.

Eine `DestinationRule` ermöglicht es zwischen Version 1 und 2 zu wechseln.

Ohne eine expliziete Zuweisung werden Version 1 und 2 abwechselnd angezeigt.

Wechsel auf Version 1:

    kubectl apply -f duk/istio/v1 -n web
    
Wechsel auf Version 2:

    kubectl apply -f duk/istio/v2 -n web

Links
-----

* [Istio](https://istio.io)
* [Istio Installation](https://istio.io/docs/setup/)
* [Bookinfo Application](https://istio.io/docs/examples/bookinfo/)
* [Back to Microservices Part I + II](https://medium.com/google-cloud/back-to-microservices-with-istio-p1-827c872daa53)
* [Istio Authentifizierung](https://istio.io/docs/concepts/security/#authentication)
* [Blog: Using Istio to secure multi-cloud Kubernetes applications with zero code change](https://istio.io/blog/2019/app-identity-and-access-adapter/)
* [Securing Kubernetes Clusters with Istio and Auth0](https://auth0.com/blog/securing-kubernetes-clusters-with-istio-and-auth0/)
* [Auth0 Beispiele](https://auth0.com/docs/quickstart/webapp)
* [Canary Deployments using Istio](https://istio.io/blog/2017/0.1-canary/)
    