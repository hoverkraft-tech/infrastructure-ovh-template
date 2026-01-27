locals {
  global     = yamldecode(file(find_in_parent_folders("global.yaml")))
  env        = yamldecode(file(find_in_parent_folders("env.yaml")))
  kubeconfig = "${get_repo_root()}/.secrets/${local.env.name}.kubeconfig"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "github.com/hoverkraft-tech/terraform-modules.git//ovh/kube-nodepool?ref=2.1.4"
}

dependency "k8s_cluster" {
  config_path                             = "../controlplane"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
  mock_outputs = {
    id = "test"
  }
}

inputs = {
  name             = local.env.k8s.nodepools[0].name
  cloud_project_id = get_env("OS_TENANT_ID")
  kube_id          = dependency.k8s_cluster.outputs.id
  flavor_name      = local.env.k8s.nodepools[0].flavor
  min_nodes        = local.env.k8s.nodepools[0].min_nodes
  max_nodes        = local.env.k8s.nodepools[0].max_nodes
  desired_nodes    = local.env.k8s.nodepools[0].desired_nodes
  autoscale        = local.env.k8s.nodepools[0].autoscale
  monthly_billed   = local.env.k8s.nodepools[0].monthly_billed
  anti_affinity    = local.env.k8s.nodepools[0].anti_affinity
}
