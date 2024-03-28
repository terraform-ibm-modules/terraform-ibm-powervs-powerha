
#####################################################
# PowerVS Workspace Creation
#####################################################

module "powervs-workspace" {
  source = "../../modules/powervs-workspace-custom"

  powervs_zone                = var.powervs_zone # Zone of ibm cloud
  prefix                      = var.prefix       # Prefix for the work space and ssh key
  ssh_public_key              = var.ssh_public_key
  powervs_resource_group_name = var.powervs_resource_group_name # Resource group name (by default : Default)
  powervs_subnet_list         = var.powervs_subnet_list         # Based on user requirement we need to update subnet cound
  cloud_connection            = var.cloud_connection
  transit_gateway_connection  = local.transit_gateway_connection # To connect with existing vpc and workspace
  powervs_image_names         = [var.powervs_image_names]
  tags                        = var.tags
}


#####################################################
# CC Subnet Attach module
# Non PER DC: Attaches Subnets to CCs
# PER DC: Skip
#####################################################

module "cloud-connection-network-attach" {
  depends_on = [module.powervs-workspace]
  source     = "../../modules/cloud-connection-network-attach"
  count      = local.cloud_connection_count > 0 ? 1 : 0

  pi_workspace_guid      = module.powervs-workspace.powervs_workspace_guid
  pi_private_subnet_ids  = module.powervs-workspace.powervs_subnet_ids
  cloud_connection_count = local.cloud_connection_count
}


#####################################################
# PowerVS Instance Creation
#####################################################

module "powervs_instance" {
  depends_on = [module.cloud-connection-network-attach]
  source     = "../../modules/powervs-instance-custom"

  pi_workspace_guid      = module.powervs-workspace.powervs_workspace_guid
  pi_ssh_public_key_name = module.powervs-workspace.powervs_ssh_public_key.name

  pi_prefix                 = var.prefix
  pi_image_id               = var.powervs_image_names
  pi_networks               = local.pi_instance.pi_networks
  pi_server_type            = local.pi_instance.pi_server_type
  pi_number_of_processors   = local.pi_instance.pi_number_of_processors
  pi_memory_size            = local.pi_instance.pi_memory_size
  pi_cpu_proc_type          = local.pi_instance.pi_cpu_proc_type
  pi_storage_type           = local.pi_instance.pi_tier
  pi_instance_count         = var.power_virtual_server
  powervs_subnet_list       = var.powervs_subnet_list
  pi_dedicated_volume_count = var.dedicated_volume
  pi_shared_volume_count    = var.shared_volume
}


#####################################################
# PowerVS Instance Ansible Configuration
# #####################################################

module "powervs_instance_ansible_config" {
  depends_on = [module.powervs_instance, local.node_details]
  source     = "../../modules/powervs-instance-ansible-config"

  bastion_host_ip              = local.bastion_host_ip
  ibmcloud_api_key             = var.ibmcloud_api_key
  ssh_public_key               = var.ssh_public_key
  ssh_private_key              = var.ssh_private_key
  pi_prefix                    = var.prefix
  pi_cos_data                  = var.cos_powerha_image_download
  shared_disk_wwns             = module.powervs_instance.pi_shared_volume_data[*].wwn
  nodes                        = module.powervs_instance.pi_instances[*].pi_instance_primary_ip
  node_details                 = local.node_details
  proxy_ip_and_port            = local.proxy_ip_and_port
  aix_image_id                 = var.powervs_image_names
  powerha_resource_group_count = var.powerha_resource_group
  powerha_resource_group_list  = var.powerha_resource_group_list
  volume_group_count           = var.volume_group
  volume_group_list            = var.volume_group_list
  file_system_count            = var.file_system
  file_system_list             = var.file_system_list
  subnet_list                  = var.powervs_subnet_list
  reserve_ip_data              = module.powervs_instance.reserve_ips
}
