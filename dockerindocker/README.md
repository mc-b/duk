Docker in Docker
----------------

Docker kann in einem Docker Container ausgeführt werden. Das hat den Vorteil, dass weitere Container gestartet werden können, z.B. um Programme zu compilieren, durchführen von Unit-Tests etc.

Die folgenden Container machen sich diesem Umstand zu Nutze.

### Maven

Maven ist ein Build-Management-Tool der Apache Software Foundation und basiert auf Java. 

Starten und Wechsel in Container:

	kubectl create -f duk/dockerindocker/maven-cli.yaml
	kubectl exec -it maven-cli -- bash
	
Im Container kann das gewünsche Repository geclont werden und die Software gebuildet werden, z.B.:
	
	git clone https://github.com/mc-b/simple-java-maven-app.git
	cd simple-java-maven-app
	mvn clean package
	java -jar target/my-app-1.0-SNAPSHOT.jar


