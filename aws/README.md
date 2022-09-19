# Alternative AWS Umgebung

Kubernetes Umgebung in AWS wenn lokale Multipass Umgebung nicht funktioniert. Statt drei VMs, pro Teilnehmer, wird nur ein Master eingerichtet.

Für Anzahl VM Instanzen, folgender Eintrag in `main.tf` anpassen

    count       = 12
    
In AWS Academy sind nur VMs bis X.large (2 CPU, 8 GB RAM) verfügbar. Alle anderen Accounts sollten 16 GB RAM verwenden.

    memory  = 16
    
## Quick Start

Installiert [Git/Bash](https://git-scm.com/downloads), [AWS CLI](https://aws.amazon.com/de/cli/) und [Terraform](https://www.terraform.io/).

Git/Bash Kommandozeile (CLI) starten und dieses Repository clonen.

    git clone https://github.com/mc-b/duk
    cd duk/aws
    
AWS Zugang einrichten
    
    aws configure
        AWS Access Key ID [****************....]:
        AWS Secret Access Key [****************....]:
        Default region name [us-west-2]: us-east-1
        Default output format [None]:        
    
Terraform Initialisieren und VMs erstellen

    terraform init
    terraform apply   
  
### Zugriff auf Console

    https://<fqdn>:4200
    
User: ubuntu
Password: insecure    
   

### Dashboard

Das Kubernetes Dashboard ist wie folgt erreichbar.

    https://<fqdn>:8443

### Übungen

Die Umgebung beinhaltet eine Vielzahl von Übungen als Juypter Notebooks. Die Jupyter Notebook Oberfläche ist wie folgt erreichbar:

    http://<fqdn>:32188     
    
## Mehrere Kurse einrichten

    terraform workspace new DUK-2022ZH
    terraform init
    terraform apply -auto-approve
    
    terraform workspace new DUK-2022BA
    etc.
    
Zurück wechseln auf erste Workspace

    terraform workspace select DUK-2022ZH 

Aktuelle Workspace anzeigen

    terraform workspace show  
    
Workspace löschen

    terraform workspace switch DUK-2022ZH
    terraform destroy 
    terraform workspace select default
    terraform workspace delete DUK-2022ZH      
  
## Einzelne VM löschen und neu aufsetzen

Löschen der 2. VM und neu Erstellen

    terraform destroy --target=module.master[1]
    
    terraform apply   --target=module.master[1]

