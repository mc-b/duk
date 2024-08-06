# Zugriffs Informationen
#
# Als Umgebungsvariablen TF_VAR_<name> ablegen
# TF_VAR_url=https://10.6.37.8:5240/MAAS

variable "url" {
  description = "Evtl. URL fuer den Zugriff auf das API des Racks Servers"
  type        = string
  default     = "unknown"
}

# Umgebungsvariable TF_VAR_key ablegen
variable "key" {
  description = "API Key, Token etc. fuer Zugriff"
  type        = string
  sensitive   = true
  default     = "unknown"
}

variable "vpn" {
  description = "Optional VPN welches eingerichtet werden soll"
  type        = string
  default     = "unknown"
}

variable "host_no" {
  description = "Host-No fuer die erste Host-IP Nummer"
  type        = number
  default     = 10
}

# Optionen damit Worker erstellt werden

variable "create_worker_01" {
  description = "Flag to create worker-01 module"
  type        = bool
  default     = true
}

variable "create_worker_02" {
  description = "Flag to create worker-02 module"
  type        = bool
  default     = true
}
