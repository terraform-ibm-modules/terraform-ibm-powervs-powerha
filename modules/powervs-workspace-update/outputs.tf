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
  value       = local.pi_images
}
