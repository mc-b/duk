###
#   Outputs wie IP-Adresse und DNS Name
#  

output "intro" {
  value = try(
    templatefile("INTRO.md", {
      ip             = element(tolist(module.duk.ip_vm["controlplane-01"]), 0),
      fqdn           = module.duk.fqdn_vm["controlplane-01"],
      worker_01_ip   = element(tolist(module.duk.ip_vm["worker-01"]), 0),
      worker_01_fqdn = module.duk.fqdn_vm["worker-01"],
      worker_02_ip   = element(tolist(module.duk.ip_vm["worker-02"]), 0),
      worker_02_fqdn = module.duk.fqdn_vm["worker-02"],
    }),
    templatefile("INTRO.md", {
      ip             = element(tolist(module.duk.ip_vm["controlplane-01-1"]), 0),
      fqdn           = module.duk.fqdn_vm["controlplane-01-1"],
      worker_01_ip   = element(tolist(module.duk.ip_vm["worker-01-1"]), 0),
      worker_01_fqdn = module.duk.fqdn_vm["worker-01-1"],
      worker_02_ip   = element(tolist(module.duk.ip_vm["worker-02-1"]), 0),
      worker_02_fqdn = module.duk.fqdn_vm["worker-02-1"],
    })
  )
}

