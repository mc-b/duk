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
			
**Anmerkungen**: helm versucht automatisch ein Cloud Volume (StorageClass) zu mounten. Da wir uns aber nicht in der Cloud befinden, schlägt dies fehl. 
Lösung: In `values.yaml` Eintrag `persistence.enabled` auf `false` ändern:

**Vorgehen**

Sourcen von `stable/mysql` als Tarfile holen und entpacken	

	helm fetch stable/mysql
	tar xvzf mysql-0.10.1.tgz

	## Persist data to a persistent volume
	persistence:
	  enabled: false	
	
Änderungen an `values.yaml` vornehmen und mysql mit geänderten Values starten. 	
	
	helm install --name mysql-test -f duk/mysql/helm/mysql/values.yaml stable/mysql	


	

