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
├── STUDENT-INSTRUCTIONS.md          
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
