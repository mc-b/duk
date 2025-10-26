# Alternative Azure Umgebung

Kubernetes Umgebung in Azure wenn die lokale Multipass Umgebung nicht funktioniert. Statt drei VMs, pro Teilnehmer, wird nur ein Master eingerichtet.

Für Anzahl VM Instanzen, folgender Eintrag in `main.tf` anpassen

    count       = 12
    
In Azure Student sind nur VMs bis 2 CPU, 8 GB RAM verfügbar. Alle anderen Accounts sollten 16 GB RAM verwenden.

    memory  = 16    
    
**Hinweis**: beim Löschen der Umgebung kann ein Fehler auftretten. Das hat mit einem internen Fehler im Azure-API zu tun. 
* Lösung: mehrmals `terraform destroy --auto-approve` ausführen.    

## Quick Start

Installiert [Git/Bash](https://git-scm.com/downloads), [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/) und [Terraform](https://www.terraform.io/).

Git/Bash Kommandozeile (CLI) starten und dieses Repository clonen.

    git clone https://github.com/mc-b/duk
    cd duk/azure
    
Azure Zugang einrichten und Subscription ID setzen in Variable `TF_VAR_key`.
    
    az login   
    export TF_VAR_key=<Subscription ID> 
    
**ACHTUNG**: bei mehr als 5 gleichzeitigen VMs sind die [Quotas](https://learn.microsoft.com/de-de/azure/azure-resource-manager/troubleshooting/error-resource-quota?tabs=azure-cli) für die Region `East US 2` anzupassen. Evtl. funktioniert es dann, bei mir gab der Terraform Azure Provider ein Fehler.
    
Terraform Initialisieren und VMs erstellen

    terraform init
    terraform apply  
  
### Zugriff auf Console

    https://<fqdn>:4200
    
User: ubuntu
Password: insecure    
   

### Dashboard

Das Kubernetes Dashboard ist wie folgt erreichbar.

    https://<fqdn>:30443

### Übungen

Die Umgebung beinhaltet eine Vielzahl von Übungen als Juypter Notebooks. Die Jupyter Notebook Oberfläche ist wie folgt erreichbar:

    http://<fqdn>:32188       