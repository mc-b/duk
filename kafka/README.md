Apache Kafka®
-------------

Apache Kafka® ist eine verteilte Streaming-Plattform.

Eine Streaming-Plattform hat drei Schlüsselfunktionen:

* Veröffentlichen und abonnieren Sie Streams von Datensätzen, ähnlich einer Nachrichtenwarteschlange oder eines Enterprise-Messaging-Systems.
* Speichern Sie Streams von Datensätzen auf eine fehlertolerante, dauerhafte Weise.
* Verarbeiten von Datenströmen, wenn sie auftreten.

Kafka wird im Allgemeinen für zwei große Klassen von Anwendungen verwendet:

* Erstellen von Echtzeit-Streaming-Datenpipelines, die zuverlässig Daten zwischen Systemen oder Anwendungen erhalten
* Erstellen von Echtzeit-Streaming-Anwendungen, die die Datenströme transformieren oder darauf reagieren

**Starten**

	kubectl create -f duk/kafka
	
**Topics erstellen**

	runbash kafka
	# 
	
	kafka-topics --create --zookeeper zookeeper:32181 --replication-factor 1 --partitions 1 --topic streams-plaintext-input	
	kafka-topics --create --zookeeper zookeeper:32181 --replication-factor 1 --partitions 1 --topic streams-wordcount-output --config cleanup.policy=compact	
	kafka-topics --list --zookeeper zookeeper:32181

**Daten schreiben und lesen**

In jeweils einem eigenen Terminal

schreiben

	kafka-console-producer --broker-list kafka:30092 --topic streams-plaintext-input

lesen

	kafka-console-consumer --bootstrap-server kafka:30092 \
	    --topic streams-plaintext-input \
	    --from-beginning \
	    --formatter kafka.tools.DefaultMessageFormatter \
	    --property print.value=true 




### Links

* [MQTT Bridge](https://hub.docker.com/r/devicexx/mqtt-kafka-bridge/)