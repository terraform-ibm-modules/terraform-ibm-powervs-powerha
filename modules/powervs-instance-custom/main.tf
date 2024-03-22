#####################################################
# Create Placement group different server
#####################################################

resource "ibm_pi_placement_group" "placement_group" {
  pi_placement_group_name   = "${var.pi_prefix}-pg"
  pi_placement_group_policy = "anti-affinity"
  pi_cloud_instance_id      = var.pi_workspace_guid
}

#####################################################
# Get highest capacity storage pool name
#####################################################

data "ibm_pi_storage_pools_capacity" "pools" {
  pi_cloud_instance_id = var.pi_workspace_guid
}

locals {
  highest_capacity_pool_name = data.ibm_pi_storage_pools_capacity.pools.maximum_storage_allocation.storage_pool
}

#####################################################
# Create shareable volumes
#####################################################

resource "ibm_pi_volume" "shared_volumes" {
  count = var.pi_shared_volume_count > 0 ? var.pi_shared_volume_count : 0

  pi_volume_shareable  = true
  pi_volume_name       = "${var.pi_prefix}-shared-${count.index}"
  pi_volume_size       = local.shared_volume_size
  pi_volume_type       = local.shared_volume_storage_type
  pi_volume_pool       = local.highest_capacity_pool_name
  pi_cloud_instance_id = var.pi_workspace_guid

  timeouts {
    create = "15m"
  }
}

locals {
  shareable_volume_ids = [for vol in ibm_pi_volume.shared_volumes : vol.volume_id]
  powervs_dedicated_filesystem_config = [
    for storage in local.default_pi_storage_config :
    merge(storage, { pool = local.highest_capacity_pool_name })
  ]
}


#####################################################
# Create Upto 8 Cluster nodes
#####################################################

module "powervs_instance_node_1" {
  source     = "terraform-ibm-modules/powervs-instance/ibm"
  version    = "1.1.0"
  depends_on = [ibm_pi_placement_group.placement_group, ibm_pi_volume.shared_volumes]

  pi_instance_name           = "${var.pi_prefix}-pvs-1"
  pi_workspace_guid          = var.pi_workspace_guid
  pi_ssh_public_key_name     = var.pi_ssh_public_key_name
  pi_image_id                = var.pi_image_id
  pi_networks                = var.pi_networks # Need to check
  pi_server_type             = var.pi_server_type
  pi_cpu_proc_type           = var.pi_cpu_proc_type
  pi_number_of_processors    = var.pi_number_of_processors
  pi_memory_size             = var.pi_memory_size
  pi_placement_group_id      = ibm_pi_placement_group.placement_group.placement_group_id
  pi_boot_image_storage_tier = var.pi_storage_type
  pi_boot_image_storage_pool = local.highest_capacity_pool_name
  pi_storage_config          = local.powervs_dedicated_filesystem_config
  pi_existing_volume_ids     = local.shareable_volume_ids
}

resource "time_sleep" "wait_60_sec_1" {
  depends_on      = [module.powervs_instance_node_1]
  create_duration = "60s"
}


module "powervs_instance_node_2" {
  source     = "terraform-ibm-modules/powervs-instance/ibm"
  version    = "1.1.0"
  count      = var.pi_instance_count > 1 ? 1 : 0
  depends_on = [module.powervs_instance_node_1, time_sleep.wait_60_sec_1]

  pi_instance_name           = "${var.pi_prefix}-pvs-2"
  pi_workspace_guid          = var.pi_workspace_guid
  pi_ssh_public_key_name     = var.pi_ssh_public_key_name
  pi_image_id                = var.pi_image_id
  pi_networks                = var.pi_networks # Need to check
  pi_server_type             = var.pi_server_type
  pi_cpu_proc_type           = var.pi_cpu_proc_type
  pi_number_of_processors    = var.pi_number_of_processors
  pi_memory_size             = var.pi_memory_size
  pi_placement_group_id      = ibm_pi_placement_group.placement_group.placement_group_id
  pi_boot_image_storage_tier = var.pi_storage_type
  pi_boot_image_storage_pool = local.highest_capacity_pool_name
  pi_storage_config          = local.powervs_dedicated_filesystem_config
  pi_existing_volume_ids     = local.shareable_volume_ids

}

resource "time_sleep" "wait_60_sec_2" {
  depends_on      = [module.powervs_instance_node_2]
  count           = var.pi_instance_count > 2 ? 1 : 0
  create_duration = "60s"
}


