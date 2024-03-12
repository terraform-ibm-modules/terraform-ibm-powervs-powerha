# Power HA cluster Deployment

It provisions the following components in IBM cloud:

- Creates Shareable volumes
- Creates PowerHA clusters of specified number of IBM® Power Virtual Server Instance in a pre-existing PowerVS Workspace (which contains Public SSH key and pre-imported OS image) with anti-affinity policy. All servers are placed on different physical machines.
- Creates volumes and attaches it to the instance.


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >=1.49.0 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_powervs_instance_node_1"></a> [powervs\_instance\_node\_1](#module\_powervs\_instance\_node\_1) | git::https://github.com/terraform-ibm-modules/terraform-ibm-powervs-instance.git | power_ha |
| <a name="module_powervs_instance_node_2"></a> [powervs\_instance\_node\_2](#module\_powervs\_instance\_node\_2) | git::https://github.com/terraform-ibm-modules/terraform-ibm-powervs-instance.git | power_ha |
| <a name="module_powervs_instance_node_3"></a> [powervs\_instance\_node\_3](#module\_powervs\_instance\_node\_3) | git::https://github.com/terraform-ibm-modules/terraform-ibm-powervs-instance.git | power_ha |
| <a name="module_powervs_instance_node_4"></a> [powervs\_instance\_node\_4](#module\_powervs\_instance\_node\_4) | git::https://github.com/terraform-ibm-modules/terraform-ibm-powervs-instance.git | power_ha |
| <a name="module_powervs_instance_node_5"></a> [powervs\_instance\_node\_5](#module\_powervs\_instance\_node\_5) | git::https://github.com/terraform-ibm-modules/terraform-ibm-powervs-instance.git | power_ha |

### Resources

| Name | Type |
|------|------|
| [ibm_pi_placement_group.different_server](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_placement_group) | resource |
| [ibm_pi_volume.cluster_volumes](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_volume) | resource |
| [ibm_pi_storage_pools_capacity.pools](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/pi_storage_pools_capacity) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ibmcloud_api_key"></a> [ibmcloud\_api\_key](#input\_ibmcloud\_api\_key) | The IBM Cloud platform API key needed to deploy IAM enabled resources. | `string` | n/a | yes |
| <a name="input_powerv_cluster_nodes"></a> [powerv\_cluster\_nodes](#input\_powerv\_cluster\_nodes) | Number of PowerVS instances in the cluster | `number` | n/a | yes |
| <a name="input_powervs_boot_image_storage_tier"></a> [powervs\_boot\_image\_storage\_tier](#input\_powervs\_boot\_image\_storage\_tier) | Storage type for server deployment; Possible values tier0, tier1 and tier3 | `string` | n/a | yes |
| <a name="input_powervs_cpu_proc_type"></a> [powervs\_cpu\_proc\_type](#input\_powervs\_cpu\_proc\_type) | Dedicated or shared processors. Required when not creating SAP instances. | `string` | n/a | yes |
| <a name="input_powervs_dedicated_filesystem_config"></a> [powervs\_dedicated\_filesystem\_config](#input\_powervs\_dedicated\_filesystem\_config) | Custom File systems to be created and attached to PowerVS instance. 'disk\_size' is in GB. 'count' specify over how many storage volumes the file system will be striped. 'tier' specifies the storage tier in PowerVS workspace. 'mount' specifies the mount point on the OS. | <pre>list(object({<br>    name  = string<br>    size  = string<br>    count = string<br>    tier  = string<br>    mount = string<br>  }))</pre> | n/a | yes |
| <a name="input_powervs_image_id"></a> [powervs\_image\_id](#input\_powervs\_image\_id) | Image ID used for PowerVS instance. Run 'ibmcloud pi images' to list available images. | `string` | n/a | yes |
| <a name="input_powervs_instance_name"></a> [powervs\_instance\_name](#input\_powervs\_instance\_name) | Name of instance which will be created. | `string` | n/a | yes |
| <a name="input_powervs_memory_size"></a> [powervs\_memory\_size](#input\_powervs\_memory\_size) | Amount of memory. Required when not creating SAP instances. | `string` | n/a | yes |
| <a name="input_powervs_networks"></a> [powervs\_networks](#input\_powervs\_networks) | Existing list of private subnet ids to be attached to an instance. The first element will become the primary interface. | <pre>list(<br>    object({<br>      name = string<br>      id   = string<br>      cidr = optional(string)<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_powervs_number_of_processors"></a> [powervs\_number\_of\_processors](#input\_powervs\_number\_of\_processors) | Number of processors. Required when not creating SAP instances. | `string` | n/a | yes |
| <a name="input_powervs_server_type"></a> [powervs\_server\_type](#input\_powervs\_server\_type) | Processor type e980/s922/e1080/s1022. Required when not creating SAP instances. | `string` | n/a | yes |
| <a name="input_powervs_ssh_public_key_name"></a> [powervs\_ssh\_public\_key\_name](#input\_powervs\_ssh\_public\_key\_name) | Name of the PowerVS SSH key to create. | `string` | n/a | yes |
| <a name="input_powervs_workspace_guid"></a> [powervs\_workspace\_guid](#input\_powervs\_workspace\_guid) | Existing GUID of the PowerVS workspace. The GUID of the service instance associated with an account. | `string` | n/a | yes |
| <a name="input_powervs_zone"></a> [powervs\_zone](#input\_powervs\_zone) | IBM Cloud PowerVS zone. | `string` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_highest_pool_capacity"></a> [highest\_pool\_capacity](#output\_highest\_pool\_capacity) | Pool with highest storage capacity |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
