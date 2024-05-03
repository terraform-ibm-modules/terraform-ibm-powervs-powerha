
########################################################################
# Landing Zone VPC outputs
########################################################################

output "vpc_names" {
  description = "A list of the names of the VPC."
  value       = module.fullstack.vpc_names
}

output "vsi_names" {
  description = "A list of the vsis names provisioned within the VPCs."
  value       = module.fullstack.vsi_names
}

output "ssh_public_key" {
  description = "The string value of the ssh public key used when deploying VPC"
  value       = var.ssh_public_key
}

output "transit_gateway_name" {
  description = "The name of the transit gateway."
  value       = module.fullstack.transit_gateway_name
}

output "transit_gateway_id" {
  description = "The ID of transit gateway."
  value       = module.fullstack.transit_gateway_id
}

output "vsi_list" {
  description = "A list of VSI with name, id, zone, and primary ipv4 address, VPC Name, and floating IP."
  value       = module.fullstack.vsi_list
}

output "dns_host_or_ip" {
  description = "DNS forwarder host for created PowerVS infrastructure."
  value       = module.fullstack.dns_host_or_ip
}

output "ntp_host_or_ip" {
  description = "NTP host for created PowerVS infrastructure."
  value       = module.fullstack.ntp_host_or_ip
}

output "nfs_host_or_ip_path" {
  description = "NFS host for created PowerVS infrastructure."
  value       = module.fullstack.nfs_host_or_ip_path
}

########################################################################
# PowerHA Standard Edition outputs
########################################################################
output "proxy_ip_and_port" {
  description = "IBM VPC Proxy server IP and port details."
  value       = local.proxy_ip_and_port
}

output "bastion_host_ip" {
  description = "IBM VPC VSI host IP address."
  value       = local.bastion_host_ip
}

output "powervs_zone" {
  description = "Zone where PowerVS infrastructure is created."
  value       = var.powervs_zone
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
