KubeLess
--------

Kubeless ist ein natives serverloses Framework, mit dem Sie kleine Code-Bits (Funktionen) bereitstellen können, ohne sich um die zugrunde liegende Infrastruktur kümmern zu müssen. Es wurde entwickelt, um auf einem Kubernetes-Cluster eingesetzt zu werden und alle großen Kubernetes-Primitive zu nutzen.

### Installation

* kubeless CLI downloaden

	kubectl create -f RBCA.yaml
	

### Sprachen

Examples aus dem Projekt [kubeless]() clonen.

	git clone https://github.com/kubeless/kubeless

#### Python

#### JavaScript

**Deployen**

	cd kubeless/examples/nodejs
	
	kubeless function deploy helloget --runtime nodejs8 \
	                                --handler test.helloget \
	                                --from-file helloget.js
	                                
**Testen**

	                               


### Links

* [Homepage](https://kubeless.io/)
* [Dokumentation](https://kubeless.io/docs/)
* [Unterstützte Sprachen](https://kubeless.io/docs/runtimes/)



### FAQ

**Function pod is crashing**

Alle Pods zu den Funktionen ausgeben 

	kubectl get pods -l function
	
Logs zu einer Funktion ausgeben

	kubectl logs $(kubectl get pods -l function=$1 -o jsonpath='{.items..metadata.name}')


