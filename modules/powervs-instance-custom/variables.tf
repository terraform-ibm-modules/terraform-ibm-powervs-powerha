variable "pi_workspace_guid" {
  description = "Existing GUID of the PowerVS workspace. The GUID of the service instance associated with an account."
  type        = string
}

variable "pi_ssh_public_key_name" {
  description = "Existing PowerVS SSH Public key name. Run 'ibmcloud pi keys' to list available keys."
  type        = string
}

variable "pi_image_id" {
  description = "Image ID used for PowerVS instance. Run 'ibmcloud pi images' to list available images."
  type        = string
}

variable "pi_networks" {
  description = "Existing list of private subnet ids to be attached to an instance. The first element will become the primary interface. Run 'ibmcloud pi networks' to list available private subnets."
  type = list(
    object({
      name = string
      id   = string
      cidr = optional(string)
    })
  )
}


variable "pi_server_type" {
  description = "Processor type e980/s922/e1080/s1022. Required when not creating SAP instances. Conflicts with 'pi_sap_profile_id'."
  type        = string
  default     = null
}

variable "pi_cpu_proc_type" {
  description = "Dedicated or shared processors. Required when not creating SAP instances. Conflicts with 'pi_sap_profile_id'."
  type        = string
  default     = null
}

variable "pi_number_of_processors" {
  description = "Number of processors. Required when not creating SAP instances. Conflicts with 'pi_sap_profile_id'."
  type        = string
  default     = null
}

variable "pi_memory_size" {
  description = "Amount of memory. Required when not creating SAP instances. Conflicts with 'pi_sap_profile_id'."
  type        = string
  default     = null
}

variable "pi_storage_type" {
  description = "Storage Type"
  type        = string
}

variable "pi_prefix" {
  description = "A unique identifier for resources. Must begin with a lowercase letter and end with a lowercase letter or number. This prefix will be prepended to any resources provisioned by this template. Prefixes must be 16 or fewer characters."
  type        = string
}

variable "pi_instance_count" {
  description = "Number of VMs with Affinity Policy."
  type        = number
}

variable "powervs_subnet_list" {
  description = "Count of subnet that is required for the workspace"
  type = list(object({
    name              = string
    cidr              = string
    reserved_ip_count = number
  }))
}

variable "pi_dedicated_volume_count" {
  description = "count of dedicated voulumes need to be attach to each powervs instance.(10 GB dedicated volume will be attach to each powervs instance)"
  type        = number
  default     = 2
}

variable "pi_shared_volume_count" {
  description = "count of shared voulumes need to be attach to among all powervs instances.(10 GB size for each shared volume)"
  type        = number
  default     = 2
}
