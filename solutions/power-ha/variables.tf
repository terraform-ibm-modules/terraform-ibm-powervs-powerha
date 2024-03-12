variable "ibmcloud_api_key" {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources."
  type        = string
  sensitive   = true
}

variable "powervs_zone" {
  description = "IBM Cloud PowerVS zone."
  type        = string
  validation {
    condition     = contains(["syd04", "syd05", "eu-de-1", "eu-de-2", "lon04", "lon06", "tok04", "us-east", "us-south", "dal10", "dal12", "tor01", "osa21", "sao01", "sao04", "mon01", "wdc04", "wdc06", "wdc07"], var.powervs_zone)
    error_message = "Only Following DC values are supported :  syd04, syd05, eu-de-1, eu-de-2, lon04, lon06, tok04, us-east, us-south, dal10, dal12, tor01, osa21, sao01, sao04, mon01, wdc04, wdc06, wdc07"
  }
}

variable "powervs_workspace_guid" {
  description = "Existing GUID of the PowerVS workspace. The GUID of the service instance associated with an account."
  type        = string
}

#####################################################
# PowerVS Instance Parameters
#####################################################

variable "powervs_ssh_public_key_name" {
  description = "Name of the PowerVS SSH key to create."
  type        = string
}

variable "powervs_image_id" {
  description = "Image ID used for PowerVS instance. Run 'ibmcloud pi images' to list available images."
  type        = string
}

variable "powervs_boot_image_storage_tier" {
  description = "Storage type for server deployment; Possible values tier0, tier1 and tier3"
  type        = string
}

variable "powerv_cluster_nodes" {
  description = "Number of PowerVS instances in the cluster"
  type        = number
}

variable "powervs_instance_name" {
  description = "Name of instance which will be created."
  type        = string
}

variable "powervs_server_type" {
  description = "Processor type e980/s922/e1080/s1022. Required when not creating SAP instances."
  type        = string
}

variable "powervs_cpu_proc_type" {
  description = "Dedicated or shared processors. Required when not creating SAP instances."
  type        = string
}

variable "powervs_number_of_processors" {
  description = "Number of processors. Required when not creating SAP instances."
  type        = string
}

variable "powervs_memory_size" {
  description = "Amount of memory. Required when not creating SAP instances."
  type        = string
}

variable "powervs_networks" {
  description = "Existing list of private subnet ids to be attached to an instance. The first element will become the primary interface."
  type = list(
    object({
      name = string
      id   = string
      cidr = optional(string)
    })
  )
}

variable "powervs_dedicated_filesystem_config" {
  description = "Custom File systems to be created and attached to PowerVS instance. 'disk_size' is in GB. 'count' specify over how many storage volumes the file system will be striped. 'tier' specifies the storage tier in PowerVS workspace. 'mount' specifies the mount point on the OS."
  type = list(object({
    name  = string
    size  = string
    count = string
    tier  = string
    mount = string
  }))
}
