########################################################################
# PowerHA Standard Edition outputs
########################################################################

output "powervs_zone" {
  description = "Zone where PowerVS infrastructure is created."
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
  description = "PowerVS infrastructure workspace id. The unique identifier of the new resource instance."
  value       = local.powervs_workspace_id
}

output "powervs_workspace_guid" {
  description = "PowerVS infrastructure workspace guid. The GUID of the resource instance."
  value       = local.powervs_workspace_guid
}

output "powervs_ssh_public_key" {
  description = "SSH public key name."
  value       = local.powervs_sshkey_name
}

output "powervs_subnet_list" {
  description = "Network ID and name of private networks in PowerVS Workspace."
  value       = module.powervs_workspace_update.powervs_subnet_list
}

output "subnet_reserve_ips" {
  description = "Reserve IP address of the network interface of IBM PowerVS instance."
  value       = module.powervs_instance.port_data[*]
}

output "powervs_images" {
  description = "Object containing imported PowerVS image name and image id."
  value       = module.powervs_workspace_update.powervs_images
}

output "cloud_connection" {
  description = "Number of cloud connections configured in created PowerVS infrastructure."
  value       = module.cloud_connection_network_attach
}

output "powervs_instances" {
  description = "IBM PowerVS instance Data."
  value       = module.powervs_instance.instances
}

output "pha_shared_volume_data" {
  description = "PowerHA shared volumes data for volume groups."
  value       = module.powervs_instance.pha_shared_volume_data
}
