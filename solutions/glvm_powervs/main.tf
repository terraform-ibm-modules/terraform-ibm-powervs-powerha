#######################################################
# Check PowerHA Filesets
#######################################################

resource "terraform_data" "validate_pha" {

  connection {
    type        = "ssh"
    user        = "root"
    host        = local.bastion_host_ip
    private_key = var.ssh_private_key
    agent       = false
    timeout     = "1m"
  }

  ####### Copy Template file to target host ############
  provisioner "file" {
    source      = "${path.module}/../../modules/common-assets/download_files.py"
    destination = "download_files.py"
  }

  provisioner "remote-exec" {
    inline = [
      "dnf install python3",
      "pip3 install boto3",
      "chmod +x download_files.py",
      "python3 download_files.py 'pha_glvm' ${var.cos_powerha_image_download.bucket_name} ${var.cos_powerha_image_download.folder_name} ${var.cos_powerha_image_download.cos_endpoint} ${var.cos_powerha_image_download.cos_access_key_id} ${var.cos_powerha_image_download.cos_secret_access_key}"
    ]
  }
}


#######################################################
# Site1 PowerVS Network Creation and Import Image
#######################################################

module "site1_powervs_workspace_update" {
  depends_on = [terraform_data.validate_pha]
  source     = "../../modules/powervs-workspace-update"
  providers  = { ibm = ibm }

  powervs_workspace_guid = local.site1_powervs_workspace_guid
  powervs_subnet_list    = local.site1_powervs_subnet_list
  aix_os_image           = local.is_import == {} ? var.aix_os_image : null
}


#######################################################
# Site2 PowerVS Workspace, Network Creation and Import Image
#######################################################

module "site2_powervs_workspace_create" {
  depends_on = [terraform_data.validate_pha]
  source     = "../../modules/powervs-workspace-create"
  providers  = { ibm = ibm.ibm-pi }

  prefix                      = var.prefix
  powervs_zone                = var.site2_powervs_zone
  ssh_public_key              = var.ssh_public_key
  powervs_resource_group_name = var.powervs_resource_group_name
  transit_gateway_connection  = local.transit_gateway_connection
  aix_os_image                = [var.aix_os_image]
  tags                        = var.tags
  powervs_subnet_list         = local.site2_powervs_subnet_list
}


#####################################################
# Site1 PowerVS Instance Creation
#####################################################

module "site1_powervs_instance" {
  depends_on = [module.site1_powervs_workspace_update]
  source     = "../../modules/powervs-instance-custom"
  providers  = { ibm = ibm }

  powervs_workspace_guid = local.site1_powervs_workspace_guid
  ssh_public_key_name    = local.site1_powervs_sshkey_name

  pi_prefix                      = "${var.prefix}-s1pvs"
  pi_image_id                    = local.site1_pi_instance.aix_image_id
  pi_networks                    = local.site1_pi_instance.powervs_networks
  pi_number_of_processors        = local.site1_pi_instance.number_of_processors
  pi_memory_size                 = local.site1_pi_instance.memory_size
  pi_cpu_proc_type               = local.site1_pi_instance.cpu_proc_type
  pi_storage_type                = local.site1_pi_instance.tier
  pi_server_type                 = var.powervs_machine_type
  pi_instance_count              = var.site1_powervs_instance_count
  powervs_reserve_subnet_list    = var.site1_reserve_subnet_list
  powervs_persistent_subnet_list = local.site1_persistent_subnets
  dedicated_volume_count         = var.dedicated_volume
  shared_volume_count            = var.shared_volume
  dedicated_volume_attributes    = var.dedicated_volume_attributes
  shared_volume_attributes       = var.shared_volume_attributes
  pha_shared_volume              = local.pha_vg_shared_disks
}


#####################################################
# Site2 PowerVS Instance Creation
#####################################################

module "site2_powervs_instance" {
  depends_on = [module.site2_powervs_workspace_create]
  source     = "../../modules/powervs-instance-custom"
  providers  = { ibm = ibm.ibm-pi }

  powervs_workspace_guid = module.site2_powervs_workspace_create.powervs_workspace_guid
  ssh_public_key_name    = module.site2_powervs_workspace_create.powervs_ssh_public_key

  pi_prefix                      = "${var.prefix}-s2pvs"
  pi_image_id                    = local.site2_pi_instance.aix_image_id
  pi_networks                    = local.site2_pi_instance.powervs_networks
  pi_number_of_processors        = local.site2_pi_instance.number_of_processors
  pi_memory_size                 = local.site2_pi_instance.memory_size
  pi_cpu_proc_type               = local.site2_pi_instance.cpu_proc_type
  pi_storage_type                = local.site2_pi_instance.tier
  pi_server_type                 = var.powervs_machine_type
  pi_instance_count              = var.site2_powervs_instance_count
  powervs_reserve_subnet_list    = var.site2_reserve_subnet_list
  powervs_persistent_subnet_list = local.site2_persistent_subnets
  dedicated_volume_count         = var.dedicated_volume
  shared_volume_count            = var.shared_volume
  dedicated_volume_attributes    = var.dedicated_volume_attributes
  shared_volume_attributes       = var.shared_volume_attributes
  pha_shared_volume              = local.pha_vg_shared_disks
}


######################################################
# PowerVS Instance Ansible Configuration
#######################################################

module "powervs_instance_glvm_ansible_config" {
  depends_on = [module.site1_powervs_instance, module.site2_powervs_instance, local.site1_node_details, local.site2_node_details]
  source     = "../../modules/powervs-instance-glvm-ansible-config"

  ssh_private_key                = var.ssh_private_key
  bastion_host_ip                = local.bastion_host_ip
  proxy_ip_and_port              = local.proxy_ip_and_port
  site1_node_details             = local.site1_node_details
  site2_node_details             = local.site2_node_details
  site1_subnet_list              = var.site1_subnet_list
  site2_subnet_list              = var.site2_subnet_list
  site1_reserve_ip_data          = module.site1_powervs_instance.reserve_ips
  site2_reserve_ip_data          = module.site2_powervs_instance.reserve_ips
  site1_persistent_ip_data       = module.site1_powervs_instance.persistent_ips
  site2_persistent_ip_data       = module.site2_powervs_instance.persistent_ips
  pha_cos_data                   = var.cos_powerha_image_download
  site1_repository_disk_wwn      = module.site1_powervs_instance.shared_volume_data[0].wwn
  site2_repository_disk_wwn      = module.site2_powervs_instance.shared_volume_data[0].wwn
  site1_shared_disk_wwns         = module.site1_powervs_instance.pha_shared_volume_data[*].wwn
  site2_shared_disk_wwns         = module.site2_powervs_instance.pha_shared_volume_data[*].wwn
  powerha_glvm_volume_group      = var.powerha_glvm_volume_group
  powerha_glvm_volume_group_list = var.powerha_glvm_volume_group_list
}
