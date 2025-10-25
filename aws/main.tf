###
#   Kubernetes Umgebung
#

# --- 9 Master in us-east-1 ---
module "master_east" {
  source = "./terraform-lerncloud-aws"
  count  = 9

  module      = "dukmaster-east-${format("%02d", count.index + 1)}-${terraform.workspace}"
  description = "Kubernetes Master East"
  userdata    = "../cloud-init-dukmaster.yaml"

  cores   = 4
  memory  = 8
  storage = 32

  ports = [22, 80, 16443, 25000, 2049, 4200]

  url = var.url
  key = var.key
  vpn = var.vpn
}

# --- 9 Master in us-west-2 ---
module "master_west" {
  source = "./terraform-lerncloud-aws"
  count  = 9

  providers = {
    aws = aws.west # nutzt Alias-Provider (us-west-2)
  }

  module      = "dukmaster-west-${format("%02d", count.index + 1)}-${terraform.workspace}"
  description = "Kubernetes Master West"
  userdata    = "../cloud-init-dukmaster.yaml"

  cores   = 4
  memory  = 8
  storage = 32

  ports = [22, 80, 16443, 25000, 2049, 4200]

  url = var.url
  key = var.key
  vpn = var.vpn
}



