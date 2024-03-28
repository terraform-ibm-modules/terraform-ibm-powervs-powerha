#####################################################
# PowerVS Instance module
#####################################################

locals {
  ibm_powervs_quickstart_tshirt_sizes = {
    "aix_xs" = { "server_type" = "s922", "proc_type" = "shared", "cores" = "0.25", "memory" = "4", "tier" = "tier1" }
    "aix_s"  = { "server_type" = "s922", "proc_type" = "shared", "cores" = "1", "memory" = "16", "tier" = "tier1" }
    "aix_m"  = { "server_type" = "s922", "proc_type" = "shared", "cores" = "4", "memory" = "64", "tier" = "tier1" }
    "aix_l"  = { "server_type" = "s922", "proc_type" = "shared", "cores" = "8", "memory" = "128", "tier" = "tier1" }
    "aix_xl" = { "server_type" = "s922", "proc_type" = "shared", "cores" = "16", "memory" = "256", "tier" = "tier1" }
  }

  qs_tshirt_choice              = lookup(local.ibm_powervs_quickstart_tshirt_sizes, var.tshirt_size, null)
  valid_boot_image_provided_msg = "'custom_profile' is enabled, but variable 'custom_profile_instance_boot_image' is set to none."


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
  # cloud_connection_count = local.powervs_infrastructure[0].cloud_connection_count.value

  # For now we are not using this
  # dns_host_or_ip         = local.powervs_infrastructure[0].dns_host_or_ip.value
  # ntp_host_or_ip         = local.powervs_infrastructure[0].ntp_host_or_ip.value
  # nfs_host_or_ip_path    = local.powervs_infrastructure[0].nfs_host_or_ip_path.value


  ##################################
  # PowerVS Instance Locals
  ##################################

  pi_instance = {
    pi_image_id                   = lookup(module.powervs-workspace.powervs_images, var.powervs_image_names, null)
    pi_networks                   = module.powervs-workspace.powervs_subnet_list
    pi_server_type                = local.qs_tshirt_choice.server_type
    pi_number_of_processors       = local.qs_tshirt_choice.cores
    pi_memory_size                = local.qs_tshirt_choice.memory
    pi_tier                       = local.qs_tshirt_choice.tier
    pi_cpu_proc_type              = local.qs_tshirt_choice.proc_type
    pi_power_virtual_server_count = var.power_virtual_server
  }

  node_details = [for item in module.powervs_instance.pi_instances : {
    pi_instance_name        = replace(lower(item.pi_instance_name), "_", "-")
    pi_instance_primary_ip  = item.pi_instance_primary_ip
    pi_instance_private_ips = item.pi_instance_private_ips[*]
  }]

  #####################################################
  # IBM Cloud PowerVS Configuration
  #####################################################

  pi_per_enabled_dc_list = ["dal10", "dal12", "wdc06", "wdc07", "mad02", "mad04", "eu-de-1", "eu-de-2", "sao01", "sao04"]
  pi_per_enabled         = contains(local.pi_per_enabled_dc_list, var.powervs_zone)
  cloud_connection_count = local.pi_per_enabled ? 0 : var.cloud_connection.count

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
