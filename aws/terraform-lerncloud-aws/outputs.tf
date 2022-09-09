###
#   Outputs wie IP-Adresse und DNS Name
#

output "ip_vm" {
  value = aws_instance.vm.public_ip
  description = "The IP address of the AWS server instance."
  
}

output "fqdn_vm" {
  value = aws_instance.vm.public_dns
  description = "The FQDN of the AWS server instance."
  
}

output "description" {
  value = var.description 
  description = "Description VM"
}