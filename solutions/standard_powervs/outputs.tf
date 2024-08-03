########################################################################
# PowerHA Standard Edition outputs
########################################################################

output "powervs_zone" {
  description = "Zone where PowerVS infrastructure was created."
  value       = var.powervs_zone
}

output "proxy_ip_and_port" {
  description = "IBM VPC Proxy server IP and port details."
  value       = local.proxy_ip_and_port
}

output "bastion_host_ip" {
  description = "IBM VPC VSI host IP address."
  value       = local.bastion_host_ip
}

output "transit_gateway_connection" {
  description = "Transit gateway details."
  value       = local.transit_gateway_connection
}

output "powervs_workspace_name" {
  description = "PowerVS infrastructure workspace name."
  value       = local.powervs_workspace_name
}

output "powervs_workspace_id" {
  description = "PowerVS infrastructure workspace id."
  value       = local.powervs_workspace_id
}

output "powervs_workspace_guid" {
  description = "PowerVS infrastructure workspace guid."
  value       = local.powervs_workspace_guid
}

output "powervs_ssh_public_key" {
  description = "SSH public key name."
  value       = local.powervs_sshkey_name
}

output "powervs_subnet_list" {
  description = "PowerVS Workspace Network ID and name."
  value       = module.powervs_workspace_update.powervs_subnet_list
}

output "subnet_reserve_ips" {
  description = "Reserve the IP address of the network interface of the IBM PowerVS instance."
  value       = module.powervs_instance.reserve_port_data[*]
}

output "powervs_images" {
  description = "Imported PowerVS image name and image ID."
  value       = module.powervs_workspace_update.powervs_images
}

output "powervs_instances" {
  description = "IBM PowerVS instance Data."
  value       = module.powervs_instance.instances
}

output "pha_shared_volume_data" {
  description = "PowerHA shared volume data for volume groups."
  value       = module.powervs_instance.pha_shared_volume_data
}
