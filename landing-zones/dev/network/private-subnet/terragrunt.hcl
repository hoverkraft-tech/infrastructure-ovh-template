locals {
  global = yamldecode(file(find_in_parent_folders("global.yaml")))
  env    = yamldecode(file(find_in_parent_folders("env.yaml")))
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "github.com/hoverkraft-tech/terraform-modules.git//ovh/pci-private-subnet?ref=2.1.4"
}

dependency "private-network" {
  config_path                             = "../private-network"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
  mock_outputs = {
    id   = "pn-1234567"
    uuid = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
  }
}

inputs = {
  name       = "private-net"
  network_id = dependency.private-network.outputs.uuid
  ip = {
    network = local.env.ovh.network.ip.network
    start   = local.env.ovh.network.ip.start
    end     = local.env.ovh.network.ip.end
  }
}
