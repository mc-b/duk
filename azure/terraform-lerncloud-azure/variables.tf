
# Allgemeine Variablen

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "West Europe"
}


# Allgemeine Variablen

variable "module" {
    description = "Modulname: wird als Hostname verwendet"
    type    = string
    default = "base"
}

variable "description" {
  description = "Beschreibung VM"
  type        = string
  default     = "Beschreibung VM"  
}

variable "memory" {
    description = "Memory in GB: bestimmt Instance in der Cloud"
    type    = number
    default = 2
}

variable "storage" {
    description = "Groesse Disk"
    type    = number
    default = 32
}

variable "cores" {
    description = "Anzahl CPUs"
    type    = number
    default = 1
}

variable "ports" {
    description = "Ports welche in der Firewall geoeffnet sind"
    type    = list(number)
    default = [ 22, 80 ]
}

variable "userdata" {
    description = "Cloud-init Script"
    type    = string
    default = "cloud-init.yaml"
}

# Zugriffs Informationen

variable "url" {
    description = "Evtl. URL fuer den Zugriff auf das API des Racks Servers"
    type    = string
    default     = "not used"      
}

variable "key" {
    description = "API Key, Token etc. fuer Zugriff"
    type    = string
    sensitive   = true
    default     = "not used"      
}

variable "vpn" {
    description = "Optional VPN welches eingerichtet werden soll"
    type    = string
    default     = "not used"      
}

###
# Aufbereitung fuer Azure Cloud

# Ports um "priority" Ergaenzen
locals {
  expanded_ports = [
    for portmap, count in var.ports : {
        priority = portmap + 100
        port     = tostring(count)
      }
  ]
}

# Ports um "priority" Ergaenzen
locals {
  expanded_ports_udp = [
    for portmap, count in var.ports : {
        priority = portmap + 200
        port     = tostring(count)
      }
  ]
}

# Umwandlung "memory" nach Azure Instance Type

variable "instance_type" {
  type = map
  default = {
    1 = "Standard_B1s"
    2 = "Standard_B1ms"
    4 = "Standard_B2s"
    8 = "Standard_B2ms"
    16 = "Standard_B4ms"
  }
}

# Scripts

data "template_file" "userdata" {
  template = file(var.userdata)
}

