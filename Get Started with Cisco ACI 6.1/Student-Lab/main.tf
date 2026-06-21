# Add the terraform provider
terraform {
  required_providers {
    aci = {
      source = "CiscoDevNet/aci"
      version = ">=2.17.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">=0.9.0"
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

# Step 1: Deploy node policies first (fabric membership)
module "aci_nodes" {
  source  = "netascode/nac-aci/aci"
  version = ">=1.1.0"

  yaml_directories = ["data"]

  # Only manage node policies in this step
  manage_access_policies    = false
  manage_fabric_policies    = false
  manage_pod_policies       = false
  manage_node_policies      = true
  manage_interface_policies = false
  manage_tenants            = false
}

# Step 2: Wait 4 minutes for node discovery to complete
resource "time_sleep" "wait_for_node_discovery" {
  depends_on = [module.aci_nodes]

  create_duration = "4m"
}

# Step 3: Deploy all remaining policies after nodes are discovered
module "aci" {
  depends_on = [time_sleep.wait_for_node_discovery]

  source  = "netascode/nac-aci/aci"
  version = ">=1.1.0"

  yaml_directories = ["data"]

  # Manage everything except node policies (already done)
  manage_access_policies    = true
  manage_fabric_policies    = true
  manage_pod_policies       = true
  manage_node_policies      = false
  manage_interface_policies = true
  manage_tenants            = true
}