module "powervs_instance_node_3" {
  source     = "terraform-ibm-modules/powervs-instance/ibm"
  version    = "1.1.0"
  count      = var.pi_instance_count > 2 ? 1 : 0
  depends_on = [module.powervs_instance_node_2, time_sleep.wait_60_sec_2]

  pi_instance_name           = "${var.pi_prefix}-pvs-3"
  pi_workspace_guid          = var.pi_workspace_guid
  pi_ssh_public_key_name     = var.pi_ssh_public_key_name
  pi_image_id                = var.pi_image_id
  pi_networks                = var.pi_networks # Need to check
  pi_server_type             = var.pi_server_type
  pi_cpu_proc_type           = var.pi_cpu_proc_type
  pi_number_of_processors    = var.pi_number_of_processors
  pi_memory_size             = var.pi_memory_size
  pi_placement_group_id      = ibm_pi_placement_group.placement_group.placement_group_id
  pi_boot_image_storage_tier = var.pi_storage_type
  pi_boot_image_storage_pool = local.highest_capacity_pool_name
  pi_storage_config          = local.powervs_dedicated_filesystem_config
  pi_existing_volume_ids     = local.shareable_volume_ids

}

resource "time_sleep" "wait_60_sec_3" {
  depends_on      = [module.powervs_instance_node_3]
  count      = var.pi_instance_count > 3 ? 1 : 0
  create_duration = "60s"
}


module "powervs_instance_node_4" {
  source     = "terraform-ibm-modules/powervs-instance/ibm"
  version    = "1.1.0"
  count      = var.pi_instance_count > 3 ? 1 : 0
  depends_on = [module.powervs_instance_node_3, time_sleep.wait_60_sec_3]

  pi_instance_name           = "${var.pi_prefix}-pvs-4"
  pi_workspace_guid          = var.pi_workspace_guid
  pi_ssh_public_key_name     = var.pi_ssh_public_key_name
  pi_image_id                = var.pi_image_id
  pi_networks                = var.pi_networks # Need to check
  pi_server_type             = var.pi_server_type
  pi_cpu_proc_type           = var.pi_cpu_proc_type
  pi_number_of_processors    = var.pi_number_of_processors
  pi_memory_size             = var.pi_memory_size
  pi_placement_group_id      = ibm_pi_placement_group.placement_group.placement_group_id
  pi_boot_image_storage_tier = var.pi_storage_type
  pi_boot_image_storage_pool = local.highest_capacity_pool_name
  pi_storage_config          = local.powervs_dedicated_filesystem_config
  pi_existing_volume_ids     = local.shareable_volume_ids
}

resource "time_sleep" "wait_60_sec_4" {
  depends_on      = [module.powervs_instance_node_4]
  count      = var.pi_instance_count > 4 ? 1 : 0
  create_duration = "60s"
}


module "powervs_instance_node_5" {
  source     = "terraform-ibm-modules/powervs-instance/ibm"
  version    = "1.1.0"
  count      = var.pi_instance_count > 4 ? 1 : 0
  depends_on = [module.powervs_instance_node_4, time_sleep.wait_60_sec_4]

  pi_instance_name           = "${var.pi_prefix}-pvs-5"
  pi_workspace_guid          = var.pi_workspace_guid
  pi_ssh_public_key_name     = var.pi_ssh_public_key_name
  pi_image_id                = var.pi_image_id
  pi_networks                = var.pi_networks # Need to check
  pi_server_type             = var.pi_server_type
  pi_cpu_proc_type           = var.pi_cpu_proc_type
  pi_number_of_processors    = var.pi_number_of_processors
  pi_memory_size             = var.pi_memory_size
  pi_placement_group_id      = ibm_pi_placement_group.placement_group.placement_group_id
  pi_boot_image_storage_tier = var.pi_storage_type
  pi_boot_image_storage_pool = local.highest_capacity_pool_name
  pi_storage_config          = local.powervs_dedicated_filesystem_config
  pi_existing_volume_ids     = local.shareable_volume_ids
}

resource "time_sleep" "wait_60_sec_5" {
  depends_on      = [module.powervs_instance_node_5]
  count      = var.pi_instance_count > 5 ? 1 : 0
  create_duration = "60s"
}


module "powervs_instance_node_6" {
  source     = "terraform-ibm-modules/powervs-instance/ibm"
  version    = "1.1.0"
  count      = var.pi_instance_count > 5 ? 1 : 0
  depends_on = [module.powervs_instance_node_5, time_sleep.wait_60_sec_5]

