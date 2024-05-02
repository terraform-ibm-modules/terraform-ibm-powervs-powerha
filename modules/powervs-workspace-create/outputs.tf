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
  value       = module.powervs_workspace.pi_ssh_public_key.name
}

output "powervs_subnet_list" {
  description = "Network ID and name of private networks in PowerVS Workspace."
  value       = [for item in local.powervs_subnets : { name = item.pi_network_name, id = item.network_id }]
}

output "powervs_images" {
  description = "Object containing imported PowerVS image name and image id."
  value       = module.powervs_workspace.pi_images
}

output "cloud_connection_count" {
  description = "Number of cloud connections configured in created PowerVS infrastructure."
  value       = module.powervs_workspace.pi_cloud_connection_count
}
