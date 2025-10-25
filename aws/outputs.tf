###
#   Outputs wie IP-Adresse und DNS Name
###

# URLs Services

output "console" {
  value = concat(
    [for fqdn in module.master_east : "https://${fqdn.fqdn_vm}:4200 - User: ubuntu, Password: insecure"],
    [for fqdn in module.master_west : "https://${fqdn.fqdn_vm}:4200 - User: ubuntu, Password: insecure"]
  )
  description = "Console (East + West)"
}

output "dashboard" {
  value = concat(
    [for fqdn in module.master_east : "https://${fqdn.fqdn_vm}:30443"],
    [for fqdn in module.master_west : "https://${fqdn.fqdn_vm}:30443"]
  )
  description = "Dashboard (East + West)"
}

output "jupyter" {
  value = concat(
    [for fqdn in module.master_east : "http://${fqdn.fqdn_vm}:32188/tree"],
    [for fqdn in module.master_west : "http://${fqdn.fqdn_vm}:32188/tree"]
  )
  description = "Jupyter Notebooks (East + West)"
}

# IPs

output "vm_ip" {
  value = concat(
    module.master_east[*].ip_vm,
    module.master_west[*].ip_vm
  )
  description = "The IP addresses of all master instances (East + West)."
}

# Optional: Wenn du die Regionen getrennt ausgeben möchtest

output "vm_ip_east" {
  value       = module.master_east[*].ip_vm
  description = "IP addresses of masters in us-east-1"
}

output "vm_ip_west" {
  value       = module.master_west[*].ip_vm
  description = "IP addresses of masters in us-west-2"
}
