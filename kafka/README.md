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

### Standard Kafka Umgebung

**Starten**

	kubectl create -f duk/kafka/kafka.yaml
	kubectl create -f duk/kafka/zookeeper.yaml
	
**Topics erstellen**

Terminal starten

	runbash kafka

Im Terminal
	
	kafka-topics --create --zookeeper zookeeper:2181 --replication-factor 1 --partitions 1 --topic streams-plaintext-input	
	kafka-topics --list --zookeeper zookeeper:2181

**Daten schreiben und lesen**

In jeweils einem eigenen Terminal

schreiben

	kafka-console-producer --broker-list kafka:9092 --topic streams-plaintext-input

lesen

	kafka-console-consumer --bootstrap-server kafka:9092 \
	    --topic streams-plaintext-input \
	    --from-beginning \
	    --formatter kafka.tools.DefaultMessageFormatter \
	    --property print.value=true 

### Kafka mit MQTT Bridge

**Starten**

	kubectl create -f duk/iot/mosquitto.yaml
	kubectl create -f duk/kafka/mqtt-kafka-bridge.yaml

**Testen**

Im kafka Terminal

	kafka-console-consumer --bootstrap-server kafka:9092 --topic broker_message --from-beginning

### Write a Kafka Application 

Startet die Maven Umgebung in Container

	kubectl create -f compiler/maven.yaml
	
Wechselt in den Container

	runbash maven
	
Erstellt im Container ein Kafka Stream Maven Projekt

	cd /src
	mvn archetype:generate \
	    -DarchetypeGroupId=org.apache.kafka \
	    -DarchetypeArtifactId=streams-quickstart-java \
	    -DarchetypeVersion=2.0.0 \
	    -DgroupId=streams.examples \
	    -DartifactId=streams.examples \
	    -Dversion=0.1 \
	    -Dpackage=myapps

**Hinweis**: Das `/src` Verzeichnis ist im `.../lernkube/data/src` auf dem Host verfügbar.

Editiert alle Java Dateien im Verzeichnis `stream.examples/src/main/java/myapps` und ändert `localhost:9092` auf `kafka:9092` 
und `streams-plaintext-input` auf `broker_message`, z.B.: 

public class Pipe {

    public static void main(String[] args) throws Exception {
        Properties props = new Properties();
        props.put(StreamsConfig.APPLICATION_ID_CONFIG, "streams-pipe");
        props.put(StreamsConfig.BOOTSTRAP_SERVERS_CONFIG, "kafka:9092");
        props.put(StreamsConfig.DEFAULT_KEY_SERDE_CLASS_CONFIG, Serdes.String().getClass());
        props.put(StreamsConfig.DEFAULT_VALUE_SERDE_CLASS_CONFIG, Serdes.String().getClass());

        final StreamsBuilder builder = new StreamsBuilder();

        builder.stream("streams-plaintext-input").to("broker_message");

Erstellt einen Neuen Kafka **Consumer** (Datei stream.examples/src/main/java/myapps/CSVConsumer.java) mit folgendem Inhalt:

	package myapps;
	
	import org.apache.kafka.common.serialization.Serdes;
	import org.apache.kafka.common.utils.Bytes;
	import org.apache.kafka.streams.KafkaStreams;
	import org.apache.kafka.streams.StreamsBuilder;
	import org.apache.kafka.streams.StreamsConfig;
	import org.apache.kafka.streams.Topology;
	import org.apache.kafka.streams.kstream.KeyValueMapper;
	import org.apache.kafka.streams.kstream.Materialized;
	import org.apache.kafka.streams.kstream.Produced;
	import org.apache.kafka.streams.kstream.ValueMapper;
	import org.apache.kafka.streams.state.KeyValueStore;
	import org.apache.kafka.clients.consumer.*;
	
	import java.util.Arrays;
	import java.util.Locale;
	import java.util.Properties;
	import java.util.concurrent.CountDownLatch;
	
	/**
	 * @see https://kafka.apache.org/20/javadoc/index.html?org/apache/kafka/clients/consumer/KafkaConsumer.html
	 */
	public class CSVConsumer
	{
	
	    public static void main(String[] args) throws Exception
	    {
	        Properties props = new Properties();
	        props.put(StreamsConfig.BOOTSTRAP_SERVERS_CONFIG, "kafka:9092");        
	        props.put( "group.id", "iot" );
	        props.put( "enable.auto.commit", "true" );
	        props.put( "auto.commit.interval.ms", "1000" );
	        props.put( "key.deserializer", "org.apache.kafka.common.serialization.StringDeserializer" );
	        props.put( "value.deserializer", "org.apache.kafka.common.serialization.StringDeserializer" );
	        KafkaConsumer<String, String> consumer = new KafkaConsumer<>( props );
	        consumer.subscribe( Arrays.asList( "streams-plaintext-input", "broker_message" ) );
	        
	        while (true)
	        {
	            ConsumerRecords<String, String> records = consumer.poll( 100 );
	            for ( ConsumerRecord<String, String> record : records )
	                System.out.printf( "offset = %d, value = %s%n", record.offset(), record.value() );
	        }
	    }
	}

Compiliert die alle Dateien und führt die gewünschten Beispiele wie folgt aus:

	cd stream.examples
	mvn clean package
    mvn exec:java -Dexec.mainClass=myapps.CSVConsumer
    
Im Terminal sollten die Ausgaben vom IoTKit V3 erscheinen. Siehe [mbed MQTT Client](https://os.mbed.com/teams/mqtt/code/HelloMQTT/).

**Hinweis**: Java Dateien mit Compilerfehler können einfach gelöscht werden.   

### Links

* [MQTT Bridge](https://hub.docker.com/r/devicexx/mqtt-kafka-bridge/)
* [mbed MQTT Client](https://os.mbed.com/teams/mqtt/code/HelloMQTT/)
* [Kafka Consumer API](https://kafka.apache.org/20/javadoc/index.html?org/apache/kafka/clients/consumer/KafkaConsumer.html)
* [Kafka Streams](https://kafka.apache.org/documentation/streams/)
