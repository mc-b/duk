KubeLess
--------

Kubeless ist ein natives serverloses Framework, mit dem Sie kleine Code-Bits (Funktionen) bereitstellen können, ohne sich um die zugrunde liegende Infrastruktur kümmern zu müssen. Es wurde entwickelt, um auf einem Kubernetes-Cluster eingesetzt zu werden und alle großen Kubernetes-Primitive zu nutzen.

### Installation

* kubeless CLI von der [Release Page](https://github.com/kubeless/kubeless/releases) downloaden und z.B. in Verzeichnis `lernkube/bin` abstellen.
* `kubeless` Namespace erstellen und Umgebung starten 

	export RELEASE=$(curl -s https://api.github.com/repos/kubeless/kubeless/releases/latest | grep tag_name | cut -d '"' -f 4)
	kubectl create ns kubeless
	kubectl create -f https://github.com/kubeless/kubeless/releases/download/$RELEASE/kubeless-$RELEASE.yaml
	
**Optional** Hello World Beispiel installieren

	kubeless function deploy hello --runtime python2.7 \
                                --from-file duk/kubeless/test.py \
                                --handler test.hello

Testen

	kubeless function call hello --data 'Hello world!'	
	
Zugriff via Ingress
* Funktion als HTTP Trigger veröffentlichen
* Aufruf der Funktion via Ingress, die IP Adresse ist ggf. anzupassen

	kubeless trigger http create hello --function-name hello
	curl http://192.168.137.100:30080 --header "Host: hello.192.168.137.100.nip.io"  -d "Hello World!"

**Optional** UI Installieren

	kubectl create -f https://raw.githubusercontent.com/kubeless/kubeless-ui/master/k8s.yaml


### Sprachen

Examples aus dem Projekt [kubeless](https://github.com/kubeless/kubeless.git) clonen.

	git clone https://github.com/kubeless/kubeless


#### JavaScript

**Deployen**

	cd kubeless/examples/nodejs
	
	kubeless function deploy helloget --runtime nodejs8 \
	                                --handler test.helloget \
	                                --from-file helloget.js
	                                
**Testen**

* Ausgabe ob Funktion aktiv ist

	kubeless function ls
	
* Aufruf der Funktion

	kubeless function call helloget --data 'Hello world!'			                            


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


