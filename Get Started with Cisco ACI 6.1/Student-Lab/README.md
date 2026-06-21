# Student Lab - ACI Study Environment

## Purpose
This folder deploys a complete ACI configuration with **intentional misconfigurations** for troubleshooting practice. Students should use the ACI GUI to identify and fix issues rather than modifying terraform files.

## Quick Setup

Credentials are pre-configured. Simply run:

```bash
terraform init
terraform apply -auto-approve
```

## Credentials (Pre-configured)
- **APIC**: https://198.18.133.200 (admin / C1sco12345)
- **vCenter**: administrator@vsphere.local / C1sco12345

## What's Deployed

### Fabric
- **Nodes**: Leaf-7 (201), Leaf-8 (202), Spine-3 (203), Spine-4 (204)
- **BGP Route Reflector**: Configured with wrong ASN and missing spine

### Access Policies
- **VLAN Pools**: vmm-pool (150-160), baremetal-pool (50-60, 902), l3out-pool (900)
- **Domains**: Baremetal (Physical), EXTERNAL-L3-DOM (L3)
- **AAEPs**: VIRTUAL-AEP, NETWORK-AEP
- **Interface Policy Groups**: ESX-SRV03, IPG-SW2-VPC, IPG-ROUTERS, ESX-SRVR05
- **Switch Profiles**: LEAF-7-SW-PROF, LEAF-8-SW-PROF, LEAFA-SW-PROF

### VMM Integration
- **Domain**: CCIE-DVS with intentional access_mode and allocation errors

### Tenant (Xandar)
- **VRFs**: LEGACY-VRF, PROD-VRF, DEV-VRF
- **Bridge Domains**: BD-LEGACY, BD-PROD, BD-DEV
- **Application Profiles**: LEGACY-DIAG-APP, PHARM-WEB, PHARM-APP, PHARM-DB
- **Contracts**: PING (wrong scope), INET-TO-WEB (missing filters)
- **L3Out**: CORE-L3OUT with wrong IP addressing and missing BGP config

## Intentional Misconfigurations Summary

| Component | Issue | Fix |
|-----------|-------|-----|
| CDP_Disable policy | Actually enabled | Set admin_state to false |
| LLDP_Enable policy | Actually disabled | Set admin states to true |
| ESX-SRV03 IPG | Missing AAEP | Assign VIRTUAL-AEP |
| ESX-SRV03 IPG | Wrong port-channel | Change to MAC Pinning |
| VMM Domain | read-only mode | Change to read-write |
| vmm-pool | static allocation | Change to dynamic |
| BGP ASN | 65000 | Should be 65501 |
| BGP RR | Only Spine 203 | Add Spine 204 |
| PING contract | VRF scope | Change to Application Profile |
| INET-TO-WEB | App Profile scope | Change to VRF |
| INET-TO-WEB | Only ICMP filter | Add HTTP/HTTPS |
| L3Out interface IP | 10.10.10.107/30 | Should be 172.16.111.2/30 |
| L3Out loopback | Empty | Add 1.1.1.101 |
| External EPG subnet | 0.0.0.0/0 | Should be 10.30.0.0/16 |

## Study Guide
See `EXAM-INSTRUCTIONS.md` in the repository root for exam-style tasks and scoring.
