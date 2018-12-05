Compiler 
--------

### Übersicht 

    +---------------------------------------------------------------+
    !                                                               !	
    !    +-------------------------+                                !
    !    ! Compiler Umgebung       !                                !
    !    ! mountPath: /src         !                                !       
    !    ! hostPath:  /c/Users/tmp !                                !       
    !    +-------------------------+                                !
    !                                                               !	
    ! Container: Volume: /src                                       !	
    +---------------------------------------------------------------+
    ! Container-Engine: Docker                                      !	
    +---------------------------------------------------------------+
    ! Gast OS: Ubuntu 16.04                                         !	
    +---------------------------------------------------------------+
    ! Hypervisor: VirtualBox mountet: C:/Users an /c/Users          !	
    +---------------------------------------------------------------+
    ! Host-OS: Windows, MacOS, Linux                                !	
    +---------------------------------------------------------------+
    ! Notebook - Schulnetz 10.x.x.x                                 !                 
    +---------------------------------------------------------------+

### Beschreibung
    
Häufig werden für Spezialaufgaben, z.B. Crosscompiling auf ARM Plattform, ein bestimmer Compiler benötigt.

Dabei lohnt es sich aber nicht den Compiler mit allen Abhängigkeiten lokal auf dem eigenen System zu installieren.

### Beispiele

#### Maven und BPMN-Backend

Für [BPMN-Backend](https://github.com/bernet-tbz/bpmn-tutorial/tree/master/bpmn-backend) braucht es [Maven](https://maven.apache.org/) und die Java Entwicklungsumgebung.

Statt Maven und Java auf dem eigenen System zu installieren, kann der [maven Container](https://hub.docker.com/_/maven/) und die Datei `maven.yaml` verwendet werden.

Container erzeugen und in diesen wechseln:

	kubectl create -f duk/compiler/maven.yaml
	runbash maven
	
Anschliessend können die Befehle laut [BPMN-Backend](https://github.com/bernet-tbz/bpmn-tutorial/tree/master/bpmn-backend) ausgeführt werden.

Dabei wird im Verzeichnis `C:\Users\tmp` (Linux: `/home/tmp`) ein Verzeichnis mit den Maven Projekt erzeugt.

Um den Port 8080 ausserhalb des Containers sichtbar zu machen, muss in der Datei `ch.tbz.bpmn.backend.Main.java` die Konstante `BASE_URI` angepasst werden.

    // Base URI the Grizzly HTTP server will listen on
    public static final String BASE_URI = "http://0.0.0.0:8080/myapp/";

#### ARM mbed (IoTKit)

Um die Beispiele aus dem [IoTKit V3](https://github.com/mc-b/iotkitv3) zu compilieren, kann der [Online Compiler](https://os.mbed.com/compiler/) oder eine Offline Umgebung, z.B. das `mbed-cli` verwendet werden.

Das `mbed-cli` geht nicht sehr Ressourcenschonend mit dem Speicherplatz um und clont zu jedem Programm die mbed-os Library. Zusätzlich braucht die ARM [mbed](https://www.mbed.com/en/) Umgebung einen C++ Crosscompiler, Python und das `mbed-cli`.

Dieser Container stellt eine bereits compilierte mbed-os Library und ein paar Shellscript für das einfache und schnelle Compilieren der IoTKit Beispiele zur Verfügung.

Container erzeugen und in diesen wechseln:

	kubectl create -f duk/compiler/mbed-cli.yaml
	kubectl -it exec mbed-cli -- bash
	
IoTKit Beispiele clonen und erstes Beispiel compilieren.

	cd /src
	git clone https://github.com/mc-b/iotkitv3
	cd iotkitv3/gpio/DigitalOut
	compile
		
Das compilierte Beispiel steht im Verzeichnis `iotkitv3/gpio/DigitalOut/BUILD` bzw. von PC als `lernkube/data/src/iotkitv3/gpio/DigitalOut/BUILD` als `DigitalOut.bin` zur Verfügung und kann mittels Drag & Drop auf das IoTKit Board kopiert werden, Reset Button drücken und eine LED blinkt.

### DotNet

Es existiert ein [Docker Beispiel](https://github.com/mc-b/devops/tree/master/docker/dotnet) (ohne Kubernetes), welches aber auch in der Kubernetes Umgebung lauffähig ist.

Bilden des Containers und Aufruf bzw. Wechsel in Container

	cd devops/docker/dotnet
	docker build -t dotnetapp .
	kubectl run -it --rm --image dotnetapp dotnet --image-pull-policy=IfNotPresent
	
*Im Container*

	dotnet out/dotnetapp.dll

