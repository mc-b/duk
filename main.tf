###
#   Kubernetes Umgebung
#

module "dukmaster" {
  source     = "git::https://github.com/mc-b/terraform_lerncloud_multipass.git"
  cpu        = 4
  mem        = "8GB"
  #source     = "git::https://github.com/mc-b/terraform_lerncloud_aws.git"
  #source     = "git::https://github.com/mc-b/terraform_lerncloud_azure.git"
  #source     = "git::https://github.com/mc-b/terraform_lerncloud_maas.git"
  module     = "dukmaster"
  userdata   = "dukmaster.yaml"
}

module "dukworker-01" {
  source     = "git::https://github.com/mc-b/terraform_lerncloud_multipass.git"
  cpu        = 4
  mem        = "8GB"
  #source     = "git::https://github.com/mc-b/terraform_lerncloud_aws.git"
  #source     = "git::https://github.com/mc-b/terraform_lerncloud_azure.git"
  #source     = "git::https://github.com/mc-b/terraform_lerncloud_maas.git"
  module     = "dukworker-01"
  userdata   = "dukworker.yaml"
}
