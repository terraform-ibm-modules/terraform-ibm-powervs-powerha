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
    timeout     = "20m"
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
      "python3 download_files.py 'pha_standard' ${var.cos_powerha_image_download.bucket_name} ${var.cos_powerha_image_download.folder_name} ${var.cos_powerha_image_download.cos_endpoint} ${var.cos_powerha_image_download.cos_access_key_id} ${var.cos_powerha_image_download.cos_secret_access_key}"
    ]
  }
}


#######################################################
# PowerVS Workspace Network Creation and Import Image
#######################################################

module "powervs_workspace_update" {
  depends_on = [terraform_data.validate_pha]
  source     = "../../modules/powervs-workspace-update"
  providers  = { ibm = ibm }

  powervs_workspace_guid = local.powervs_workspace_guid
  powervs_subnet_list    = local.subnet_list
  aix_os_image           = local.is_import == {} ? var.aix_os_image : null
}


#####################################################
# PowerVS Instance Creation
#####################################################

module "powervs_instance" {
  depends_on = [module.powervs_workspace_update]
  source     = "../../modules/powervs-instance-custom"
  providers  = { ibm = ibm }

  powervs_workspace_guid = local.powervs_workspace_guid
  ssh_public_key_name    = local.powervs_sshkey_name

  pi_prefix                      = "${var.prefix}-pvs"
  pi_image_id                    = local.pi_instance.aix_image_id
  pi_networks                    = local.pi_instance.powervs_networks
  pi_number_of_processors        = local.pi_instance.number_of_processors
  pi_memory_size                 = local.pi_instance.memory_size
  pi_cpu_proc_type               = local.pi_instance.cpu_proc_type
  pi_storage_type                = local.pi_instance.tier
  pi_server_type                 = var.powervs_machine_type
  pi_instance_count              = var.powervs_instance_count
  powervs_reserve_subnet_list    = var.powervs_reserve_subnet_list
  powervs_persistent_subnet_list = null
  dedicated_volume_count         = var.dedicated_volume
  shared_volume_count            = var.shared_volume
  dedicated_volume_attributes    = var.dedicated_volume_attributes
  shared_volume_attributes       = var.shared_volume_attributes
  pha_shared_volume              = local.pha_vg_shared_disks
}


#####################################################
# PowerVS Instance Ansible Configuration
#####################################################

module "powervs_instance_ansible_config" {
  depends_on = [module.powervs_workspace_update, module.powervs_instance, local.node_details]
  source     = "../../modules/powervs-instance-ansible-config"

  ssh_private_key              = var.ssh_private_key
  bastion_host_ip              = local.bastion_host_ip
  proxy_ip_and_port            = local.proxy_ip_and_port
  node_details                 = local.node_details
  subnet_list                  = var.powervs_subnet_list
  reserved_subnet_list         = var.powervs_reserve_subnet_list
  reserve_ip_data              = module.powervs_instance.reserve_ips
  pha_cos_data                 = var.cos_powerha_image_download
  repository_disk_wwn          = module.powervs_instance.shared_volume_data[0].wwn
  shared_disk_wwns             = module.powervs_instance.pha_shared_volume_data[*].wwn
  powerha_resource_group_count = var.powerha_resource_group
  powerha_resource_group_list  = var.powerha_resource_group_list
  volume_group_count           = var.volume_group
  volume_group_list            = var.volume_group_list
  file_system_count            = var.file_system
  file_system_list             = var.file_system_list
}