  pi_instance_name           = "${var.pi_prefix}-pvs-6"
  pi_workspace_guid          = var.pi_workspace_guid
  pi_ssh_public_key_name     = var.pi_ssh_public_key_name
  pi_image_id                = var.pi_image_id
  pi_networks                = var.pi_networks # Need to check
  pi_server_type             = var.pi_server_type
  pi_cpu_proc_type           = var.pi_cpu_proc_type
  pi_number_of_processors    = var.pi_number_of_processors
  pi_memory_size             = var.pi_memory_size
  pi_placement_group_id      = ibm_pi_placement_group.placement_group.placement_group_id
  pi_boot_image_storage_tier = var.pi_storage_type
  pi_boot_image_storage_pool = local.highest_capacity_pool_name
  pi_storage_config          = local.powervs_dedicated_filesystem_config
  pi_existing_volume_ids     = local.shareable_volume_ids
}

resource "time_sleep" "wait_60_sec_6" {
  depends_on      = [module.powervs_instance_node_6]
  count      = var.pi_instance_count > 6 ? 1 : 0
  create_duration = "60s"
}


module "powervs_instance_node_7" {
  source  = "terraform-ibm-modules/powervs-instance/ibm"
  version = "1.1.0"

  count      = var.pi_instance_count > 6 ? 1 : 0
  depends_on = [module.powervs_instance_node_6, time_sleep.wait_60_sec_6]

  pi_instance_name           = "${var.pi_prefix}-pvs-7"
  pi_workspace_guid          = var.pi_workspace_guid
  pi_ssh_public_key_name     = var.pi_ssh_public_key_name
  pi_image_id                = var.pi_image_id
  pi_networks                = var.pi_networks # Need to check
  pi_server_type             = var.pi_server_type
  pi_cpu_proc_type           = var.pi_cpu_proc_type
  pi_number_of_processors    = var.pi_number_of_processors
  pi_memory_size             = var.pi_memory_size
  pi_placement_group_id      = ibm_pi_placement_group.placement_group.placement_group_id
  pi_boot_image_storage_tier = var.pi_storage_type
  pi_boot_image_storage_pool = local.highest_capacity_pool_name
  pi_storage_config          = local.powervs_dedicated_filesystem_config
  pi_existing_volume_ids     = local.shareable_volume_ids
}

resource "time_sleep" "wait_60_sec_7" {
  depends_on      = [module.powervs_instance_node_7]
  count      = var.pi_instance_count > 7 ? 1 : 0
  create_duration = "60s"
}


module "powervs_instance_node_8" {
  source     = "terraform-ibm-modules/powervs-instance/ibm"
  version    = "1.1.0"
  count      = var.pi_instance_count > 7 ? 1 : 0
  depends_on = [module.powervs_instance_node_7, time_sleep.wait_60_sec_7]

  pi_instance_name           = "${var.pi_prefix}-pvs-8"
  pi_workspace_guid          = var.pi_workspace_guid
  pi_ssh_public_key_name     = var.pi_ssh_public_key_name
  pi_image_id                = var.pi_image_id
  pi_networks                = var.pi_networks # Need to check
  pi_server_type             = var.pi_server_type
  pi_cpu_proc_type           = var.pi_cpu_proc_type
  pi_number_of_processors    = var.pi_number_of_processors
  pi_memory_size             = var.pi_memory_size
  pi_placement_group_id      = ibm_pi_placement_group.placement_group.placement_group_id
  pi_boot_image_storage_tier = var.pi_storage_type
  pi_boot_image_storage_pool = local.highest_capacity_pool_name
  pi_storage_config          = local.powervs_dedicated_filesystem_config
  pi_existing_volume_ids     = local.shareable_volume_ids
}

resource "time_sleep" "wait_60_sec_8" {
  depends_on      = [module.powervs_instance_node_8]
  create_duration = "60s"
}

# resource "ibm_pi_volume" "shared_volumes" {
#   count                = var.pi_shared_volume_count > 0 ? var.pi_shared_volume_count : 0
#   pi_volume_size       = local.shared_volume_size
#   pi_volume_name       = "${var.pi_prefix}-shared-${count.index}"
#   pi_volume_type       = var.pi_storage_type
#   pi_volume_shareable  = true
#   pi_cloud_instance_id = var.pi_workspace_guid
# }

resource "ibm_pi_network_port_attach" "port_attach" {
  depends_on = [module.powervs_instance_node_8, time_sleep.wait_60_sec_8]
  count      = length(local.reserve_ips) > 0 ? length(local.reserve_ips) : 0

  pi_cloud_instance_id      = var.pi_workspace_guid
  pi_instance_id            = local.reserve_ips[count.index].pvm_instance_id
  pi_network_name           = local.reserve_ips[count.index].name
  pi_network_port_ipaddress = local.reserve_ips[count.index].ip
}
