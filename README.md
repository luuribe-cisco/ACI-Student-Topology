# ACI Study Lab - Topology Configuration

## Overview
This repository contains Terraform configurations to deploy a pre-configured ACI environment for study and practice purposes. The configuration is designed to work with Cisco dCloud "Getting Started with Cisco ACI 6.1" topology.

The lab environment includes **intentional misconfigurations** that students must identify and fix through the ACI GUI, simulating real-world troubleshooting scenarios.

## Quick Start
1. Schedule the "Getting Started with Cisco ACI 6.1" demo in Cisco dCloud
2. Navigate to `Get Started with Cisco ACI 6.1/Student-Lab/`
3. Run:
   ```bash
   terraform init
   terraform apply -auto-approve
   ```
4. Follow [EXAM-INSTRUCTIONS.md](EXAM-INSTRUCTIONS.md) to complete the lab tasks

## Structure
```
├── EXAM-INSTRUCTIONS.md          # Exam-style tasks and instructions
├── ACI-Milestones.md             # Detailed study notes and hints
└── Get Started with Cisco ACI 6.1/
    └── Student-Lab/              # Terraform configuration
        ├── main.tf
        └── data/
            ├── 1_node_policies.nac.yaml
            ├── 2_fabric_policies.nac.yaml
            ├── 3_access_policies.nac.yaml
            └── 4_tenant_policies.nac.yaml
```

## Lab Content
- **Task 1**: Access Policies and VPC Configuration (25 pts)
- **Task 2**: VMM Integration Troubleshooting (25 pts)
- **Task 3**: Contract Configuration (15 pts)
- **Task 4**: L3Out Configuration and BGP (35 pts)

## Credentials (Pre-configured)
- **APIC**: admin / C1sco12345
- **vCenter**: administrator@vsphere.local / C1sco12345

## Disclaimer
These configurations are for study and practice purposes only. They were developed for a specific lab environment and include intentional misconfigurations for educational purposes.

Please see the LICENSE file for more details.