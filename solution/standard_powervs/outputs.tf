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
  description = "IBM VPC Proxy server ip and port details."
  value       = local.proxy_ip_and_port
}

output "bastion_host_ip" {
  description = "IBM VPC VSI host ip address."
  value       = local.bastion_host_ip
}

output "transit_gateway_connection" {
  description = "Transit gateway details."
  value       = local.transit_gateway_connection
}

output "powervs_workspace_name" {
  description = "PowerVS infrastructure workspace name."
  value       = module.powervs_workspace.powervs_workspace_name
}

output "powervs_workspace_id" {
  description = "PowerVS infrastructure workspace id. The unique identifier of the new resource instance."
  value       = module.powervs_workspace.powervs_workspace_id
}

output "powervs_workspace_guid" {
  description = "PowerVS infrastructure workspace guid. The GUID of the resource instance."
  value       = module.powervs_workspace.powervs_workspace_guid
}

output "powervs_ssh_public_key" {
  description = "SSH public key name and value in created PowerVS infrastructure."
  value       = module.powervs_workspace.powervs_ssh_public_key
}

output "powervs_subnet_list" {
  description = "Network_ID of private networks in created PowerVS Workspace."
  value       = module.powervs_workspace.powervs_subnet_list
}

output "powervs_subnet_ids" {
  description = "Private Subnet IDs"
  value       = module.powervs_workspace.powervs_subnet_ids
}

output "powervs_images" {
  description = "Object containing imported PowerVS image names and image ids."
  value       = module.powervs_workspace.powervs_images
}

output "cloud_connection" {
  description = "Number of cloud connections configured in created PowerVS infrastructure."
  value       = module.cloud_connection_network_attach
}

output "pi_instances" {
  description = "IBM PowerVS instance Data."
  value       = module.powervs_instance.pi_instances
}

output "reserve_ips" {
  description = "Reserve IP address of the network interface of IBM PowerVS instance."
  value       = module.powervs_instance.reserve_ips
}

output "pi_port_data" {
  description = "IBM PowerVS instance Port Data."
  value       = module.powervs_instance.pi_port_data[*]
}

output "pi_shared_volume_data" {
  description = "IBM PowerVS instance shared volume data."
  value       = module.powervs_instance.pi_shared_volume_data
}

output "node_details" {
  description = "IBM PowerVS instance details."
  value       = local.node_details
}

output "pha_shared_volume_data" {
  description = "PowerHA shared volume data."
  value       = module.powervs_instance.pha_shared_volume_data
}
