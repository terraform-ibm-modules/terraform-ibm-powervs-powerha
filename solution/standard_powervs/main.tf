
#####################################################
# PowerVS Workspace Creation
#####################################################

module "powervs_workspace" {
  source = "../../modules/powervs-workspace-custom"

  powervs_zone                = var.powervs_zone
  prefix                      = var.prefix
  ssh_public_key              = var.ssh_public_key
  powervs_resource_group_name = var.powervs_resource_group_name
  powervs_subnet_list         = local.subnet_list
  cloud_connection            = var.cloud_connection
  transit_gateway_connection  = local.transit_gateway_connection
  aix_os_image                = [var.aix_os_image]
  tags                        = var.tags
}


#####################################################
# CC Subnet Attach module
# Non PER DC: Attaches Subnets to CCs
# PER DC: Skip
#####################################################

module "cloud_connection_network_attach" {
  depends_on = [module.powervs_workspace]
  source     = "../../modules/cloud-connection-network-attach"
  count      = local.cloud_connection_count > 0 ? 1 : 0

  pi_workspace_guid      = module.powervs_workspace.powervs_workspace_guid
  pi_private_subnet_ids  = module.powervs_workspace.powervs_subnet_ids
  cloud_connection_count = local.cloud_connection_count
}


#####################################################
# PowerVS Instance Creation
#####################################################

module "powervs_instance" {
  depends_on = [module.cloud_connection_network_attach]
  source     = "../../modules/powervs-instance-custom"

  pi_workspace_guid      = module.powervs_workspace.powervs_workspace_guid
  pi_ssh_public_key_name = module.powervs_workspace.powervs_ssh_public_key.name

  pi_prefix                      = var.prefix
  pi_image_id                    = local.pi_instance.pi_image_id
  pi_networks                    = local.pi_instance.pi_networks
  pi_server_type                 = var.powervs_machine_type
  pi_number_of_processors        = local.pi_instance.pi_number_of_processors
  pi_memory_size                 = local.pi_instance.pi_memory_size
  pi_cpu_proc_type               = local.pi_instance.pi_cpu_proc_type
  pi_storage_type                = local.pi_instance.pi_tier
  pi_instance_count              = var.powervs_instance_count
  powervs_reserve_subnet_list    = var.powervs_reserve_subnet_list
  pi_dedicated_volume_count      = var.dedicated_volume
  pi_shared_volume_count         = var.shared_volume
  pi_dedicated_volume_attributes = var.dedicated_volume_attributes
  pi_shared_volume_attributes    = var.shared_volume_attributes
  pha_shared_volume              = local.pha_vg_shared_disks
}


#####################################################
# PowerVS Instance Ansible Configuration
# #####################################################

module "powervs_instance_ansible_config" {
  depends_on = [module.powervs_instance, local.node_details]
  source     = "../../modules/powervs-instance-ansible-config"

  bastion_host_ip              = local.bastion_host_ip
  ssh_private_key              = var.ssh_private_key
  pi_cos_data                  = var.cos_powerha_image_download
  repository_disk_wwn          = module.powervs_instance.pi_shared_volume_data[0].wwn
  shared_disk_wwns             = module.powervs_instance.pha_shared_volume_data[*].wwn
  node_details                 = local.node_details
  proxy_ip_and_port            = local.proxy_ip_and_port
  aix_image_id                 = var.aix_os_image
  powerha_resource_group_count = var.powerha_resource_group
  powerha_resource_group_list  = var.powerha_resource_group_list
  volume_group_count           = var.volume_group
  volume_group_list            = var.volume_group_list
  file_system_count            = var.file_system
  file_system_list             = var.file_system_list
  subnet_list                  = var.powervs_subnet_list
  reserved_subnet_list         = var.powervs_reserve_subnet_list
  reserve_ip_data              = module.powervs_instance.reserve_ips
}
