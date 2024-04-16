########################################################################
# PowerVS Infrastructure outputs
########################################################################

output "powervs_zone" {
  description = "Zone where PowerVS infrastructure is created."
  value       = var.powervs_zone
}

output "powervs_resource_group_name" {
  description = "IBM Cloud resource group where PowerVS infrastructure is created."
  value       = var.powervs_resource_group_name
}

output "powervs_workspace_name" {
  description = "PowerVS infrastructure workspace name."
  value       = "${var.prefix}-${var.powervs_zone}-power-workspace"
}

output "powervs_workspace_id" {
  description = "PowerVS infrastructure workspace id. The unique identifier of the new resource instance."
  value       = module.powervs_workspace.pi_workspace_id
}

output "powervs_workspace_guid" {
  description = "PowerVS infrastructure workspace guid. The GUID of the resource instance."
  value       = module.powervs_workspace.pi_workspace_guid
}

output "powervs_ssh_public_key" {
  description = "SSH public key name and value in created PowerVS infrastructure."
  value       = { "name" = "${var.prefix}-${var.powervs_zone}-pcs-ssh-key", value = var.ssh_public_key }
}

output "powervs_subnet_list" {
  description = "list of powervs private subnet"
  value       = [for item in local.powervs_subnets : { name = item.pi_network_name, id = item.network_id }]
}

output "powervs_subnet_ids" {
  description = "Private Subnet IDs"
  value       = [for item in local.powervs_subnets : item.network_id]
}

output "powervs_images" {
  description = "Object containing imported PowerVS image names and image ids."
  value       = module.powervs_workspace.pi_images
}
