#####################################################
# Workspace module ( Creates Workspace, SSH key,
# Subnets, Imports catalog images )
#####################################################

module "powervs_workspace" {
  source  = "terraform-ibm-modules/powervs-workspace/ibm"
  version = "1.7.2"

  pi_zone                       = var.powervs_zone
  pi_resource_group_name        = var.powervs_resource_group_name
  pi_workspace_name             = "${var.prefix}-${var.powervs_zone}-power-workspace"
  pi_ssh_public_key             = { "name" = "${var.prefix}-${var.powervs_zone}-pcs-ssh-key", value = var.ssh_public_key }
  pi_cloud_connection           = var.cloud_connection
  pi_private_subnet_1           = null
  pi_private_subnet_2           = null
  pi_private_subnet_3           = null
  pi_transit_gateway_connection = var.transit_gateway_connection
  pi_tags                       = var.tags
  pi_image_names                = var.powervs_image_names
}
