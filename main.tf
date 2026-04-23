###
#   Kubernetes Umgebung
#

module "master" {
  #source     = "./terraform-lerncloud-module"
  source = "git::https://github.com/mc-b/terraform-lerncloud-multipass"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-maas"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-lernmaas"  
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-aws"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-azure"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-proxmox"      
  module      = "control-01-${terraform.workspace}"
  description = "Kubernetes Control Plane Node"
  userdata    = "cloud-init-control.yaml"
  depends_on = [
    module.worker-01,
    module.worker-02
  ]

  cores   = 4
  memory  = 12
  storage = 32
  ports   = [22, 80, 16443, 25000, 2049, 4200]

  url = var.url
  key = var.key
  vpn = var.vpn
}

module "worker-01" {
  count = var.create_worker_01 ? 1 : 0

  #source     = "./terraform-lerncloud-module"
  source = "git::https://github.com/mc-b/terraform-lerncloud-multipass"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-maas"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-lernmaas"  
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-aws"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-azure"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-proxmox"    
  module      = "worker-01-${terraform.workspace}"
  description = "Kubernetes Worker Node"
  userdata    = "cloud-init-worker.yaml"

  cores   = 2
  memory  = 4
  storage = 32
  ports   = [22, 80, 16443, 25000, 2049, 4200]

  url = var.url
  key = var.key
  vpn = var.vpn
}

module "worker-02" {
  count = var.create_worker_02 ? 1 : 0

  #source     = "./terraform-lerncloud-module"
  source = "git::https://github.com/mc-b/terraform-lerncloud-multipass"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-maas"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-lernmaas"  
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-aws"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-azure"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-proxmox"    
  module      = "worker-02-${terraform.workspace}"
  description = "Kubernetes Worker Node"
  userdata    = "cloud-init-worker.yaml"
  depends_on = [
    module.worker-01
  ]

  cores   = 2
  memory  = 4
  storage = 32
  ports   = [22, 80, 16443, 25000, 2049, 4200]

  url = var.url
  key = var.key
  vpn = var.vpn
}
