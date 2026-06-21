# ACI Study Lab - Exam Instructions


---

## Pre-Lab Setup

Before starting the exam tasks, deploy the initial lab configuration:

```bash
cd "Get Started with Cisco ACI 6.1/Student-Lab"
terraform init
terraform apply -auto-approve
```

Wait for terraform to complete successfully before proceeding.

---

## Exam Tasks

### Task 1: Access Policies and VPC Configuration

You have been asked to configure a VPC connection for VMware ESXi hosts connected to Leaf-7 and Leaf-8.

**Requirements:**
1. Create a VPC Explicit Protection Group between Leaf-7 (Node 201) and Leaf-8 (Node 202)
   - Name: `VPC-LEAF-201-202`
   - VPC ID: `278`
   - Use the default VPC Domain Policy

2. Create an Interface Profile named `LEAF-8-INT-PROF` with an Interface Selector `L7-8-E1` configured for port Eth1/1

3. Associate the interface selector with the existing Interface Policy Group `ESX-SRV03`

4. Associate your new interface profile with the appropriate switch profiles (`LEAF-7-SW-PROF` and `LEAF-8-SW-PROF`)

5. Verify and correct any misconfigurations in the `ESX-SRV03` Interface Policy Group:
   - Verify CDP policy behavior matches its name
   - Verify LLDP policy behavior matches its name
   - Verify port-channel mode is appropriate for VMware (MAC Pinning)
   - Ensure the correct AAEP is assigned (`VIRTUAL-AEP`)

**Verification:** The VMM domain should show as connected through the VPC interface.

---

### Task 2: VMM Integration Troubleshooting

A VMware VMM domain named `CCIE-DVS` has been configured but is not functioning correctly.

**Requirements:**
1. Identify and correct the VMM domain access mode issue

2. Verify the VLAN pool allocation mode is appropriate for VMM integration

3. Ensure either CDP or LLDP is properly configured for neighbor discovery (not both enabled simultaneously)

4. Associate the EPG `PHARM-APP` (in application profile `PHARM-APP`) with the VMM domain `CCIE-DVS`:
   - Deployment Immediacy: On Demand
   - Resolution Immediacy: On Demand

5. Verify resolution immediacy settings on `DB-EPG` are set to Pre-Provision

**Verification:** VMs should be able to communicate based on contract policies.

---

### Task 3: Contract Configuration

Review and correct the contract configurations in the Xandar tenant.

**Requirements:**
1. The `PING` contract should only allow ICMP traffic between EPGs in the same Application Profile. Verify the scope is configured correctly.

2. Ensure contract relationships are correctly assigned:
   - `PHARM-APP` EPG: Consumer of PING
   - `DB-CACHE-EPG`: Consumer of PING  
   - `DB-EPG`: Provider of PING

**Verification:** Ping should succeed between the following VMs:
- aci-app-1 (172.16.4.100) → db-1 (172.16.3.9)
- db-cache-1 (172.16.5.10) → db-2 (172.16.3.10)

---

### Task 4: L3Out Configuration

An L3Out named `CORE-L3OUT` has been partially configured for BGP peering with an external router (DC2-N7K-SW1). Complete and correct the configuration.

**Fabric BGP Requirements:**
1. Correct the fabric BGP ASN (refer to neighbor configuration for correct value)
2. Ensure both spines are configured as route reflectors
3. Apply the BGP route reflector policy to Pod 1

**L3Out Requirements:**
1. Configure the correct loopback address on Node 201 (Router ID: 1.1.1.101)

2. Correct the interface IP address on Eth1/5. Reference information:
   ```
   Neighbor interface Eth3/12: 172.16.111.1/30
   ```

3. Configure eBGP peering:
   - Neighbor: 7.7.7.1
   - Remote AS: 65502
   - Use loopback for peering (eBGP multihop)

4. Correct the External EPG `CORPORATE-L3EPG`:
   - Subnet should be: 10.30.0.0/16
   - Scope: External Subnets for External EPG

5. Configure the `INET-TO-WEB` contract:
   - Add HTTP (port 80) and HTTPS (port 443) filters
   - Correct the contract scope for L3Out usage
   - Assign `CORPORATE-L3EPG` as Provider
   - Assign `WEB-EPG` as Consumer

6. Advertise subnet 172.16.2.0/24 externally from BD-PROD

**Verification:** 
- BGP neighborship should establish
- Ping from web-1 VM to 10.30.0.71 should succeed

---

## Reference Information

### Topology Details
| Device | Node ID | Role |
|--------|---------|------|
| Leaf-7 | 201 | Leaf |
| Leaf-8 | 202 | Leaf |
| Spine-3 | 203 | Spine |
| Spine-4 | 204 | Spine |

### VM Mapping
| EPG | VM Name | IP Address |
|-----|---------|------------|
| DB-EPG | db-1 | 172.16.3.9 |
| DB-EPG | db-2 | 172.16.3.10 |
| DB-CACHE-EPG | db-cache-1 | 172.16.5.10 |
| PHARM-APP | aci-app-1 | 172.16.4.100 |

### External Router (DC2-N7K-SW1) Configuration
```
router bgp 65502
  neighbor 1.1.1.101 remote-as 65501
    update-source loopback7
    ebgp-multihop 2
    address-family ipv4 unicast

interface Ethernet3/12
  description ACI Leaf107 Eth1-5
  ip address 172.16.111.1/30

interface loopback7
  ip address 7.7.7.1/32
```



