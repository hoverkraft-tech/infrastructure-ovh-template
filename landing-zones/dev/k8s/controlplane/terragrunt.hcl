locals {
  global = yamldecode(file(find_in_parent_folders("global.yaml")))
  env    = yamldecode(file(find_in_parent_folders("env.yaml")))
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "github.com/hoverkraft-tech/terraform-modules.git//ovh/kube-managed?ref=2.1.4"
}

dependency "private-network" {
  config_path                             = "../../network/private-network"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
  mock_outputs = {
    id   = "123456"
    uuid = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
  }
}

dependency "private-subnet" {
  config_path                             = "../../network/private-subnet"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
  mock_outputs = {
  }
}

inputs = {
  name                               = local.env.name
  cloud_project_id                   = get_env("OS_TENANT_ID")
  region                             = local.env.ovh.public_cloud.region
  k8s_version                        = local.env.k8s.version
  private_network_id                 = dependency.private-network.outputs.uuid
  default_vrack_gateway              = ""
  private_network_routing_as_default = false
}
