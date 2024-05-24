output "instances" {
  description = "IBM PowerVS instance Data."
  value       = local.powervs_instances[*]
}

output "reserve_ips" {
  description = "Reserve the IP address of the network interface of the IBM PowerVS instance."
  value       = local.reserve_ips
}

output "port_data" {
  description = "IBM PowerVS instance Port Data."
  value       = ibm_pi_network_port_attach.port_attach[*]
}

output "shared_volume_data" {
  description = "IBM PowerVS instance shared volume data."
  value       = ibm_pi_volume.shared_volumes[*]
}

output "pha_shared_volume_data" {
  description = "PowerHA shared volume data for volume groups."
  value       = ibm_pi_volume.pha_shared_volumes[*]
}
