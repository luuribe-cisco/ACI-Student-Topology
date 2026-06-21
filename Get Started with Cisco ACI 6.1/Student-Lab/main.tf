# Add the terraform provider
terraform {
  required_providers {
    aci = {
      source = "CiscoDevNet/aci"
      version = ">=2.17.0"
    }
  }
}

# Login information for the APIC - Hardcoded for dCloud lab
provider "aci" {
  username = "admin"
  password = "C1sco12345"
  url      = "https://198.18.133.200"
  insecure = true
}

module "aci" {
  # A link to the GitHub is here "github.com/netascode/terraform-aci-nac-aci"
  source  = "netascode/nac-aci/aci"
  version = ">=1.1.0"

  # This line points the module to the data/ directory, which is where we store our configuration
  yaml_directories = ["data"]

  # Each item here controls what the module expects to configure from the .yaml files in the data/ directory
  # All policies are managed to create the complete lab environment in one terraform apply
  manage_access_policies    = true
  manage_fabric_policies    = true
  manage_pod_policies       = true
  manage_node_policies      = true
  manage_interface_policies = true
  manage_tenants            = true
}
