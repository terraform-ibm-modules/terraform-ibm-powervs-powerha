# Basic Example: Power Virtual Server with VPC landing zone including Power Virtual Server for AIX instances

The basic example automates the following tasks:

- A **VPC Infrastructure** based on the value passed to `var.landing_zone_configuration` with the following components:
    -  **landing_zone_configuration = 3VPC_RHEL or 3VPC_SLES**

        - Provisions three VPCs with one VSI in each VPC: one management (jump/bastion) VSI, one inet-svs VSI configured as a squid proxy server, and one private-svs VSI (configured as NFS, NTP, DNS server) using [this preset](https://github.com/terraform-ibm-modules/terraform-ibm-powervs-infrastructure/blob/main/modules/powervs-vpc-landing-zone/presets/3vpc.preset.json.tftpl).
        - Installs and configures the Squid Proxy, DNS Forwarder, NTP forwarder, and NFS on hosts, and sets the host as the server for the NTP, NFS, and DNS services using Ansible Galaxy Collection Roles [ibm.power_linux_sap collection](https://galaxy.ansible.com/ui/repo/published/ibm/power_linux_sap/).

    -  **landing_zone_configuration = 1VPC_RHEL**

        - One VPC with one VSI for management (jump/bastion) using [this preset](https://github.com/terraform-ibm-modules/terraform-ibm-powervs-infrastructure/blob/main/modules/powervs-vpc-landing-zone/presets/1vpc.preset.json.tftpl).
        - Installation and configuration of Squid Proxy, DNS Forwarder, NTP forwarder, and NFS on the bastion host, and sets the host as the server for the NTP, NFS, and DNS services using Ansible Galaxy collection roles [ibm.power_linux_sap collection](https://galaxy.ansible.com/ui/repo/published/ibm/power_linux_sap/)

- **A Power Virtual Server workspace**  with the following network topology:
    - Creates two private networks: a management network and a backup network.
    - Creates one or two IBM Cloud connections in a non-PER environment.
    - Attaches the private networks to the IBM Cloud connections in a non-PER environment.
    - Attaches the IBM Cloud connections to a transit gateway in a non-PER environment.
    - Attaches the PowerVS workspace to Transit gateway in PER-enabled DC.
    - Creates an SSH key.

- Finally, interconnects both VPC and PowerVS infrastructure.

- **Power Virtual Server Instances**
   - Creates new private subnets according to the user's input for PowerHA cluster service and attaches it to cloud   connections (in Non-PER DC).
  - Creates and configures PowerVS instances according to the user's input for the PowerHA cluster based on best practices. A minimum of 2 and a maximum of 8 PowerVS instances are allowed.
- Tested with RHEL 8.6, AIX 7300-02-01 images.

## Notes
- User can change volume size, iops(tier0, tier1, tier3, fixed IOPS), and count of shared and dedicated volume.

|                                  Variation                                  | Available on IBM Catalog | Requires Schematics Workspace ID | Creates PowerVS with VPC landing zone | Creates PowerVS Instances | Performs PowerVS OS Config | Install PowerHA | Performs PowerHA Cluster Config |
|:---------------------------------------------------------------------------:|:------------------------:|:--------------------------------:|:-------------------------------------:|:-----------------------------:|:--------------------------:|:---------------------------:|:--------------------:|
| [ Basic Example ](./) |    :heavy_check_mark:    |        :heavy_check_mark:        |                  N/A                  |               2 to 8               |     N/A     |      N/A     |          N/A         |

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >=1.64.1 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.11.1 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloud_connection_network_attach"></a> [cloud\_connection\_network\_attach](#module\_cloud\_connection\_network\_attach) | ../../modules/cloud-connection-network-attach | n/a |
| <a name="module_fullstack"></a> [fullstack](#module\_fullstack) | terraform-ibm-modules/powervs-infrastructure/ibm//modules/powervs-vpc-landing-zone | 4.11.0 |
| <a name="module_powervs_instance"></a> [powervs\_instance](#module\_powervs\_instance) | ../../modules/powervs-instance-custom | n/a |
| <a name="module_powervs_workspace_update"></a> [powervs\_workspace\_update](#module\_powervs\_workspace\_update) | ../../modules/powervs-workspace-update | n/a |

### Resources

| Name | Type |
|------|------|
| [time_sleep.wait_10_mins](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aix_os_image"></a> [aix\_os\_image](#input\_aix\_os\_image) | AIX operating system images for Power Virtual Server instances. Power Virtual Server instances are installed with the given AIX OS image. The supported AIX OS images are: 7300-02-01, 7300-00-01, 7200-05-06. | `string` | `"7300-02-01"` | no |
| <a name="input_configure_dns_forwarder"></a> [configure\_dns\_forwarder](#input\_configure\_dns\_forwarder) | Specify if DNS forwarder will be configured. This will allow you to use central DNS servers (e.g. IBM Cloud DNS servers) sitting outside of the created IBM PowerVS infrastructure. If yes, ensure 'dns\_forwarder\_config' optional variable is set properly. DNS forwarder will be installed on the private-svs vsi. | `bool` | `true` | no |
| <a name="input_configure_nfs_server"></a> [configure\_nfs\_server](#input\_configure\_nfs\_server) | Specify if NFS server will be configured. This will allow you easily to share files between PowerVS instances (e.g., SAP installation files). NFS server will be installed on the private-svs vsi. If yes, ensure 'nfs\_server\_config' optional variable is set properly below. Default value is 1TB which will be mounted on /nfs. | `bool` | `true` | no |
| <a name="input_configure_ntp_forwarder"></a> [configure\_ntp\_forwarder](#input\_configure\_ntp\_forwarder) | Specify if NTP forwarder will be configured. This will allow you to synchronize time between IBM PowerVS instances. NTP forwarder will be installed on the private-svs vsi. | `bool` | `true` | no |
| <a name="input_custom_profile"></a> [custom\_profile](#input\_custom\_profile) | Overrides t-shirt profile: Custom PowerVS instance. Specify combination of cores, memory, proc\_type and storage tier. | <pre>object({<br>    cores     = number<br>    memory    = number<br>    proc_type = string<br>    tier      = string<br>  })</pre> | <pre>{<br>  "cores": 0.25,<br>  "memory": 4,<br>  "proc_type": "shared",<br>  "tier": "tier1"<br>}</pre> | no |
| <a name="input_dedicated_volume"></a> [dedicated\_volume](#input\_dedicated\_volume) | Count of dedicated volumes that need to be created and attached to every Power Virtual Server instance separately. | `number` | `0` | no |
| <a name="input_dedicated_volume_attributes"></a> [dedicated\_volume\_attributes](#input\_dedicated\_volume\_attributes) | Size(In GB) of dedicated volumes that need to be created and attached to every Power Virtual Server instance separately. | <pre>object({<br>    size = number<br>    tier = string<br>  })</pre> | <pre>{<br>  "size": 30,<br>  "tier": "tier3"<br>}</pre> | no |
| <a name="input_external_access_ip"></a> [external\_access\_ip](#input\_external\_access\_ip) | Specify the IP address or CIDR to login through SSH to the environment after deployment. Access to this environment will be allowed only from this IP address. | `string` | n/a | yes |
| <a name="input_ibmcloud_api_key"></a> [ibmcloud\_api\_key](#input\_ibmcloud\_api\_key) | The IBM Cloud platform API key needed to deploy IAM enabled resources. | `string` | n/a | yes |
| <a name="input_landing_zone_configuration"></a> [landing\_zone\_configuration](#input\_landing\_zone\_configuration) | VPC landing zone configuration. | `string` | n/a | yes |
| <a name="input_powervs_instance_count"></a> [powervs\_instance\_count](#input\_powervs\_instance\_count) | Number of Power Virtual Server instances required to create in the workspace for PowerHA cluster. | `number` | `2` | no |
| <a name="input_powervs_machine_type"></a> [powervs\_machine\_type](#input\_powervs\_machine\_type) | IBM Powervs machine type. The supported machine types are: s922, e980, s1022, e1080.<br>  For more details:<br>    [Availability of the machine type](https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-creating-power-virtual-server#creating-service)<br>    [IBM Cloud PowerVS documentation](https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-getting-started) | `string` | `"s922"` | no |
| <a name="input_powervs_reserve_subnet_list"></a> [powervs\_reserve\_subnet\_list](#input\_powervs\_reserve\_subnet\_list) | IBM Cloud Power Virtual Server subnet configuration details like name, CIDR, and reserved IP count used for PowerHA service label to be created. | <pre>list(object({<br>    name              = string<br>    cidr              = string<br>    reserved_ip_count = number<br>  }))</pre> | <pre>[<br>  {<br>    "cidr": "10.65.18.0/24",<br>    "name": "reserve_net",<br>    "reserved_ip_count": 1<br>  }<br>]</pre> | no |
| <a name="input_powervs_resource_group_name"></a> [powervs\_resource\_group\_name](#input\_powervs\_resource\_group\_name) | Existing IBM Cloud resource group name. | `string` | n/a | yes |
| <a name="input_powervs_subnet_list"></a> [powervs\_subnet\_list](#input\_powervs\_subnet\_list) | IBM Cloud Power Virtual Server subnet configuration details like name and CIDR. | <pre>list(object({<br>    name = string<br>    cidr = string<br>  }))</pre> | <pre>[<br>  {<br>    "cidr": "10.68.15.0/24",<br>    "name": "network_1"<br>  }<br>]</pre> | no |
| <a name="input_powervs_zone"></a> [powervs\_zone](#input\_powervs\_zone) | IBM Cloud data center location corresponding to the location used in 'Power Virtual Server with VPC landing zone' pre-requisite deployment. | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | A unique identifier for resources. The identifier must begin with a lowercase letter and end with a lowercase letter or a number. This prefix will be prepended to any resources provisioned by this template. Prefix must be 8 characters or fewer than 8 characters. | `string` | n/a | yes |
| <a name="input_shared_volume"></a> [shared\_volume](#input\_shared\_volume) | Count of shared volumes that need to created and attached to every Power Virtual Server instances. | `number` | `1` | no |
| <a name="input_shared_volume_attributes"></a> [shared\_volume\_attributes](#input\_shared\_volume\_attributes) | Size(In GB) of shared volumes that need to be created and attached to every Power Virtual Server instance separately. | <pre>object({<br>    size = number<br>    tier = string<br>  })</pre> | <pre>{<br>  "size": 30,<br>  "tier": "tier3"<br>}</pre> | no |
| <a name="input_ssh_private_key"></a> [ssh\_private\_key](#input\_ssh\_private\_key) | Private SSH key (RSA format) used to login to IBM Power Virtual Server instances. The private SSH key should match with the public SSH key referenced by the 'ssh\_public\_key' parameter. The input data must be in heredoc strings format (https://www.terraform.io/language/expressions/strings#heredoc-strings). The private SSH key is not uploaded or stored anywhere. For more information about SSH keys, see [SSH keys](https://cloud.ibm.com/docs/vpc?topic=vpc-ssh-keys). | `string` | n/a | yes |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | Public SSH Key for VSI creation. Must be an RSA key with a key size of either 2048 bits or 4096 bits (recommended). Must be a valid SSH key that does not already exist in the deployment region. | `string` | n/a | yes |
| <a name="input_tshirt_size"></a> [tshirt\_size](#input\_tshirt\_size) | Power Virtual Server instance profiles. Power Virtual instance will be created based on the following values:<br>    proc\_type: shared<br>    tier: tier1 (This value is the same for all profiles) | `string` | `"aix_xs"` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_host_ip"></a> [bastion\_host\_ip](#output\_bastion\_host\_ip) | IBM VPC VSI host IP address. |
| <a name="output_cloud_connection"></a> [cloud\_connection](#output\_cloud\_connection) | Number of cloud connections configured in created PowerVS infrastructure. |
| <a name="output_dns_host_or_ip"></a> [dns\_host\_or\_ip](#output\_dns\_host\_or\_ip) | DNS forwarder host for created PowerVS infrastructure. |
| <a name="output_nfs_host_or_ip_path"></a> [nfs\_host\_or\_ip\_path](#output\_nfs\_host\_or\_ip\_path) | NFS host for created PowerVS infrastructure. |
| <a name="output_ntp_host_or_ip"></a> [ntp\_host\_or\_ip](#output\_ntp\_host\_or\_ip) | NTP host for created PowerVS infrastructure. |
| <a name="output_powervs_images"></a> [powervs\_images](#output\_powervs\_images) | Object containing imported PowerVS image name and image id. |
| <a name="output_powervs_instances"></a> [powervs\_instances](#output\_powervs\_instances) | IBM PowerVS instance Data. |
| <a name="output_powervs_ssh_public_key"></a> [powervs\_ssh\_public\_key](#output\_powervs\_ssh\_public\_key) | SSH public key name. |
| <a name="output_powervs_subnet_list"></a> [powervs\_subnet\_list](#output\_powervs\_subnet\_list) | Network ID and name of private networks in PowerVS Workspace. |
| <a name="output_powervs_workspace_guid"></a> [powervs\_workspace\_guid](#output\_powervs\_workspace\_guid) | PowerVS infrastructure workspace guid. The GUID of the resource instance. |
| <a name="output_powervs_workspace_id"></a> [powervs\_workspace\_id](#output\_powervs\_workspace\_id) | PowerVS infrastructure workspace id. The unique identifier of the new resource instance. |
| <a name="output_powervs_workspace_name"></a> [powervs\_workspace\_name](#output\_powervs\_workspace\_name) | PowerVS infrastructure workspace name. |
| <a name="output_powervs_zone"></a> [powervs\_zone](#output\_powervs\_zone) | Zone where PowerVS infrastructure is created. |
| <a name="output_proxy_ip_and_port"></a> [proxy\_ip\_and\_port](#output\_proxy\_ip\_and\_port) | IBM VPC Proxy server IP and port details. |
| <a name="output_ssh_public_key"></a> [ssh\_public\_key](#output\_ssh\_public\_key) | The string value of the ssh public key used when deploying VPC |
| <a name="output_subnet_reserve_ips"></a> [subnet\_reserve\_ips](#output\_subnet\_reserve\_ips) | Reserve IP address of the network interface of IBM PowerVS instance. |
| <a name="output_transit_gateway_id"></a> [transit\_gateway\_id](#output\_transit\_gateway\_id) | The ID of transit gateway. |
| <a name="output_transit_gateway_name"></a> [transit\_gateway\_name](#output\_transit\_gateway\_name) | The name of the transit gateway. |
| <a name="output_vpc_names"></a> [vpc\_names](#output\_vpc\_names) | A list of the names of the VPC. |
| <a name="output_vsi_list"></a> [vsi\_list](#output\_vsi\_list) | A list of VSI with name, id, zone, and primary ipv4 address, VPC Name, and floating IP. |
| <a name="output_vsi_names"></a> [vsi\_names](#output\_vsi\_names) | A list of the vsis names provisioned within the VPCs. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
