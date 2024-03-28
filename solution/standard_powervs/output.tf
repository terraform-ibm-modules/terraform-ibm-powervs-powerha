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

output "proxy_ip_and_port" {
  value = local.proxy_ip_and_port
}

output "bastion_host_ip" {
  value = local.bastion_host_ip
}

output "transit_gateway_connection" {
  value = local.transit_gateway_connection
}

output "powervs_workspace_name" {
  description = "PowerVS infrastructure workspace name."
  value       = module.powervs-workspace.powervs_workspace_name
}

output "powervs_workspace_id" {
  description = "PowerVS infrastructure workspace id. The unique identifier of the new resource instance."
  value       = module.powervs-workspace.powervs_workspace_id
}

output "powervs_workspace_guid" {
  description = "PowerVS infrastructure workspace guid. The GUID of the resource instance."
  value       = module.powervs-workspace.powervs_workspace_guid
}

output "powervs_ssh_public_key" {
  description = "SSH public key name and value in created PowerVS infrastructure."
  value       = module.powervs-workspace.powervs_ssh_public_key
}

output "powervs_subnet_list" {
  description = "Network_ID of private networks in created PowerVS Workspace."
  value       = module.powervs-workspace.powervs_subnet_list
}

output "powervs_subnet_ids" {
  description = "Private Subnet IDs"
  value       = module.powervs-workspace.powervs_subnet_ids
}

output "powervs_images" {
  description = "Object containing imported PowerVS image names and image ids."
  value       = module.powervs-workspace.powervs_images
}

output "cloud_connection" {
  description = "Number of cloud connections configured in created PowerVS infrastructure."
  value       = module.cloud-connection-network-attach
}

output "pi_instances" {
  description = "IP address of the primary network interface of IBM PowerVS instance."
  value       = module.powervs_instance.pi_instances
}

output "reserve_ips" {
  description = "IP address of the primary network interface of IBM PowerVS instance."
  value       = module.powervs_instance.reserve_ips
}

output "pi_port_data" {
  value = module.powervs_instance.pi_port_data[*]
}

output "pi_shared_volume_data" {
  value = module.powervs_instance.pi_shared_volume_data
}

output "node_details" {
  value = local.node_details
}
