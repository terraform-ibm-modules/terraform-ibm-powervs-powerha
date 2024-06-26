#######################################################
# Power Virtual Server with VPC landing zone module
# VPC landing zone
# PowerVS Workspace
# Transit Gateway, CCs, PowerVS catalog images
#######################################################

module "fullstack" {
  source  = "terraform-ibm-modules/powervs-infrastructure/ibm//modules/powervs-vpc-landing-zone"
  version = "4.11.0"

  providers = { ibm.ibm-is = ibm.ibm-is, ibm.ibm-pi = ibm.ibm-pi }

  powervs_zone                = var.powervs_zone
  landing_zone_configuration  = var.landing_zone_configuration
  prefix                      = var.prefix
  external_access_ip          = var.external_access_ip
  ssh_public_key              = var.ssh_public_key
  ssh_private_key             = var.ssh_private_key
  powervs_resource_group_name = var.powervs_resource_group_name
  configure_dns_forwarder     = var.configure_dns_forwarder
  configure_ntp_forwarder     = var.configure_ntp_forwarder
  configure_nfs_server        = var.configure_nfs_server
  powervs_image_names         = []
}

resource "time_sleep" "wait_10_mins" {
  create_duration = "600s"
}

############################################################
# Test PowerVS Workspace Network Creation and Import Image
############################################################

module "powervs_workspace_update" {
  depends_on = [time_sleep.wait_10_mins]
  source     = "../../modules/powervs-workspace-update"
  providers  = { ibm = ibm.ibm-pi }

  powervs_workspace_guid = local.powervs_workspace_guid
  powervs_subnet_list    = local.subnet_list
  aix_os_image           = var.aix_os_image
}


#####################################################
# Test CC Subnet Attach module
# Non PER DC: Attaches Subnets to CCs
# PER DC: Skip
#####################################################

module "cloud_connection_network_attach" {
  depends_on = [module.powervs_workspace_update]
  source     = "../../modules/cloud-connection-network-attach"
  providers  = { ibm = ibm.ibm-pi }

  count = local.cloud_connection_count > 0 ? 1 : 0

  powervs_workspace_guid = local.powervs_workspace_guid
  private_subnet_ids     = module.powervs_workspace_update.powervs_subnet_list[*].id
  cloud_connection_count = local.cloud_connection_count
}


#####################################################
# Test PowerVS Instance Creation
#####################################################

module "powervs_instance" {
  depends_on = [module.cloud_connection_network_attach]
  source     = "../../modules/powervs-instance-custom"
  providers  = { ibm = ibm.ibm-pi }


  powervs_workspace_guid = local.powervs_workspace_guid
  ssh_public_key_name    = local.powervs_sshkey_name

  pi_prefix                   = var.prefix
  pi_image_id                 = module.powervs_workspace_update.powervs_images
  pi_networks                 = local.pi_instance.powervs_networks
  pi_number_of_processors     = local.pi_instance.number_of_processors
  pi_memory_size              = local.pi_instance.memory_size
  pi_cpu_proc_type            = local.pi_instance.cpu_proc_type
  pi_storage_type             = local.pi_instance.tier
  pi_server_type              = var.powervs_machine_type
  pi_instance_count           = var.powervs_instance_count
  powervs_reserve_subnet_list = var.powervs_reserve_subnet_list
  dedicated_volume_count      = var.dedicated_volume
  shared_volume_count         = var.shared_volume
  dedicated_volume_attributes = var.dedicated_volume_attributes
  shared_volume_attributes    = var.shared_volume_attributes
  pha_shared_volume           = local.pha_vg_shared_disks
}
