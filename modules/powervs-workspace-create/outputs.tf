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
  value       = module.powervs_workspace.pi_workspace_name
}

output "powervs_workspace_id" {
  description = "PowerVS infrastructure workspace id."
  value       = module.powervs_workspace.pi_workspace_id
}

output "powervs_workspace_guid" {
  description = "PowerVS infrastructure workspace guid."
  value       = module.powervs_workspace.pi_workspace_guid
}

output "powervs_ssh_public_key" {
  description = "SSH public key name."
  value       = module.powervs_workspace.pi_ssh_public_key.name
}

output "powervs_subnet_list" {
  description = "PowerVS Workspace Network ID and name."
  value       = [for item in local.powervs_subnets : { name = item.pi_network_name, id = item.network_id }]
}

output "powervs_images" {
  description = "Imported PowerVS image name and image id."
  value       = module.powervs_workspace.pi_images
}
