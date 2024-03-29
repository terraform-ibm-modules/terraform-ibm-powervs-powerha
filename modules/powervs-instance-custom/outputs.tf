output "pi_instances" {
  description = "IBM PowerVS instance Data."
  value       = local.powervs_instances[*]
}

output "reserve_ips" {
  description = "Reserve IP address of the network interface of IBM PowerVS instance."
  value       = local.reserve_ips
}

output "pi_port_data" {
  description = "IBM PowerVS instance Port Data."
  value       = ibm_pi_network_port_attach.port_attach[*]
}

output "pi_shared_volume_data" {
  description = "IBM PowerVS instance shared volume data."
  value       = ibm_pi_volume.shared_volumes[*]
}
