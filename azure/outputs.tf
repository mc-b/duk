###
#   Outputs wie IP-Adresse und DNS Name
#  

# URLs Services

output "console" {
  value       = [
    for fqdn in module.master : "https://${fqdn.fqdn_vm}:4200 - User: ubuntu, Password: insecure"
    ]
  description = "Console"
}

output "dashboard" {
  value       = [
    for fqdn in module.master : "https://${fqdn.fqdn_vm}:8443"
    ]
  description = "Dashboard"
}

output "jupyter" {
  value       = [
    for fqdn in module.master : "http://${fqdn.fqdn_vm}:32188"
    ]
  description = "Jupyter Notebooks"
}

# IPs

output "vm_ip" {
  value       = module.master[*].ip_vm
  description = "The IP address of the server instance."
}
