#####################################################
# Create Placement group different server
#####################################################

resource "ibm_pi_placement_group" "different_server" {
  pi_placement_group_name   = "${var.powervs_instance_name}-cluster"
  pi_placement_group_policy = "anti-affinity"
  pi_cloud_instance_id      = var.powervs_workspace_guid
}

#####################################################
# Get highest capacity storage pool name
#####################################################

data "ibm_pi_storage_pools_capacity" "pools" {
  pi_cloud_instance_id = var.powervs_workspace_guid
}

locals {
  highest_capacity_pool_name = data.ibm_pi_storage_pools_capacity.pools.maximum_storage_allocation.storage_pool
  shareable_volume_list = [
    { name = "shared", size = "400", tier = "tier1" },
    { name = "shared", size = "200", tier = "tier1" },
    { name = "shared", size = "100", tier = "tier1" },

  ]
}

#####################################################
# Create shareable volumes
#####################################################

resource "ibm_pi_volume" "cluster_volumes" {
  count = length(local.shareable_volume_list)

  pi_volume_shareable = true
  pi_volume_name      = "${var.powervs_instance_name}-${local.shareable_volume_list[count.index].name}-${count.index}"
  pi_volume_size      = local.shareable_volume_list[count.index].size
  pi_volume_type      = local.shareable_volume_list[count.index].tier
  pi_volume_pool      = local.highest_capacity_pool_name

  pi_cloud_instance_id = var.powervs_workspace_guid

  timeouts {
    create = "15m"
  }

  lifecycle {
    ignore_changes = [pi_cloud_instance_id]
  }
}

locals {
  shareable_volume_ids = [for vol in ibm_pi_volume.cluster_volumes : vol.volume_id]
  powervs_dedicated_filesystem_config = [
    for storage in var.powervs_dedicated_filesystem_config :
    merge(storage, { pool = local.highest_capacity_pool_name })
  ]
}

#####################################################
# Create Upto 4 Cluster nodes
#####################################################

module "powervs_instance_node_1" {
  #source  = "terraform-ibm-modules/powervs-instance/ibm"
  #version = "1.0.3"
  source = "git::https://github.com/terraform-ibm-modules/terraform-ibm-powervs-instance.git?ref=power_ha"

  pi_workspace_guid          = var.powervs_workspace_guid
  pi_ssh_public_key_name     = var.powervs_ssh_public_key_name
  pi_image_id                = var.powervs_image_id
  pi_boot_image_storage_tier = var.powervs_boot_image_storage_tier
  pi_boot_image_storage_pool = local.highest_capacity_pool_name
  pi_networks                = var.powervs_networks
  pi_instance_name           = "${var.powervs_instance_name}-1"
  pi_cpu_proc_type           = var.powervs_cpu_proc_type
  pi_server_type             = var.powervs_server_type
  pi_number_of_processors    = var.powervs_number_of_processors
  pi_memory_size             = var.powervs_memory_size
  pi_placement_group_id      = ibm_pi_placement_group.different_server.placement_group_id
  pi_storage_config          = local.powervs_dedicated_filesystem_config
  pi_existing_volume_ids     = local.shareable_volume_ids

}

module "powervs_instance_node_2" {
  #source  = "terraform-ibm-modules/powervs-instance/ibm"
  #version = "1.0.3"
  source = "git::https://github.com/terraform-ibm-modules/terraform-ibm-powervs-instance.git?ref=power_ha"

  count      = var.powerv_cluster_nodes > 1 ? 1 : 0
  depends_on = [module.powervs_instance_node_1]

  pi_workspace_guid          = var.powervs_workspace_guid
  pi_ssh_public_key_name     = var.powervs_ssh_public_key_name
  pi_image_id                = var.powervs_image_id
  pi_boot_image_storage_tier = var.powervs_boot_image_storage_tier
  pi_boot_image_storage_pool = local.highest_capacity_pool_name
  pi_networks                = var.powervs_networks
  pi_instance_name           = "${var.powervs_instance_name}-2"
  pi_cpu_proc_type           = var.powervs_cpu_proc_type
  pi_server_type             = var.powervs_server_type
  pi_number_of_processors    = var.powervs_number_of_processors
  pi_memory_size             = var.powervs_memory_size
  pi_placement_group_id      = ibm_pi_placement_group.different_server.placement_group_id
  pi_storage_config          = local.powervs_dedicated_filesystem_config
  pi_existing_volume_ids     = local.shareable_volume_ids

}

