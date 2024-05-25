# Power Virtual Server infrastructure for PowerHA deployments

# Summary
## Summary Outcome:
   PowerHA standard cluster configuration on IBM PowerVS hosts.

## Summary Tasks

- Creates new private subnets according to the user's input for PowerHA cluster service and attaches it to cloud connections (in Non-PER DC).
- Creates and configures PowerVS instances according to the user's input for the PowerHA cluster based on best practices. A minimum of 2 and a maximum of 8 PowerVS instances are allowed.
- Connects all created PowerVS instances to a proxy server specified by IP address or hostname for installing the dependencies.
- Post-instance provisioning and the PowerHA software download process(from COS) is being done.
- PowerHA installation and resource configuration for powerHA cluster using Ansible scripts.
- Tested with RHEL 8.6, AIX 7300-02-01 images.

## Before you begin
- **This solution requires a schematics workspace ID as input.**
- If you do not have a [Power Virtual Server with VPC landing zone deployment](https://cloud.ibm.com/catalog/architecture/deploy-arch-ibm-pvs-inf-2dd486c7-b317-4aaa-907b-42671485ad96-global?catalog_query=aHR0cHM6Ly9jbG91ZC5pYm0uY29tL2NhdGFsb2c%2Fc2VhcmNoPXBvd2VyI3NlYXJjaF9yZXN1bHRz) that is the full stack solution for a PowerVS Workspace with Secure Landing Zone, create it first.

## Notes
- User can change volume size, iops(tier0, tier1, tier3, fixed IOPS), and count of shared and dedicated volume.
- User can configure resource group, volume group, and filesystem for powerHA cluster services.

|                                  Variation                                  | Available on IBM Catalog | Requires Schematics Workspace ID | Creates PowerVS with VPC landing zone | Creates PowerVS Instances | Performs PowerVS OS Config | Install PowerHA | Performs PowerHA Cluster Config |
|:---------------------------------------------------------------------------:|:------------------------:|:--------------------------------:|:-------------------------------------:|:-----------------------------:|:--------------------------:|:---------------------------:|:--------------------:|
| [ PowerHA Standard Edition ](./) |    :heavy_check_mark:    |        :heavy_check_mark:        |                  N/A                  |               2 to 8               |     :heavy_check_mark:     |      :heavy_check_mark:     |          :heavy_check_mark:         |

## Architecture Diagram
![powerha-standard](https://github.com/terraform-ibm-modules/terraform-ibm-powervs-powerha/blob/main/reference-architectures/standard_powervs/PowerVS-PowerHA-Diagram.svg)


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | 1.65.1 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloud_connection_network_attach"></a> [cloud\_connection\_network\_attach](#module\_cloud\_connection\_network\_attach) | ../../modules/cloud-connection-network-attach | n/a |
| <a name="module_powervs_instance"></a> [powervs\_instance](#module\_powervs\_instance) | ../../modules/powervs-instance-custom | n/a |
| <a name="module_powervs_instance_ansible_config"></a> [powervs\_instance\_ansible\_config](#module\_powervs\_instance\_ansible\_config) | ../../modules/powervs-instance-ansible-config | n/a |
| <a name="module_powervs_workspace_update"></a> [powervs\_workspace\_update](#module\_powervs\_workspace\_update) | ../../modules/powervs-workspace-update | n/a |

### Resources

| Name | Type |
|------|------|
| [ibm_schematics_output.schematics_output](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.65.1/docs/data-sources/schematics_output) | data source |
| [ibm_schematics_workspace.schematics_workspace](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.65.1/docs/data-sources/schematics_workspace) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aix_os_image"></a> [aix\_os\_image](#input\_aix\_os\_image) | AIX operating system images for Power Virtual Server instances. Power Virtual Server instances are installed with the given AIX OS image. | `string` | n/a | yes |
| <a name="input_cos_powerha_image_download"></a> [cos\_powerha\_image\_download](#input\_cos\_powerha\_image\_download) | Details about cloud object storage bucket where PowerHA installation media folder and ssl file are located. For more details click [here](https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-service-credentials).<br>  Example:<br>    {<br>      "bucket\_name":"bucket-name",<br>      "cos\_access\_key\_id":"xxxxxxxxxx",<br>      "cos\_secret\_access\_key":"xxxxxx",<br>      "cos\_endpoint":"https://s3.region.cloud-object-storage.appdomain.cloud",<br>      "folder\_name":"powerha-build-parent-folder-name",<br>      "ssl\_file\_name": "ssl-file-path"<br>    }<br><br>  You can keep the PowerHA images in the following format in the IBM Cloud COS Bucket.<br>  Example: 728 is a parent folder<br>    728/Gold/<filename>.tar.gz<br>    728/SPx/<filename>.tar.gz | <pre>object({<br>    bucket_name           = string<br>    cos_access_key_id     = string<br>    cos_secret_access_key = string<br>    cos_endpoint          = string<br>    folder_name           = string<br>    ssl_file_name         = string<br>  })</pre> | n/a | yes |
| <a name="input_custom_profile"></a> [custom\_profile](#input\_custom\_profile) | Overrides t-shirt profile: Custom PowerVS instance. Specify combination of cores, memory, proc\_type and storage tier. | <pre>object({<br>    cores     = number<br>    memory    = number<br>    proc_type = string<br>    tier      = string<br>  })</pre> | n/a | yes |
| <a name="input_dedicated_volume"></a> [dedicated\_volume](#input\_dedicated\_volume) | Count of dedicated volumes that need to be created and attached to every Power Virtual Server instance separately. | `number` | n/a | yes |
| <a name="input_dedicated_volume_attributes"></a> [dedicated\_volume\_attributes](#input\_dedicated\_volume\_attributes) | Size(In GB) of dedicated volumes that need to be created and attached to every Power Virtual Server instance separately. | <pre>object({<br>    size = number<br>    tier = string<br>  })</pre> | n/a | yes |
| <a name="input_file_system"></a> [file\_system](#input\_file\_system) | Number of File systems which need to be created in PowerHA. | `number` | n/a | yes |
| <a name="input_file_system_list"></a> [file\_system\_list](#input\_file\_system\_list) | List of parameters for file system - Individual PowerHA file system configuration. Based on the file\_system count, you can provide all the file system configuration like name, size\_per\_unit, block\_size, type of file system, Units and volume group name. Default configuration will be taken if details are not provided. | <pre>list(object({<br>    name          = string<br>    type          = string<br>    volume_group  = string<br>    units         = number<br>    size_per_unit = string<br>    block_size    = number<br>  }))</pre> | n/a | yes |
| <a name="input_ibmcloud_api_key"></a> [ibmcloud\_api\_key](#input\_ibmcloud\_api\_key) | The IBM Cloud platform API key needed to deploy IAM enabled resources. | `string` | n/a | yes |
| <a name="input_powerha_resource_group"></a> [powerha\_resource\_group](#input\_powerha\_resource\_group) | Number of Resource Groups which need to be created in PowerHA. | `number` | n/a | yes |
| <a name="input_powerha_resource_group_list"></a> [powerha\_resource\_group\_list](#input\_powerha\_resource\_group\_list) | List of parameters for Resource group - Individual PowerHA Resource group configuration. Based on the powerha\_resource\_group count, you can provide all the resource group configuration like name, start up, fallover and fallback polices. Default configuration will be taken if details are not provided. | <pre>list(object({<br>    name     = string<br>    startup  = string<br>    fallover = string<br>    fallback = string<br>  }))</pre> | n/a | yes |
| <a name="input_powervs_instance_count"></a> [powervs\_instance\_count](#input\_powervs\_instance\_count) | Number of Power Virtual Server instances required to create in the workspace for PowerHA cluster. | `number` | n/a | yes |
| <a name="input_powervs_machine_type"></a> [powervs\_machine\_type](#input\_powervs\_machine\_type) | IBM Powervs machine type. The supported machine types are: s922, e980, s1022, e1080.<br>  For more details:<br>    [Availability of the machine type](https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-creating-power-virtual-server#creating-service)<br>    [IBM Cloud PowerVS documentation](https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-getting-started) | `string` | n/a | yes |
| <a name="input_powervs_reserve_subnet_list"></a> [powervs\_reserve\_subnet\_list](#input\_powervs\_reserve\_subnet\_list) | IBM Cloud Power Virtual Server subnet configuration details like name, CIDR, and reserved IP count used for PowerHA service label to be created. | <pre>list(object({<br>    name              = string<br>    cidr              = string<br>    reserved_ip_count = number<br>  }))</pre> | n/a | yes |
| <a name="input_powervs_subnet_list"></a> [powervs\_subnet\_list](#input\_powervs\_subnet\_list) | IBM Cloud Power Virtual Server subnet configuration details like name and CIDR. | <pre>list(object({<br>    name = string<br>    cidr = string<br>  }))</pre> | n/a | yes |
| <a name="input_powervs_zone"></a> [powervs\_zone](#input\_powervs\_zone) | IBM Cloud data center location corresponding to the location used in 'Power Virtual Server with VPC landing zone' pre-requisite deployment. | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | A unique identifier for resources. The identifier must begin with a lowercase letter and end with a lowercase letter or a number. This prefix will be prepended to any resources provisioned by this template. Prefix must be 8 characters or fewer than 8 characters. | `string` | n/a | yes |
| <a name="input_prerequisite_workspace_id"></a> [prerequisite\_workspace\_id](#input\_prerequisite\_workspace\_id) | IBM Cloud Schematics workspace ID of an existing Power Virtual Server with VPC landing zone catalog solution. If you do not yet have an existing deployment, click [here](https://cloud.ibm.com/catalog/architecture/deploy-arch-ibm-pvs-inf-2dd486c7-b317-4aaa-907b-42671485ad96-global?) to create one. | `string` | n/a | yes |
| <a name="input_shared_volume"></a> [shared\_volume](#input\_shared\_volume) | Count of shared volumes that need to created and attached to every Power Virtual Server instances. | `number` | n/a | yes |
| <a name="input_shared_volume_attributes"></a> [shared\_volume\_attributes](#input\_shared\_volume\_attributes) | Size(In GB) of shared volumes that need to be created and attached to every Power Virtual Server instance separately. | <pre>object({<br>    size = number<br>    tier = string<br>  })</pre> | n/a | yes |
| <a name="input_ssh_private_key"></a> [ssh\_private\_key](#input\_ssh\_private\_key) | Private SSH key (RSA format) used to login to IBM Power Virtual Server instances. The private SSH key should match with the public SSH key referenced by the 'ssh\_public\_key' parameter. The input data must be in heredoc strings format (https://www.terraform.io/language/expressions/strings#heredoc-strings). The private SSH key is not uploaded or stored anywhere. For more information about SSH keys, see [SSH keys](https://cloud.ibm.com/docs/vpc?topic=vpc-ssh-keys). | `string` | n/a | yes |
| <a name="input_tshirt_size"></a> [tshirt\_size](#input\_tshirt\_size) | Power Virtual Server instance profiles. Power Virtual instance will be created based on the following values:<br>    proc\_type: shared<br>    tier: tier1 (This value is the same for all profiles) | `string` | n/a | yes |
| <a name="input_volume_group"></a> [volume\_group](#input\_volume\_group) | Number of Volume Groups which need to be created in PowerHA. | `number` | n/a | yes |
| <a name="input_volume_group_list"></a> [volume\_group\_list](#input\_volume\_group\_list) | List of parameters for volume group - Individual PowerHA volume group configuration. Based on the volume\_group count, you can provide all the volume group configuration like name, resource group name, type, size, tier. Default configuration will be taken if details are not provided. | <pre>list(object({<br>    name    = string<br>    rg_name = string<br>    type    = string<br>    size    = number<br>    tier    = string<br>  }))</pre> | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_host_ip"></a> [bastion\_host\_ip](#output\_bastion\_host\_ip) | IBM VPC VSI host IP address. |
| <a name="output_cloud_connection"></a> [cloud\_connection](#output\_cloud\_connection) | Number of cloud connections configured in created PowerVS infrastructure. |
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
| <a name="output_subnet_reserve_ips"></a> [subnet\_reserve\_ips](#output\_subnet\_reserve\_ips) | Reserve IP address of the network interface of IBM PowerVS instance. |
| <a name="output_transit_gateway_connection"></a> [transit\_gateway\_connection](#output\_transit\_gateway\_connection) | Transit gateway details. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
