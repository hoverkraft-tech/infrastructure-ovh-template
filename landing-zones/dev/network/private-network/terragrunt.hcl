locals {
  global = yamldecode(file(find_in_parent_folders("global.yaml")))
  env    = yamldecode(file(find_in_parent_folders("env.yaml")))
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "github.com/hoverkraft-tech/terraform-modules.git//ovh/pci-private-network?ref=2.1.4"
}

inputs = {
  name       = "vrack"
  project_id = get_env("OS_TENANT_ID")
  vrack_id   = local.env.ovh.network.vrack_id
  vlan_id    = local.env.ovh.network.vlan_id
  regions    = [local.env.ovh.public_cloud.region]
}
