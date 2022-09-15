###
#   Outputs wie IP-Adresse und DNS Name
#

output "ip_vm" {
  value = azurerm_linux_virtual_machine.lerncloud.public_ip_address
  description = "The IP address of the  server instance."
  
}

output "fqdn_vm" {
  value = azurerm_linux_virtual_machine.lerncloud.computer_name
  description = "The FQDN of the server instance."
  
}

output "description" {
  value = var.description 
  description = "Description VM"
}