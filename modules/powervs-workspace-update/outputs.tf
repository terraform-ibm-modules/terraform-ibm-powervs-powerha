output "powervs_subnet_list" {
  description = "Network ID and name of private networks in PowerVS Workspace."
  value       = [for item in local.powervs_subnets : { name = item.pi_network_name, id = item.network_id }]
}

output "powervs_images" {
  description = "Object containing imported PowerVS image name and image id."
  value       = local.pi_images
}
