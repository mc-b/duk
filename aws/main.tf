###
#   Kubernetes Umgebung
#

module "master" {

  source     = "./terraform-lerncloud-aws"
  
  count       = 6
  module      = "dukmaster-${format("%02d", count.index + 1)}-${terraform.workspace}"
  description = "Kubernetes Master"
  userdata    = "../cloud-init-dukmaster.yaml"

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


