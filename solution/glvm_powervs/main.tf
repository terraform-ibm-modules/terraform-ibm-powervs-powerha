#######################################################
# Site1 PowerVS Network Creation and Import Image
#######################################################

module "site1_powervs_workspace_update" {
  source = "../../modules/powervs-workspace-update"

  powervs_workspace_guid = local.site1_powervs_workspace_guid
  powervs_subnet_list    = local.site1_powervs_subnet_list
  aix_os_image           = local.site1_powervs_image_id == null ? var.aix_os_image : null
}


#####################################################
# CC Subnet Attach module
# Non PER DC: Attaches Subnets to CCs
# PER DC: Skip
#####################################################

module "site1_cloud_connection_network_attach" {
  depends_on = [module.site1_powervs_workspace_update]
  source     = "../../modules/cloud-connection-network-attach"
  count      = local.site1_cloud_connection_count > 0 ? 1 : 0

  powervs_workspace_guid = local.site1_powervs_workspace_guid
  private_subnet_ids     = module.site1_powervs_workspace_update.powervs_subnet_list[*].id
  cloud_connection_count = local.site1_cloud_connection_count
}


#######################################################
# Site2 PowerVS Workspace, Network Creation and Import Image
#######################################################

module "site2_powervs_workspace_create" {
  depends_on = [module.site1_cloud_connection_network_attach]
  source     = "../../modules/powervs-workspace-create"

  prefix                      = var.prefix
  powervs_zone                = var.site2_powervs_zone
  ssh_public_key              = var.ssh_public_key
  powervs_resource_group_name = var.powervs_resource_group_name
  cloud_connection            = var.site2_cloud_connection
  transit_gateway_connection  = local.transit_gateway_connection
  aix_os_image                = [var.aix_os_image]
  tags                        = var.tags
  powervs_subnet_list         = local.site2_powervs_subnet_list
}


#####################################################
# CC Subnet Attach module
# Non PER DC: Attaches Subnets to CCs
# PER DC: Skip
#####################################################

module "site2_cloud_connection_network_attach" {
  depends_on = [module.site2_powervs_workspace_create]
  source     = "../../modules/cloud-connection-network-attach"
  count      = local.site2_cloud_connection_count > 0 ? 1 : 0

  powervs_workspace_guid = module.site2_powervs_workspace_create.powervs_workspace_guid
  private_subnet_ids     = module.site2_powervs_workspace_create.powervs_subnet_list[*].id
  cloud_connection_count = local.site2_cloud_connection_count
}


#####################################################
# Site1 PowerVS Instance Creation
#####################################################

module "site1_powervs_instance" {
  depends_on = [module.site2_cloud_connection_network_attach]
  source     = "../../modules/powervs-instance-custom"

  powervs_workspace_guid = local.site1_powervs_workspace_guid
  ssh_public_key_name    = local.site1_powervs_sshkey_name

  pi_prefix                   = var.prefix
  pi_image_id                 = local.site1_pi_instance.aix_image_id
  pi_networks                 = local.site1_pi_instance.powervs_networks
  pi_number_of_processors     = local.site1_pi_instance.number_of_processors
  pi_memory_size              = local.site1_pi_instance.memory_size
  pi_cpu_proc_type            = local.site1_pi_instance.cpu_proc_type
  pi_storage_type             = local.site1_pi_instance.tier
  pi_server_type              = var.powervs_machine_type
  pi_instance_count           = var.site1_powervs_instance_count
  powervs_reserve_subnet_list = var.site1_reserve_subnet_list
  dedicated_volume_count      = var.dedicated_volume
  shared_volume_count         = var.shared_volume
  dedicated_volume_attributes = var.dedicated_volume_attributes
  shared_volume_attributes    = var.shared_volume_attributes
  pha_shared_volume           = local.pha_vg_shared_disks
}


#####################################################
# Site2 PowerVS Instance Creation
#####################################################

module "site2_powervs_instance" {
  depends_on = [module.site1_powervs_instance]
  source     = "../../modules/powervs-instance-custom"

  powervs_workspace_guid = module.site2_powervs_workspace_create.powervs_workspace_guid
  ssh_public_key_name    = module.site2_powervs_workspace_create.powervs_ssh_public_key.name

  pi_prefix                   = var.prefix
  pi_image_id                 = local.site2_pi_instance.aix_image_id
  pi_networks                 = local.site2_pi_instance.powervs_networks
  pi_number_of_processors     = local.site2_pi_instance.number_of_processors
  pi_memory_size              = local.site2_pi_instance.memory_size
  pi_cpu_proc_type            = local.site2_pi_instance.cpu_proc_type
  pi_storage_type             = local.site2_pi_instance.tier
  pi_server_type              = var.powervs_machine_type
  pi_instance_count           = var.site2_powervs_instance_count
  powervs_reserve_subnet_list = var.site2_reserve_subnet_list
  dedicated_volume_count      = var.dedicated_volume
  shared_volume_count         = var.shared_volume
  dedicated_volume_attributes = var.dedicated_volume_attributes
  shared_volume_attributes    = var.shared_volume_attributes
  pha_shared_volume           = local.pha_vg_shared_disks
}


# #####################################################
# # PowerVS Instance Ansible Configuration
# # #####################################################

# # module "powervs_instance_ansible_config" {
# #   depends_on = [module.powervs_instance, local.node_details]
# #   source     = "../../modules/powervs-instance-ansible-config"

# #   ssh_private_key              = var.ssh_private_key
# #   bastion_host_ip              = local.bastion_host_ip
# #   proxy_ip_and_port            = local.proxy_ip_and_port
# #   node_details                 = local.node_details
# #   subnet_list                  = var.powervs_subnet_list
# #   reserved_subnet_list         = var.powervs_reserve_subnet_list
# #   reserve_ip_data              = module.powervs_instance.reserve_ips
# #   pha_cos_data                 = var.cos_powerha_image_download
# #   repository_disk_wwn          = module.powervs_instance.shared_volume_data[0].wwn
# #   shared_disk_wwns             = module.powervs_instance.pha_shared_volume_data[*].wwn
# #   powerha_resource_group_count = var.powerha_resource_group
# #   powerha_resource_group_list  = var.powerha_resource_group_list
# #   volume_group_count           = var.volume_group
# #   volume_group_list            = var.volume_group_list
# #   file_system_count            = var.file_system
# #   file_system_list             = var.file_system_list
# # }