module "powervs_instance_node_3" {
  #source  = "terraform-ibm-modules/powervs-instance/ibm"
  #version = "1.0.3"
  source = "git::https://github.com/terraform-ibm-modules/terraform-ibm-powervs-instance.git?ref=power_ha"

  count      = var.powerv_cluster_nodes > 2 ? 1 : 0
  depends_on = [module.powervs_instance_node_2]

  pi_workspace_guid          = var.powervs_workspace_guid
  pi_ssh_public_key_name     = var.powervs_ssh_public_key_name
  pi_image_id                = var.powervs_image_id
  pi_boot_image_storage_tier = var.powervs_boot_image_storage_tier
  pi_boot_image_storage_pool = local.highest_capacity_pool_name
  pi_networks                = var.powervs_networks
  pi_instance_name           = "${var.powervs_instance_name}-3"
  pi_cpu_proc_type           = var.powervs_cpu_proc_type
  pi_server_type             = var.powervs_server_type
  pi_number_of_processors    = var.powervs_number_of_processors
  pi_memory_size             = var.powervs_memory_size
  pi_placement_group_id      = ibm_pi_placement_group.different_server.placement_group_id
  pi_storage_config          = local.powervs_dedicated_filesystem_config
  pi_existing_volume_ids     = local.shareable_volume_ids

}

module "powervs_instance_node_4" {
  #source  = "terraform-ibm-modules/powervs-instance/ibm"
  #version = "1.0.3"
  source = "git::https://github.com/terraform-ibm-modules/terraform-ibm-powervs-instance.git?ref=power_ha"

  count      = var.powerv_cluster_nodes > 3 ? 1 : 0
  depends_on = [module.powervs_instance_node_3]

  pi_workspace_guid          = var.powervs_workspace_guid
  pi_ssh_public_key_name     = var.powervs_ssh_public_key_name
  pi_image_id                = var.powervs_image_id
  pi_boot_image_storage_tier = var.powervs_boot_image_storage_tier
  pi_boot_image_storage_pool = local.highest_capacity_pool_name
  pi_networks                = var.powervs_networks
  pi_instance_name           = "${var.powervs_instance_name}-4"
  pi_cpu_proc_type           = var.powervs_cpu_proc_type
  pi_server_type             = var.powervs_server_type
  pi_number_of_processors    = var.powervs_number_of_processors
  pi_memory_size             = var.powervs_memory_size
  pi_placement_group_id      = ibm_pi_placement_group.different_server.placement_group_id
  pi_storage_config          = local.powervs_dedicated_filesystem_config
  pi_existing_volume_ids     = local.shareable_volume_ids

}

module "powervs_instance_node_5" {
  #source  = "terraform-ibm-modules/powervs-instance/ibm"
  #version = "1.0.3"
  source = "git::https://github.com/terraform-ibm-modules/terraform-ibm-powervs-instance.git?ref=power_ha"

  count      = var.powerv_cluster_nodes > 4 ? 1 : 0
  depends_on = [module.powervs_instance_node_4]

  pi_workspace_guid          = var.powervs_workspace_guid
  pi_ssh_public_key_name     = var.powervs_ssh_public_key_name
  pi_image_id                = var.powervs_image_id
  pi_boot_image_storage_tier = var.powervs_boot_image_storage_tier
  pi_boot_image_storage_pool = local.highest_capacity_pool_name
  pi_networks                = var.powervs_networks
  pi_instance_name           = "${var.powervs_instance_name}-4"
  pi_cpu_proc_type           = var.powervs_cpu_proc_type
  pi_server_type             = var.powervs_server_type
  pi_number_of_processors    = var.powervs_number_of_processors
  pi_memory_size             = var.powervs_memory_size
  pi_placement_group_id      = ibm_pi_placement_group.different_server.placement_group_id
  pi_storage_config          = local.powervs_dedicated_filesystem_config
  pi_existing_volume_ids     = local.shareable_volume_ids

}
