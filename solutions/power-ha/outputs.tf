output "powervs_zone" {
  description = "Zone where PowerVS cluster is deployed."
  value       = var.powervs_zone
}

output "powervs_workspace_guid" {
  description = "Existing GUID of the PowerVS workspace. The GUID of the service instance associated with an account."
  value       = var.powervs_workspace_guid
}

output "powervs_ssh_public_key" {
  description = "Existing SSH public key name in PowerVS infrastructure."
  value       = var.powervs_sshkey_name
}

output "powervs_node_1_name" {
  description = "Name of PowerVS instance."
  value       = module.powervs_instance_node_1.pi_instance_name
}

output "powervs_node_1_instance_id" {
  description = "he unique identifier of the instance. The ID is composed of <power_instance_id>/<instance_id>."
  value       = module.powervs_instance_node_1.pi_instance_id
}

output "powervs_node_1_instance_instance_id" {
  description = "The unique identifier of PowerVS instance."
  value       = module.powervs_instance_node_1.pi_instance_instance_id
}

output "powervs_node_1_primary_ip" {
  description = "IP address of the primary network interface of IBM PowerVS node 1."
  value       = module.powervs_instance_node_1.pi_instance_primary_ip
}

output "powervs_node_1_private_ips" {
  description = "All private IP addresses (as a list) of IBM PowerVS PowerVS node 1."
  value       = module.powervs_instance_node_1.pi_instance_private_ips
}
