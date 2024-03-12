# Outputs
output "highest_pool_capacity" {
  description = "Pool with highest storage capacity"
  value       = data.ibm_pi_storage_pools_capacity.pools.maximum_storage_allocation.storage_pool
}
