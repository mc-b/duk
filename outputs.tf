###
#   Outputs wie IP-Adresse und DNS Name
#  

output "ip_vm" {
  value       = module.master.ip_vm
  description = "The IP address of the server instance."
}

output "fqdn_vm" {
  value       = module.master.fqdn_vm
  description = "The FQDN of the server instance."
}

output "description" {
  value       = module.master.description
  description = "Description VM"
}

# Einfuehrungsseite(n)

output "README" {
  value = templatefile("INTRO.md", { ip = module.master.ip_vm, fqdn = module.master.fqdn_vm, ip_01 = module.worker-01.ip_vm, fqdn_01 = module.worker-01.fqdn_vm /*, ip_02 = module.worker-02.ip_vm, fqdn_02 = module.worker-02.fqdn_vm */ })
}

