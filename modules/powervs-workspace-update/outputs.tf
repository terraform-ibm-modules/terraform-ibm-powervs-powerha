output "powervs_subnet_list" {
  description = "PowerVS Workspace subnet IDs and names."
  value       = [for item in local.powervs_subnets : { name = item.pi_network_name, id = item.network_id }]
}

output "powervs_images" {
  description = "Imported PowerVS image name and image ID."
  value       = local.pi_images
}
