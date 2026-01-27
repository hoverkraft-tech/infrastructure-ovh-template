locals {
  global     = yamldecode(file(find_in_parent_folders("global.yaml")))
  env        = yamldecode(file(find_in_parent_folders("env.yaml")))
  kubeconfig = "${get_repo_root()}/.secrets/${local.env.name}.kubeconfig"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "github.com/hoverkraft-tech/terraform-modules.git//k8s/kubeconfig?ref=2.1.4"
}

dependency "k8s_cluster" {
  config_path                             = "../controlplane"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
  mock_outputs = {
    kubeconfig = "# mock kubeconfig"
  }
}

inputs = {
  filename = local.kubeconfig
  content  = dependency.k8s_cluster.outputs.kubeconfig
}
