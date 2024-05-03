# End to End Power Virtual Server infrastructure for PowerHA deployments

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
| <a name="module_fullstack"></a> [fullstack](#module\_fullstack) | terraform-ibm-modules/powervs-infrastructure/ibm//modules/powervs-vpc-landing-zone | 4.10.0 |
| <a name="module_powervs_instance"></a> [powervs\_instance](#module\_powervs\_instance) | ../../modules/powervs-instance-custom | n/a |
| <a name="module_powervs_instance_ansible_config"></a> [powervs\_instance\_ansible\_config](#module\_powervs\_instance\_ansible\_config) | ../../modules/powervs-instance-ansible-config | n/a |
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
| <a name="input_cos_powerha_image_download"></a> [cos\_powerha\_image\_download](#input\_cos\_powerha\_image\_download) | Details about cloud object storage bucket where PowerHA installation media folder and ssl file are located. For more details click [here](https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-service-credentials).<br>  Example:<br>    {<br>      "bucket\_name":"bucket-name",<br>      "cos\_access\_key\_id":"1dxxxxxxxxxx36",<br>      "cos\_secret\_access\_key":"4dxxxxxx5c",<br>      "cos\_endpoint":"https://s3.region.cloud-object-storage.appdomain.cloud",<br>      "folder\_name":"powerha-build-parent-folder-name",<br>      "ssl\_file\_name": "ssl-file-path"<br>    }<br><br>  You can keep the PowerHA images in the following format in the IBM Cloud COS Bucket.<br>  Example: 728 is a parent folder<br>    728/Gold/<filename>.tar.gz<br>    728/SPx/<filename>.tar.gz | <pre>object({<br>    bucket_name           = string<br>    cos_access_key_id     = string<br>    cos_secret_access_key = string<br>    cos_endpoint          = string<br>    folder_name           = string<br>    ssl_file_name         = string<br>  })</pre> | <pre>{<br>  "bucket_name": "powerha-images",<br>  "cos_access_key_id": "",<br>  "cos_endpoint": "https://s3.us-east.cloud-object-storage.appdomain.cloud",<br>  "cos_secret_access_key": "",<br>  "folder_name": "728",<br>  "ssl_file_name": "openssl-1.1.2.2200.tar.Z"<br>}</pre> | no |
| <a name="input_custom_profile"></a> [custom\_profile](#input\_custom\_profile) | Overrides t-shirt profile: Custom PowerVS instance. Specify combination of cores, memory, proc\_type and storage tier. | <pre>object({<br>    cores     = number<br>    memory    = number<br>    proc_type = string<br>    tier      = string<br>  })</pre> | <pre>{<br>  "cores": 0.25,<br>  "memory": 4,<br>  "proc_type": "shared",<br>  "tier": "tier1"<br>}</pre> | no |
| <a name="input_dedicated_volume"></a> [dedicated\_volume](#input\_dedicated\_volume) | Count of dedicated volumes that need to be created and attached to every Power Virtual Server instance separately. | `number` | `0` | no |
| <a name="input_dedicated_volume_attributes"></a> [dedicated\_volume\_attributes](#input\_dedicated\_volume\_attributes) | Size(In GB) of dedicated volumes that need to be created and attached to every Power Virtual Server instance separately. | <pre>object({<br>    size = number<br>    tier = string<br>  })</pre> | <pre>{<br>  "size": 30,<br>  "tier": "tier3"<br>}</pre> | no |
| <a name="input_external_access_ip"></a> [external\_access\_ip](#input\_external\_access\_ip) | Specify the IP address or CIDR to login through SSH to the environment after deployment. Access to this environment will be allowed only from this IP address. | `string` | n/a | yes |
| <a name="input_file_system"></a> [file\_system](#input\_file\_system) | Number of File systems which need to be created in PowerHA. | `number` | `2` | no |
| <a name="input_file_system_list"></a> [file\_system\_list](#input\_file\_system\_list) | List of parameters for file system - Individual PowerHA file system configuration. Based on the file\_system count, you can provide all the file system configuration like name, size\_per\_unit, block\_size, type of file system, Units and volume group name. Default configuration will be taken if details are not provided. | <pre>list(object({<br>    name          = string<br>    type          = string<br>    volume_group  = string<br>    units         = number<br>    size_per_unit = string<br>    block_size    = number<br>  }))</pre> | <pre>[<br>  {<br>    "block_size": "1024",<br>    "name": "fs2",<br>    "size_per_unit": "megabytes",<br>    "type": "enhanced",<br>    "units": "100",<br>    "volume_group": "VG1"<br>  },<br>  {<br>    "block_size": "1024",<br>    "name": "FS1",<br>    "size_per_unit": "megabytes",<br>    "type": "enhanced",<br>    "units": "100",<br>    "volume_group": "VG1"<br>  }<br>]</pre> | no |
| <a name="input_ibmcloud_api_key"></a> [ibmcloud\_api\_key](#input\_ibmcloud\_api\_key) | The IBM Cloud platform API key needed to deploy IAM enabled resources. | `string` | n/a | yes |
| <a name="input_landing_zone_configuration"></a> [landing\_zone\_configuration](#input\_landing\_zone\_configuration) | VPC landing zone configuration. | `string` | n/a | yes |
| <a name="input_powerha_resource_group"></a> [powerha\_resource\_group](#input\_powerha\_resource\_group) | Number of Resource Groups which need to be created in PowerHA. | `number` | `1` | no |
| <a name="input_powerha_resource_group_list"></a> [powerha\_resource\_group\_list](#input\_powerha\_resource\_group\_list) | List of parameters for Resource group - Individual PowerHA Resource group configuration. Based on the powerha\_resource\_group count, you can provide all the resource group configuration like name, start up, fallover and fallback polices. Default configuration will be taken if details are not provided. | <pre>list(object({<br>    name     = string<br>    startup  = string<br>    fallover = string<br>    fallback = string<br>  }))</pre> | <pre>[<br>  {<br>    "fallback": "NFB",<br>    "fallover": "FNPN",<br>    "name": "RG1",<br>    "startup": "OHN"<br>  }<br>]</pre> | no |
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
| <a name="input_volume_group"></a> [volume\_group](#input\_volume\_group) | Number of Volume Groups which need to be created in PowerHA. | `number` | `2` | no |
| <a name="input_volume_group_list"></a> [volume\_group\_list](#input\_volume\_group\_list) | List of parameters for volume group - Individual PowerHA volume group configuration. Based on the volume\_group count, you can provide all the volume group configuration like name, resource group name, type, size, tier. Default configuration will be taken if details are not provided. | <pre>list(object({<br>    name    = string<br>    rg_name = string<br>    type    = string<br>    size    = number<br>    tier    = string<br>  }))</pre> | <pre>[<br>  {<br>    "name": "VG1",<br>    "rg_name": "RG1",<br>    "size": 40,<br>    "tier": "tier0",<br>    "type": "original"<br>  },<br>  {<br>    "name": "VG2",<br>    "rg_name": "RG2",<br>    "size": 50,<br>    "tier": "tier1",<br>    "type": "original"<br>  }<br>]</pre> | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_host_ip"></a> [bastion\_host\_ip](#output\_bastion\_host\_ip) | IBM VPC VSI host IP address. |
| <a name="output_cloud_connection"></a> [cloud\_connection](#output\_cloud\_connection) | Number of cloud connections configured in created PowerVS infrastructure. |
| <a name="output_dns_host_or_ip"></a> [dns\_host\_or\_ip](#output\_dns\_host\_or\_ip) | DNS forwarder host for created PowerVS infrastructure. |
| <a name="output_nfs_host_or_ip_path"></a> [nfs\_host\_or\_ip\_path](#output\_nfs\_host\_or\_ip\_path) | NFS host for created PowerVS infrastructure. |
| <a name="output_ntp_host_or_ip"></a> [ntp\_host\_or\_ip](#output\_ntp\_host\_or\_ip) | NTP host for created PowerVS infrastructure. |
| <a name="output_pha_shared_volume_data"></a> [pha\_shared\_volume\_data](#output\_pha\_shared\_volume\_data) | PowerHA shared volumes data for volume groups. |
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
