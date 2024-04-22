variable "powervs_workspace_guid" {
  description = "Existing GUID of the PowerVS workspace. The GUID of the service instance associated with an account."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs."
  type        = list(string)
}

variable "cloud_connection_count" {
  description = "Existing cloud connection count."
  type        = number
}
