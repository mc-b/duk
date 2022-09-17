# Alternative AWS Umgebung

Kubernetes Umgebung in AWS wenn lokale Multipass Umgebung nicht funktioniert. Statt drei VMs, pro Teilnehmer, wird nur ein Master eingerichtet.

Für Anzahl VM Instanzen, folgender Eintrag in `main.tf` anpassen

    count       = 12
    
In AWS Academy sind nur VMs bis X.large (2 CPU, 8 GB RAM) verfügbar. Alle anderen Accounts sollten 16 GB RAM verwenden.

    memory  = 16
    
### Quick Start

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
    
    

