########################################################################
# PowerHA Standard Edition outputs
########################################################################

output "site2_powervs_zone" {
  description = "Zone where PowerVS infrastructure is created."
  value       = var.site2_powervs_zone
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

output "site1_powervs_workspace_name" {
  description = "PowerVS infrastructure workspace name."
  value       = local.site1_powervs_workspace_name
}

output "site2_powervs_workspace_name" {
  description = "PowerVS infrastructure workspace name."
  value       = module.site2_powervs_workspace_create.powervs_workspace_name
}

output "site1_powervs_workspace_id" {
  description = "PowerVS infrastructure workspace id. The unique identifier of the new resource instance."
  value       = local.site1_powervs_workspace_id
}

output "site2_powervs_workspace_id" {
  description = "PowerVS infrastructure workspace id. The unique identifier of the new resource instance."
  value       = module.site2_powervs_workspace_create.powervs_workspace_id
}

output "site1_powervs_workspace_guid" {
  description = "PowerVS infrastructure workspace guid. The GUID of the resource instance."
  value       = local.site1_powervs_workspace_guid
}

output "site2_powervs_workspace_guid" {
  description = "PowerVS infrastructure workspace guid. The GUID of the resource instance."
  value       = module.site2_powervs_workspace_create.powervs_workspace_guid
}

output "site1_powervs_ssh_public_key" {
  description = "SSH public key name."
  value       = local.site1_powervs_sshkey_name
}

output "site2_powervs_ssh_public_key" {
  description = "SSH public key name."
  value       = module.site2_powervs_workspace_create.powervs_ssh_public_key
}

output "site1_powervs_subnet_list" {
  description = "Network ID and name of private networks in PowerVS Workspace."
  value       = module.site1_powervs_workspace_update.powervs_subnet_list
}

output "site2_powervs_subnet_list" {
  description = "Network ID and name of private networks in PowerVS Workspace."
  value       = module.site2_powervs_workspace_update.powervs_subnet_list
}

output "site1_subnet_reserve_ips" {
  description = "Reserve IP address of the network interface of IBM PowerVS instance."
  value       = module.powervs_instance.port_data[*]
}

output "site2_subnet_reserve_ips" {
  description = "Reserve IP address of the network interface of IBM PowerVS instance."
  value       = module.powervs_instance.port_data[*]
}

output "powervs_images" {
  description = "Object containing imported PowerVS image name and image id."
  value       = module.site1_powervs_workspace_update.powervs_images
}

output "site1_cloud_connection" {
  description = "Number of cloud connections configured in created PowerVS infrastructure."
  value       = module.site1_cloud_connection_network_attach
}

output "site2_cloud_connection" {
  description = "Number of cloud connections configured in created PowerVS infrastructure."
  value       = module.site2_cloud_connection_network_attach
}

output "site1_powervs_instances" {
  description = "IBM PowerVS instance Data."
  value       = module.site1_powervs_instance.instance
}

output "site2_powervs_instances" {
  description = "IBM PowerVS instance Data."
  value       = module.site2_powervs_instance.instance
}

output "site1_pha_shared_volume_data" {
  description = "PowerHA shared volumes data for volume groups."
  value       = module.site1_powervs_instance.pha_shared_volume_data
}

output "site2_pha_shared_volume_data" {
  description = "PowerHA shared volumes data for volume groups."
  value       = module.site2_powervs_instance.pha_shared_volume_data
}
