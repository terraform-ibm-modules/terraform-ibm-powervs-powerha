output "cloud_connection_ds" {
  description = "Number of cloud connections configured in created PowerVS infrastructure."
  value       = data.ibm_pi_cloud_connections.cloud_connection_ds
}