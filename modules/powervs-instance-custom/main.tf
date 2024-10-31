#####################################################
# Create Placement group different server
#####################################################

resource "ibm_pi_placement_group" "placement_group" {
  pi_placement_group_name   = "${var.pi_prefix}-pg"
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
  highest_capacity_pool_name = data.ibm_pi_storage_pools_capacity.pools.max_storage_allocation.storage_pool
}


#####################################################
# Create shareable volumes
#####################################################

resource "ibm_pi_volume" "shared_volumes" {
  count = var.shared_volume_count > 0 ? var.shared_volume_count : 0

  pi_volume_shareable  = true
  pi_volume_name       = "${var.pi_prefix}-shared-${count.index}"
  pi_volume_size       = var.shared_volume_attributes.size
  pi_volume_type       = var.shared_volume_attributes.tier
  pi_volume_pool       = local.highest_capacity_pool_name
  pi_cloud_instance_id = var.powervs_workspace_guid

  timeouts {
    create = "15m"
  }
}

resource "ibm_pi_volume" "pha_shared_volumes" {
  count = length(var.pha_shared_volume) > 0 ? length(var.pha_shared_volume) : 0

  pi_volume_shareable  = true
  pi_volume_name       = "${var.pi_prefix}-pha-shared-${count.index}"
  pi_volume_size       = var.pha_shared_volume[count.index].size
  pi_volume_type       = var.pha_shared_volume[count.index].tier
  pi_volume_pool       = local.highest_capacity_pool_name
  pi_cloud_instance_id = var.powervs_workspace_guid

  timeouts {
    create = "15m"
  }
}


locals {
  shareable_pi_volume_ids  = [for vol in ibm_pi_volume.shared_volumes : vol.volume_id]
  shareable_pha_volume_ids = [for vol in ibm_pi_volume.pha_shared_volumes : vol.volume_id]
  shareable_volume_ids     = concat(local.shareable_pi_volume_ids, local.shareable_pha_volume_ids)
  powervs_dedicated_filesystem_config = [
    for storage in local.default_pi_storage_config :
    merge(storage, { pool = local.highest_capacity_pool_name })
  ]
}


#####################################################
# Create up to 8 Cluster nodes
#####################################################

module "powervs_instance_node_1" {
  source     = "terraform-ibm-modules/powervs-instance/ibm"
  version    = "2.0.2"
  depends_on = [ibm_pi_placement_group.placement_group, ibm_pi_volume.shared_volumes]

  pi_instance_name           = "${var.pi_prefix}-1"
  pi_workspace_guid          = var.powervs_workspace_guid
  pi_ssh_public_key_name     = var.ssh_public_key_name
  pi_image_id                = var.pi_image_id
  pi_networks                = var.pi_networks
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
  version    = "2.0.2"
  count      = var.pi_instance_count > 1 ? 1 : 0
  depends_on = [module.powervs_instance_node_1, time_sleep.wait_60_sec_1]

  pi_instance_name           = "${var.pi_prefix}-2"
  pi_workspace_guid          = var.powervs_workspace_guid
  pi_ssh_public_key_name     = var.ssh_public_key_name
  pi_image_id                = var.pi_image_id
  pi_networks                = var.pi_networks
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
  count           = var.pi_instance_count > 1 ? 1 : 0
  create_duration = "60s"
}


module "powervs_instance_node_3" {
  source     = "terraform-ibm-modules/powervs-instance/ibm"
  version    = "2.0.2"
  count      = var.pi_instance_count > 2 ? 1 : 0
  depends_on = [module.powervs_instance_node_2, time_sleep.wait_60_sec_2]

  pi_instance_name           = "${var.pi_prefix}-3"
  pi_workspace_guid          = var.powervs_workspace_guid
  pi_ssh_public_key_name     = var.ssh_public_key_name
  pi_image_id                = var.pi_image_id
  pi_networks                = var.pi_networks
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
  count           = var.pi_instance_count > 2 ? 1 : 0
  create_duration = "60s"
}


module "powervs_instance_node_4" {
  source     = "terraform-ibm-modules/powervs-instance/ibm"
  version    = "2.0.2"
  count      = var.pi_instance_count > 3 ? 1 : 0
  depends_on = [module.powervs_instance_node_3, time_sleep.wait_60_sec_3]

