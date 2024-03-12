output "powervs_zone" {
  description = "Zone where PowerVS cluster is deployed."
  value       = var.powervs_zone
}

output "powervs_workspace_guid" {
  description = "Existing GUID of the PowerVS workspace. The GUID of the service instance associated with an account."
  value       = local.powervs_workspace_guid
}

output "powervs_ssh_public_key" {
  description = "Existing SSH public key name in PowerVS infrastructure."
  value       = local.powervs_sshkey_name
}

output "powervs_node_1_primary_ip" {
  description = "IP address of the primary network interface of IBM PowerVS node 1."
  value       = module.powervs_instance_node_1.pi_instance_primary_ip
}

output "powervs_node_1_private_ips" {
  description = "All private IP addresses (as a list) of IBM PowerVS PowerVS node 1."
  value       = module.powervs_instance_node_1.pi_instance_private_ips
}
