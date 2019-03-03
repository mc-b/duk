Traefik - Der Cloud Native Edge-Router
======================================

![](https://d33wubrfki0l68.cloudfront.net/7c5fd7d38c371e23cdff059e6cebb10292cd441c/7d420/assets/img/traefik-architecture.svg)

Quelle: traefik.io
- - -

[Traefik](https://traefik.io/) ist ein Reverse-Proxy / Load-Balancer.

Er ist einfach, dynamisch, automatisch, schnell, voll funktionsfähig, Open Source, produktionserprobt, bietet Metriken und lässt sich in alle gängigen Clustertechnologien integrieren

### Installation

Basierend auf der [Kubernetes user guide](https://docs.traefik.io/user-guide/kubernetes/).


Rollen, Gruppen und Namespace anlegen

	kubectl apply -f https://raw.githubusercontent.com/containous/traefik/master/examples/k8s/traefik-rbac.yaml
	
Starten der Pods als DaemonSets
	
	kubectl apply -f https://raw.githubusercontent.com/containous/traefik/master/examples/k8s/traefik-ds.yaml
	
Starten des UI 	
	
	kubectl apply -f https://raw.githubusercontent.com/containous/traefik/master/examples/k8s/ui.yaml
 	
### User Interface

`traefik-ui.lernkube` in `/etc/hosts` Eintragen

	echo "$(kubectl config view -o=jsonpath='{ .clusters[0].cluster.server }' | sed -e 's;https://;' -e 's/:6443//')	trafik-ui.lernkube" | sudo tee -a /etc/hosts 

UI Starten

	kubectl apply -f duk/traefik-ui.yaml
	
User Interface unter [http://traefik-ui.lernkube/dashboard/](http://traefik-ui.lernkube/dashboard/) öffnen.

### Weitere Services mittels Path veröffentlichen

`www.lernkube` in `/etc/hosts` Eintragen