  pi_instance_name           = "${var.pi_prefix}-4"
  pi_workspace_guid          = var.powervs_workspace_guid
  pi_ssh_public_key_name     = var.ssh_public_key_name
  pi_image_id                = var.pi_image_id
  pi_networks                = var.pi_networks
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
  count           = var.pi_instance_count > 3 ? 1 : 0
  create_duration = "60s"
}


module "powervs_instance_node_5" {
  source     = "terraform-ibm-modules/powervs-instance/ibm"
  version    = "2.0.2"
  count      = var.pi_instance_count > 4 ? 1 : 0
  depends_on = [module.powervs_instance_node_4, time_sleep.wait_60_sec_4]

  pi_instance_name           = "${var.pi_prefix}-5"
  pi_workspace_guid          = var.powervs_workspace_guid
  pi_ssh_public_key_name     = var.ssh_public_key_name
  pi_image_id                = var.pi_image_id
  pi_networks                = var.pi_networks
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
  count           = var.pi_instance_count > 4 ? 1 : 0
  create_duration = "60s"
}


module "powervs_instance_node_6" {
  source     = "terraform-ibm-modules/powervs-instance/ibm"
  version    = "2.0.2"
  count      = var.pi_instance_count > 5 ? 1 : 0
  depends_on = [module.powervs_instance_node_5, time_sleep.wait_60_sec_5]

  pi_instance_name           = "${var.pi_prefix}-6"
  pi_workspace_guid          = var.powervs_workspace_guid
  pi_ssh_public_key_name     = var.ssh_public_key_name
  pi_image_id                = var.pi_image_id
  pi_networks                = var.pi_networks
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
  count           = var.pi_instance_count > 5 ? 1 : 0
  create_duration = "60s"
}


module "powervs_instance_node_7" {
  source     = "terraform-ibm-modules/powervs-instance/ibm"
  version    = "2.0.2"
  count      = var.pi_instance_count > 6 ? 1 : 0
  depends_on = [module.powervs_instance_node_6, time_sleep.wait_60_sec_6]

  pi_instance_name           = "${var.pi_prefix}-7"
  pi_workspace_guid          = var.powervs_workspace_guid
  pi_ssh_public_key_name     = var.ssh_public_key_name
  pi_image_id                = var.pi_image_id
  pi_networks                = var.pi_networks
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
  count           = var.pi_instance_count > 6 ? 1 : 0
  create_duration = "60s"
}


module "powervs_instance_node_8" {
  source     = "terraform-ibm-modules/powervs-instance/ibm"
  version    = "2.0.2"
  count      = var.pi_instance_count > 7 ? 1 : 0
  depends_on = [module.powervs_instance_node_7, time_sleep.wait_60_sec_7]

  pi_instance_name           = "${var.pi_prefix}-8"
  pi_workspace_guid          = var.powervs_workspace_guid
  pi_ssh_public_key_name     = var.ssh_public_key_name
  pi_image_id                = var.pi_image_id
  pi_networks                = var.pi_networks
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
  count           = var.pi_instance_count > 7 ? 1 : 0
  create_duration = "60s"
}


resource "ibm_pi_network_port_attach" "port_attach_reserve" {
  depends_on = [module.powervs_instance_node_8, time_sleep.wait_60_sec_8]
  count      = length(local.reserve_ips) > 0 ? length(local.reserve_ips) : 0

  pi_cloud_instance_id      = var.powervs_workspace_guid
  pi_instance_id            = local.reserve_ips[count.index].pvm_instance_id
  pi_network_name           = local.reserve_ips[count.index].name
  pi_network_port_ipaddress = local.reserve_ips[count.index].ip
}

resource "time_sleep" "wait_60_sec_reserve_port" {
  depends_on      = [ibm_pi_network_port_attach.port_attach_reserve, time_sleep.wait_60_sec_8]
  count           = length(local.reserve_ips) > 0 ? length(local.reserve_ips) : 0
  create_duration = "60s"
}


resource "ibm_pi_network_port_attach" "port_attach_persistent" {
  depends_on = [ibm_pi_network_port_attach.port_attach_reserve, time_sleep.wait_60_sec_reserve_port]
  count      = length(local.persistent_ips) > 0 ? length(local.persistent_ips) : 0

  pi_cloud_instance_id      = var.powervs_workspace_guid
  pi_instance_id            = local.persistent_ips[count.index].pvm_instance_id
  pi_network_name           = local.persistent_ips[count.index].name
  pi_network_port_ipaddress = local.persistent_ips[count.index].ip
}
