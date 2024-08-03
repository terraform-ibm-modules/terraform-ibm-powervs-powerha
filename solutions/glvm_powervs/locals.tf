locals {
  site1_tshirt_sizes = {
    "aix_xs" = { "proc_type" = "shared", "cores" = 0.25, "memory" = 4, "tier" = "tier1" }
    "aix_s"  = { "proc_type" = "shared", "cores" = 1, "memory" = 16, "tier" = "tier1" }
    "aix_m"  = { "proc_type" = "shared", "cores" = 4, "memory" = 64, "tier" = "tier1" }
    "aix_l"  = { "proc_type" = "shared", "cores" = 8, "memory" = 128, "tier" = "tier1" }
    "aix_xl" = { "proc_type" = "shared", "cores" = 16, "memory" = 256, "tier" = "tier1" }
    "custom" = { "proc_type" = var.site1_custom_profile.proc_type, "cores" = var.site1_custom_profile.cores, "memory" = var.site1_custom_profile.memory, "tier" = var.site1_custom_profile.tier }
  }
  site1_tshirt_choice = lookup(local.site1_tshirt_sizes, var.site1_tshirt_size, null)
  site2_tshirt_sizes = {
    "aix_xs" = { "proc_type" = "shared", "cores" = 0.25, "memory" = 4, "tier" = "tier1" }
    "aix_s"  = { "proc_type" = "shared", "cores" = 1, "memory" = 16, "tier" = "tier1" }
    "aix_m"  = { "proc_type" = "shared", "cores" = 4, "memory" = 64, "tier" = "tier1" }
    "aix_l"  = { "proc_type" = "shared", "cores" = 8, "memory" = 128, "tier" = "tier1" }
    "aix_xl" = { "proc_type" = "shared", "cores" = 16, "memory" = 256, "tier" = "tier1" }
    "custom" = { "proc_type" = var.site2_custom_profile.proc_type, "cores" = var.site2_custom_profile.cores, "memory" = var.site2_custom_profile.memory, "tier" = var.site2_custom_profile.tier }
  }
  site2_tshirt_choice = lookup(local.site2_tshirt_sizes, var.site2_tshirt_size, null)

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
  site1_powervs_workspace_guid = local.powervs_infrastructure[0].powervs_workspace_guid.value
  site1_powervs_workspace_id   = local.powervs_infrastructure[0].powervs_workspace_id.value
  site1_powervs_workspace_name = local.powervs_infrastructure[0].powervs_workspace_name.value
  site1_powervs_sshkey_name    = local.powervs_infrastructure[0].powervs_ssh_public_key.value.name
  is_import                    = { for image in data.ibm_pi_images.ds_images.image_info : image.name => image.id if image.name == var.aix_os_image }

  # For now we are not using this
  # powervs_networks       = [local.powervs_infrastructure[0].powervs_management_subnet.value, local.powervs_infrastructure[0].powervs_backup_subnet.value]
  # dns_host_or_ip         = local.powervs_infrastructure[0].dns_host_or_ip.value
  # ntp_host_or_ip         = local.powervs_infrastructure[0].ntp_host_or_ip.value
  # nfs_host_or_ip_path    = local.powervs_infrastructure[0].nfs_host_or_ip_path.value

  ##################################
  # PowerVS Networks Locals
  ##################################

  persistent_ip_count      = floor(length(var.site1_subnet_list) > length(var.site2_subnet_list) ? length(var.site1_subnet_list) / 2 : length(var.site2_subnet_list) / 2) > 1 ? 2 : 1
  site1_persistent_subnets = [for net in(length(var.site1_subnet_list) == 1 ? [] : length(var.site1_subnet_list) < 4 && length(var.site1_persistent_subnet_list) == 2 ? [var.site1_persistent_subnet_list[0]] : var.site1_persistent_subnet_list) : merge(net, { reserved_ip_count : length(var.site1_persistent_subnet_list) < 2 ? local.persistent_ip_count : 1 })]
  site2_persistent_subnets = [for net in(length(var.site2_subnet_list) == 1 ? [] : length(var.site2_subnet_list) < 4 && length(var.site2_persistent_subnet_list) == 2 ? [var.site2_persistent_subnet_list[0]] : var.site2_persistent_subnet_list) : merge(net, { reserved_ip_count : length(var.site2_persistent_subnet_list) < 2 ? local.persistent_ip_count : 1 })]

  site1_powervs_subnet_list = concat([for net in var.site1_subnet_list : merge(net, { reserved_ip_count : 0 })], concat(var.site1_reserve_subnet_list, length(var.site1_subnet_list) > 2 || length(local.site1_persistent_subnets) == 0 ? local.site1_persistent_subnets : [local.site1_persistent_subnets[0]]))
  site2_powervs_subnet_list = concat([for net in var.site2_subnet_list : merge(net, { reserved_ip_count : 0 })], concat(var.site2_reserve_subnet_list, length(var.site2_subnet_list) > 2 || length(local.site2_persistent_subnets) == 0 ? local.site2_persistent_subnets : [local.site2_persistent_subnets[0]]))

  ##################################
  # PowerHA Shared Volume Locals
  ##################################

  pha_vg_shared_disks = [for idx in range(var.powerha_glvm_volume_group) :
    idx < length(var.powerha_glvm_volume_group_list) ?
    { size = var.powerha_glvm_volume_group_list[idx].size, tier = var.powerha_glvm_volume_group_list[idx].tier } :
    { size = 30, tier = "tier3" }
  ]

  ##################################
  # PowerVS Instance Locals
  ##################################

  site1_pi_instance = {
    aix_image_id         = local.is_import == {} ? module.site1_powervs_workspace_update.powervs_images : local.is_import[var.aix_os_image]
    powervs_networks     = slice(module.site1_powervs_workspace_update.powervs_subnet_list, 0, length(var.site1_subnet_list))
    number_of_processors = local.site1_tshirt_choice.cores
    memory_size          = local.site1_tshirt_choice.memory
    tier                 = local.site1_tshirt_choice.tier
    cpu_proc_type        = local.site1_tshirt_choice.proc_type
  }

  site2_pi_instance = {
    aix_image_id         = lookup(module.site2_powervs_workspace_create.powervs_images, var.aix_os_image, null)
    powervs_networks     = slice(module.site2_powervs_workspace_create.powervs_subnet_list, 0, length(var.site2_subnet_list))
    number_of_processors = local.site2_tshirt_choice.cores
    memory_size          = local.site2_tshirt_choice.memory
    tier                 = local.site2_tshirt_choice.tier
    cpu_proc_type        = local.site2_tshirt_choice.proc_type
  }

  site1_node_details = [for item in module.site1_powervs_instance.instances : {
    pi_instance_name        = replace(lower(item.pi_instance_name), "_", "-")
    pi_instance_id          = item.pi_instance_instance_id
    pi_instance_primary_ip  = item.pi_instance_primary_ip
    pi_instance_private_ips = item.pi_instance_private_ips[*]
    pi_extend_volume        = item.pi_storage_configuration[0].wwns
  }]

  site2_node_details = [for item in module.site2_powervs_instance.instances : {
    pi_instance_name        = replace(lower(item.pi_instance_name), "_", "-")
    pi_instance_id          = item.pi_instance_instance_id
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

data "ibm_pi_images" "ds_images" {
  pi_cloud_instance_id = local.site1_powervs_workspace_guid
}
