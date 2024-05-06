<!-- BEGIN MODULE HOOK -->

# Power Virtual Server with PowerHA

[![Graduated (Supported)](https://img.shields.io/badge/status-Graduated%20(Supported)-brightgreen?style=plastic)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![latest release](https://img.shields.io/github/v/release/terraform-ibm-modules/terraform-ibm-powervs-infrastructure?logo=GitHub&sort=semver)](https://github.com/terraform-ibm-modules/terraform-ibm-powervs-powerha/releases/latest)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)

## Summary
This deployable architecture is designed to assist you in deploying PowerHA SystemMirror for AIX into IBM Cloud on the IBM Power Virtual Server infrastructure. This is the second step in the deployment process for creating a full environment. Before starting this step, you should first deploy 'Power Virtual Server with VPC landing zone'. Once this is completed, you are prepared to start this step.

PowerHA on Power Virtual Server creates and prepares Power Virtual Server instances for PowerHA SystemMirror workloads. After deployment completes, you may (depending on the framework you chose) begin login to your newly created virtual server instances directly and validate the PowerHA SystemMirror configuration based on the provided options. You may even modify the configuration if required.

Solutions offered:
1. [PowerHA Standard Edition ready for PowerVS](https://github.com/terraform-ibm-modules/terraform-ibm-powervs-powerha/tree/main/solutions/standard_powervs)
    - Creates Power Virtual Server workspace, Power Virtual instance, interconnects them, and configures AIX network management services and configure PowerHA SystemMirror using Ansible Scripts.

## Reference architectures
- [PowerHA Standard Edition ready for PowerVS](https://github.com/terraform-ibm-modules/terraform-ibm-powervs-powerha/tree/main/reference-architectures/PowerVS-PowerHA-Diagram.svg)


<!-- BEGIN OVERVIEW HOOK -->
## Overview
* [terraform-ibm-powervs-powerha](#terraform-ibm-powervs-powerha)
* [Submodules](./modules)
* [Examples](./examples)
    * [End to End Power Virtual Server infrastructure for PowerHA deployments](./examples/basic)
* [Contributing](#contributing)
<!-- END OVERVIEW HOOK -->

## Required IAM access policies

You need the following permissions to run this module.

- Account Management
    - **Resource Group** service
        - `Viewer` platform access
    - IAM Services
        - **Workspace for Power Virtual Server** service
        - **Power Virtual Server** service
            - `Editor` platform access
        - **VPC Infrastructure Services** service
            - `Editor` platform access
        - **Transit Gateway** service
            - `Editor` platform access
        - **Direct Link** service
            - `Editor` platform access

<!-- END MODULE HOOK -->

<!-- BEGIN CONTRIBUTING HOOK -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repository. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
<!-- END CONTRIBUTING HOOK -->
