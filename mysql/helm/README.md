MySQL Helm Beispiel
--------------------

MySQL Chart Beispiel abgeleitet von stable/mysql.

Helm Repository durchsuchen:

	helm search mysql

Chart und Values inspizieren:
	
	helm inspect chart stable/mysql
	helm inspect values stable/mysql
	
Normale Installation mit Default Values	
	
	helm install --name mysql-test stable/mysql
	
Installation von `mysql` wieder löschen

	helm delete --purge mysql-test
			
### Voreinstellungen ändern

Um die Voreinstellungen zu ändern ist wie folgt vorzugehen:

Sourcen von `stable/mysql` als Tarfile holen und entpacken	

	helm fetch --untar --untardir . stable/mysql

Datei `mysql/values.yaml` editieren und z.B. wie folgt ändern:

	## Persist data to a persistent volume
	persistence:
	  enabled: false	
	
MySQL mit geänderten Values starten. 	
	
	helm install --name mysql-test -f duk/mysql/helm/mysql/values.yaml stable/mysql	

### Templates lokal rendern

Steht Tiller auf dem Server nicht zur Verfügung oder sollen die erstellten YAML Dateien zu Testzwecken nur erzeugt werden, kann mit 
folgendem Befehl lokal die Template Dateien nach YAML gerendert werden:

    helm fetch --untar --untardir . stable/mysql
    helm template --output-dir yaml mysql
    
Die YAML Dateien werden im Verzeichnis `yaml` abgelegt.

### Weitere Informationen und Installation `helm`

* [Helm](../../helm/README.md)    

