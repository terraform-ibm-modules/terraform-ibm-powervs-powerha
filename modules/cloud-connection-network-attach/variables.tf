variable "pi_workspace_guid" {
  description = "Existing GUID of the PowerVS workspace. The GUID of the service instance associated with an account."
  type        = string
}

variable "pi_private_subnet_ids" {
  description = "Private Subnet IDs."
  type        = list(string)
}

variable "cloud_connection_count" {
  description = "Existing Cloud Connection Count"
  type        = number
}
