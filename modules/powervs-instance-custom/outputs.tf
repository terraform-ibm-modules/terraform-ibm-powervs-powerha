output "instances" {
  description = "IBM PowerVS instance Data."
  value       = local.powervs_instances[*]
}

output "reserve_ips" {
  description = "Reserve the IP address of the network interface of the IBM PowerVS instance."
  value       = local.reserve_ips
}

output "persistent_ips" {
  description = "Persistent IP address of the network interface of the IBM PowerVS instance."
  value       = local.persistent_ips
}

output "reserve_port_data" {
  description = "IBM PowerVS instance Reserve Port Data."
  value       = ibm_pi_network_port_attach.port_attach_reserve[*]
}

output "persistent_port_data" {
  description = "IBM PowerVS instance Persistent Port Data."
  value       = ibm_pi_network_port_attach.port_attach_persistent[*]
}

output "shared_volume_data" {
  description = "IBM PowerVS instance shared volume data."
  value       = ibm_pi_volume.shared_volumes[*]
}

output "pha_shared_volume_data" {
  description = "PowerHA shared volume data for volume groups."
  value       = ibm_pi_volume.pha_shared_volumes[*]
}
