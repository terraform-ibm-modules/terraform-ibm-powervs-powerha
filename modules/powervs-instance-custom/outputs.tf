output "pi_instances" {
  description = "IP address of the primary network interface of IBM PowerVS instance."
  value       = local.powervs_instances[*]
}

output "reserve_ips" {
  description = "IP address of the primary network interface of IBM PowerVS instance."
  value       = local.reserve_ips
}

output "pi_port_data" {
  value = ibm_pi_network_port_attach.port_attach[*]
}

output "pi_shared_volume_data" {
  value = ibm_pi_volume.shared_volumes[*]
}
