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

locals {
  ip_01   = var.create_worker_01 ? module.worker-01[0].ip_vm : ""
  fqdn_01 = var.create_worker_01 ? module.worker-01[0].fqdn_vm : ""
  ip_02   = var.create_worker_02 ? module.worker-02[0].ip_vm : ""
  fqdn_02 = var.create_worker_02 ? module.worker-02[0].fqdn_vm : ""
}

output "README" {
  value = templatefile("INTRO.md", {
    ip      = module.master.ip_vm,
    fqdn    = module.master.fqdn_vm,
    ip_01   = local.ip_01,
    fqdn_01 = local.fqdn_01,
    ip_02   = local.ip_02,
    fqdn_02 = local.fqdn_02
  })
}

