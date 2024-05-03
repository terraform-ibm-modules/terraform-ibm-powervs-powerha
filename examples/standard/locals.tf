locals {
  ibm_powervs_tshirt_sizes = {
    "aix_xs" = { "proc_type" = "shared", "cores" = 0.25, "memory" = 4, "tier" = "tier1" }
    "aix_s"  = { "proc_type" = "shared", "cores" = 1, "memory" = 16, "tier" = "tier1" }
    "aix_m"  = { "proc_type" = "shared", "cores" = 4, "memory" = 64, "tier" = "tier1" }
    "aix_l"  = { "proc_type" = "shared", "cores" = 8, "memory" = 128, "tier" = "tier1" }
    "aix_xl" = { "proc_type" = "shared", "cores" = 16, "memory" = 256, "tier" = "tier1" }
    "custom" = { "proc_type" = var.custom_profile.proc_type, "cores" = var.custom_profile.cores, "memory" = var.custom_profile.memory, "tier" = var.custom_profile.tier }
  }
  tshirt_choice = lookup(local.ibm_powervs_tshirt_sizes, var.tshirt_size, null)

  #####################################################
  # Schematic Workspace Data Locals
  #####################################################
  bastion_host_ip        = module.fullstack.access_host_or_ip
  proxy_ip_and_port      = module.fullstack.proxy_host_or_ip_port
  powervs_workspace_guid = module.fullstack.powervs_workspace_guid
  powervs_workspace_id   = module.fullstack.powervs_workspace_id
  powervs_workspace_name = module.fullstack.powervs_workspace_name
  powervs_sshkey_name    = module.fullstack.powervs_ssh_public_key.name
  cloud_connection_count = module.fullstack.cloud_connection_count

  ##################################
  # PowerVS Networks Locals
  ##################################

  subnet_list = concat([for net in var.powervs_subnet_list : merge(net, { reserved_ip_count : 0 })], var.powervs_reserve_subnet_list)

  ##################################
  # PowerHA Shared Volume Locals
  ##################################

  pha_vg_shared_disks = [for idx in range(var.volume_group) :
    idx < length(var.volume_group_list) ?
    { size = var.volume_group_list[idx].size, tier = var.volume_group_list[idx].tier } :
    { size = 30, tier = "tier3" }
  ]

  ##################################
  # PowerVS Instance Locals
  ##################################

  pi_instance = {
    powervs_networks     = slice(module.powervs_workspace_update.powervs_subnet_list, 0, length(var.powervs_subnet_list))
    number_of_processors = local.tshirt_choice.cores
    memory_size          = local.tshirt_choice.memory
    tier                 = local.tshirt_choice.tier
    cpu_proc_type        = local.tshirt_choice.proc_type
  }

  node_details = [for item in module.powervs_instance.instances : {
    pi_instance_name        = replace(lower(item.pi_instance_name), "_", "-")
    pi_instance_primary_ip  = item.pi_instance_primary_ip
    pi_instance_private_ips = item.pi_instance_private_ips[*]
    pi_extend_volume        = item.pi_storage_configuration[0].wwns
  }]

}
