###
#   Kubernetes Umgebung
#

module "master" {

  #source     = "./terraform-lerncloud-module"
  source     = "git::https://github.com/mc-b/terraform-lerncloud-multipass"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-maas"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-lernmaas"  
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-aws"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-azure"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-proxmox"      

  module      = "dukmaster-${var.host_no}-${terraform.workspace}"
  description = "Kubernetes Master"
  userdata    = "cloud-init-dukmaster.yaml"
  depends_on  = [ module.worker-01, module.worker-02 ]  

  cores   = 4
  memory  = 8
  storage = 32
  # SSH, Kubernetes, NFS, Shell in a Box
  ports      = [ 22, 80, 16443, 25000, 2049, 4200 ]

  # MAAS Server Access Info
  url = var.url
  key = var.key
  vpn = var.vpn

}

module "worker-01" {

  #source     = "./terraform-lerncloud-module"
  source     = "git::https://github.com/mc-b/terraform-lerncloud-multipass"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-maas"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-lernmaas"  
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-aws"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-azure"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-proxmox"      

  module      = "dukworker-${var.host_no + 1}-${terraform.workspace}"
  description = "Kubernetes Worker"
  userdata    = "cloud-init-dukworker.yaml"

  cores   = 2
  memory  = 4
  storage = 32
  ports      = [ 22, 80, 16443, 25000, 2049, 4200 ]

  # MAAS Server Access Info
  url = var.url
  key = var.key
  vpn = var.vpn

}

module "worker-02" {

  #source     = "./terraform-lerncloud-module"
  source     = "git::https://github.com/mc-b/terraform-lerncloud-multipass"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-maas"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-lernmaas"  
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-aws"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-azure"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-proxmox"      

  module      = "dukworker-${var.host_no + 2}-${terraform.workspace}"
  description = "Kubernetes Worker"
  userdata    = "cloud-init-dukworker.yaml"
  depends_on  = [ module.worker-01 ]    

  cores   = 2
  memory  = 4
  storage = 32
  ports      = [ 22, 80, 16443, 25000, 2049, 4200 ] 

  # MAAS Server Access Info
  url = var.url
  key = var.key
  vpn = var.vpn
}

