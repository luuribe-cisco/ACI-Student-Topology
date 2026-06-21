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

# ==================== SNAPSHOT: BLANK CONFIG ====================
# Create snapshot before any configuration changes
resource "aci_rest_managed" "snapshot_blank" {
  dn         = "uni/fabric/configexp-SnapshotBlankConfig"
  class_name = "configExportP"
  content = {
    name         = "SnapshotBlankConfig"
    adminSt      = "triggered"
    format       = "json"
    snapshot     = "yes"
    targetDn     = ""
    descr        = "Blank configuration snapshot before terraform deployment"
  }
}

# Wait for blank snapshot to complete
resource "time_sleep" "wait_for_blank_snapshot" {
  depends_on      = [aci_rest_managed.snapshot_blank]
  create_duration = "30s"
}

# ==================== STEP 1: NODE POLICIES ====================
# Deploy node policies first (fabric membership)
module "aci_nodes" {
  depends_on = [time_sleep.wait_for_blank_snapshot]

  source  = "netascode/nac-aci/aci"
  version = ">=1.1.0"

  yaml_directories = ["data"]

  # Remove "orchestrator:terraform" annotation
  annotation = ""

  # Only manage node policies in this step
  manage_access_policies    = false
  manage_fabric_policies    = false
  manage_pod_policies       = false
  manage_node_policies      = true
  manage_interface_policies = false
  manage_tenants            = false
}

# ==================== STEP 2: WAIT FOR DISCOVERY ====================
# Wait 4 minutes for node discovery to complete
resource "time_sleep" "wait_for_node_discovery" {
  depends_on = [module.aci_nodes]

  create_duration = "4m"
}

# ==================== STEP 3: REMAINING POLICIES ====================
# Deploy all remaining policies after nodes are discovered
module "aci" {
  depends_on = [time_sleep.wait_for_node_discovery]

  source  = "netascode/nac-aci/aci"
  version = ">=1.1.0"

  yaml_directories = ["data"]

  # Remove "orchestrator:terraform" annotation
  annotation = ""

  # Manage everything except node policies (already done)
  manage_access_policies    = true
  manage_fabric_policies    = true
  manage_pod_policies       = true
  manage_node_policies      = false
  manage_interface_policies = true
  manage_tenants            = true
}

# ==================== SNAPSHOT: INITIAL CONFIG ====================
# Create snapshot after all configuration is deployed
resource "aci_rest_managed" "snapshot_initial" {
  depends_on = [module.aci]

  dn         = "uni/fabric/configexp-SnapshotInitialConfig"
  class_name = "configExportP"
  content = {
    name         = "SnapshotInitialConfig"
    adminSt      = "triggered"
    format       = "json"
    snapshot     = "yes"
    targetDn     = ""
    descr        = "Initial lab configuration after terraform deployment"
  }
}
