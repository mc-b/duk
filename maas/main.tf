###
#   Kubernetes Umgebung
#

module "duk" {
  source = "git::https://github.com/mc-b/terraform-lerncloud-maas.git?ref=v2.0.0"

  machines = {
    controlplane-01 = {
      hostname    = "dukmaster-${var.host_no}-${terraform.workspace}"
      description = "Kubernetes Master"
      userdata    = "cloud-init-dukmaster.yaml"
      memory      = 12
      cores       = 4
      storage     = 32
    },
    "worker-01" = {
      hostname = "dukworker-${var.host_no + 1}-${terraform.workspace}"
      userdata = "cloud-init-dukworker.yaml"
    },
    "worker-02" = {
      hostname = "dukworker-${var.host_no + 2}-${terraform.workspace}"
      userdata = "cloud-init-dukworker.yaml"
    }
  }

  description = "Kubernetes Worker"
  cores       = 4
  memory      = 4
  storage     = 24

  # ssh, http, microk8s, shellinabox
  ports = [22, 80, 16443, 25000, 2049, 4200]

  url = var.url
  key = var.key
  vpn = var.vpn
}
