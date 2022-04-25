###
#   Kubernetes Umgebung
#

module "master" {

  #source      = "./terraform-lerncloud-module"
  source = "git::https://github.com/mc-b/terraform-lerncloud-multipass"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-maas"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-lernmaas"    

  module      = "dukmaster-${var.host_no}-${terraform.workspace}"
  description = "Kubernetes Master"
  userdata    = "dukmaster.yaml"

  cores   = 4
  memory  = 8
  storage = 32
  ports   = [22, 2376, 6443]

  # MAAS Server Access Info
  url = var.url
  key = var.key
  vpn = var.vpn

}

module "worker-01" {

  #source      = "./terraform-lerncloud-module"
  source = "git::https://github.com/mc-b/terraform-lerncloud-multipass"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-maas"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-lernmaas"    

  module      = "dukworker-${var.host_no + 1}-${terraform.workspace}"
  description = "Kubernetes Worker"
  userdata    = "dukworker.yaml"

  cores   = 4
  memory  = 8
  storage = 32

  # MAAS Server Access Info
  url = var.url
  key = var.key
  vpn = var.vpn

}

/*
module "worker-02" {

  #source      = "./terraform-lerncloud-module"
  source = "git::https://github.com/mc-b/terraform-lerncloud-multipass"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-maas"
  #source     = "git::https://github.com/mc-b/terraform-lerncloud-lernmaas"    

  module      = "dukworker-${var.host_no + 2}-${terraform.workspace}"
  description = "Kubernetes Worker"
  userdata    = "dukworker.yaml"

  cores   = 4
  memory  = 8
  storage = 32

  # MAAS Server Access Info
  url = var.url
  key = var.key
  vpn = var.vpn
}
*/
