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

  location                   = regex("^[a-z/-]+", var.prerequisite_workspace_id)
  powervs_infrastructure     = jsondecode(data.ibm_schematics_output.schematics_output.output_json)
  bastion_host_ip            = local.powervs_infrastructure[0].access_host_or_ip.value
  proxy_ip_and_port          = local.powervs_infrastructure[0].proxy_host_or_ip_port.value
  transit_gateway_identifier = local.powervs_infrastructure[0].transit_gateway_id.value
  transit_gateway_connection = {
    "enable"             = local.transit_gateway_identifier != "" ? true : false
    "transit_gateway_id" = local.transit_gateway_identifier
  }
  powervs_workspace_guid = local.powervs_infrastructure[0].powervs_workspace_guid.value
  powervs_workspace_id   = local.powervs_infrastructure[0].powervs_workspace_id.value
  powervs_workspace_name = local.powervs_infrastructure[0].powervs_workspace_name.value
  powervs_sshkey_name    = local.powervs_infrastructure[0].powervs_ssh_public_key.value.name

  # For now we are not using this
  # powervs_networks       = [local.powervs_infrastructure[0].powervs_management_subnet.value, local.powervs_infrastructure[0].powervs_backup_subnet.value]
  # dns_host_or_ip         = local.powervs_infrastructure[0].dns_host_or_ip.value
  # ntp_host_or_ip         = local.powervs_infrastructure[0].ntp_host_or_ip.value
  # nfs_host_or_ip_path    = local.powervs_infrastructure[0].nfs_host_or_ip_path.value

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
    aix_image_id         = module.powervs_workspace_update.powervs_images
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


#####################################################
# Fetching Schematic Workspace Data
#####################################################

data "ibm_schematics_workspace" "schematics_workspace" {
  workspace_id = var.prerequisite_workspace_id
  location     = local.location
}

data "ibm_schematics_output" "schematics_output" {
  workspace_id = var.prerequisite_workspace_id
  location     = local.location
  template_id  = data.ibm_schematics_workspace.schematics_workspace.runtime_data[0].id
}
