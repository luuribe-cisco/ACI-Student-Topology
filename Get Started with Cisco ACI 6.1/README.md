[![Terraform Version](https://img.shields.io/badge/terraform-%5E1.3-blue)](https://www.terraform.io)

# ACI Study Lab - Network-as-Code Configuration

## Overview
This folder contains Terraform configurations using Network-as-Code to deploy an ACI study environment with intentional misconfigurations for troubleshooting practice.

Read more about Network-as-Code (NaC) here: https://netascode.cisco.com/

## Getting Started
1. Schedule the "Getting Started with Cisco ACI 6.1" demo in Cisco dCloud
2. Navigate to the `Student-Lab` folder
3. Run:
   ```bash
   terraform init
   terraform apply -auto-approve
   ```
4. Use the ACI GUI to troubleshoot and fix the intentional misconfigurations

## Credentials
Credentials are pre-configured in the terraform files:
- **APIC**: https://198.18.133.200 (admin / C1sco12345)
- **vCenter**: administrator@vsphere.local / C1sco12345

## File Structure
```
└── Student-Lab/
    ├── main.tf                        # Terraform provider and module config
    └── data/
        ├── 1_node_policies.nac.yaml   # Leaves and Spines
        ├── 2_fabric_policies.nac.yaml # BGP, DNS, VMM Domain
        ├── 3_access_policies.nac.yaml # Pools, Domains, Policies, IPGs
        └── 4_tenant_policies.nac.yaml # Tenant, VRFs, BDs, EPGs, L3Out
```

## What Gets Deployed
- **Node Policies**: Leaves 201/202, Spines 203/204 with management addresses
- **Fabric Policies**: BGP (wrong ASN), DNS, NTP, VMM domain (read-only mode)
- **Access Policies**: VLAN pools, domains, AAEPs, policies with misconfigurations
- **Tenant Policies**: Xandar tenant with VRFs, BDs, EPGs, contracts (wrong scopes), L3Out (wrong IPs)

## Study Guide
See the `EXAM-INSTRUCTIONS.md` file in the repository root for exam-style tasks.
