OSS Ticket
==========

### Übersicht 

    +---------------------------------------------------------------+
    ! Container: OSS Ticket                                         !	
    ! Container: MySQL                                              !	
    +---------------------------------------------------------------+
    ! Container-Engine: Docker / Kubernetes                         !	
    +---------------------------------------------------------------+
    ! Host-OS: Windows, MacOS, Linux                                !	
    +---------------------------------------------------------------+
    ! Notebook - Schulnetz 10.x.x.x                                 !                 
    +---------------------------------------------------------------+

### Beschreibung

[osTicket](http://osticket.com/) ist ein Open-Source-Support-Ticket-System. 

Es leitet Anfragen, die per E-Mail, Webformularen und Telefonanrufen erstellt wurden, nahtlos in eine einfache, benutzerfreundliche webbasierte Kunden-Support-Plattform für mehrere Benutzer um.

**Starten:**

	kubectl create -f duk/osticket/mysql.yaml
	kubectl create -f duk/osticket/osticket.yaml

**User Interface:**

	startsvc osticket
	
Geöffneter URL mit /scp/ ergänzen, z.B. [http://192.168.137.100:31229/scp/](http://192.168.137.100:31229/scp/)	
	
* username: ostadmin
* password: Admin1
	
### Docker Repositories

* [OSS Ticket](https://hub.docker.com/r/campbellsoftwaresolutions/osticket/)
* [Offizielles MySQL Image](https://hub.docker.com/_/mysql/) 