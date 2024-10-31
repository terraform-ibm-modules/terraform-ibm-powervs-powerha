variable "powervs_workspace_guid" {
  description = "Existing GUID of the PowerVS workspace. The GUID of the service instance associated with an account."
  type        = string
}

variable "ssh_public_key_name" {
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
  description = "IBM Powervs machine type. The supported machine types are s922, e980, s1022, e1080."
  type        = string
  validation {
    condition     = contains(["s922", "e980", "s1022", "e1080"], var.pi_server_type)
    error_message = "The supported machine types are: s922, e980, s1022, e1080."
  }
}

variable "pi_cpu_proc_type" {
  description = "Processor types, The supported processor types are dedicated, shared or capped."
  type        = string
  validation {
    condition     = contains(["dedicated", "shared", "capped"], var.pi_cpu_proc_type)
    error_message = "The supported processor types are: dedicated, shared, capped."
  }
}

variable "pi_number_of_processors" {
  description = "Number of processors."
  type        = number
  validation {
    condition     = var.pi_number_of_processors >= 0.25
    error_message = "Number of processors must be greater than 0.25."
  }
}

variable "pi_memory_size" {
  description = "Amount of memory."
  type        = number
  validation {
    condition     = var.pi_memory_size >= 2
    error_message = "Memory size must be greater than 2 GB."
  }
}

variable "pi_storage_type" {
  description = "Storage Type, The supported storage types are tier0, tier1, tier3, and fixed IOPS."
  type        = string
  validation {
    condition     = contains(["tier0", "tier1", "tier3", "fixed IOPS"], var.pi_storage_type)
    error_message = "The supported storage types are: tier0, tier1, tier3, and fixed IOPS."
  }
}

variable "pi_prefix" {
  description = "A unique identifier for resources. This identifier must start with a letter, followed by a combination of letters, numbers, hyphens (-), or underscores (_). It should be between 1 and 14 characters in length. This prefix will be added to any resources created by using this template."
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-_]{0,14}$", var.pi_prefix))
    error_message = "The prefix must start with a letter, followed by a combination of letters, numbers, hyphens (-), or underscores (_). It should be between 1 and 14 characters in length."
  }
}

variable "pi_instance_count" {
  description = "Number of Power Virtual Server instances required to create in the workspace for PowerHA cluster. Allowed values are between 1 and 8."
  type        = number
  validation {
    condition     = var.pi_instance_count <= 8 && var.pi_instance_count >= 1
    error_message = "Allowed values are between 1 and 8."
  }
}

variable "powervs_reserve_subnet_list" {
  description = "IBM Cloud Power Virtual Server subnet configuration details like name, CIDR, and reserved IP count used for PowerHA Service Label to be created. Ensure no duplicate subnet names or CIDRs, and reserved_ip_count must be greater than 0."
  type = list(object({
    name              = string
    cidr              = string
    reserved_ip_count = number
  }))
}

variable "powervs_persistent_subnet_list" {
  description = "IBM Cloud Power Virtual Server subnet configuration details like name, CIDR, and reserved IP count used for PowerHA Service Label to be created. Ensure no duplicate subnet names or CIDRs, and reserved_ip_count must be greater than 0."
  type = list(object({
    name              = string
    cidr              = string
    reserved_ip_count = number
  }))
}

variable "dedicated_volume_count" {
  description = "Count of dedicated volumes that need to be created and attached to every Power Virtual Server instance separately."
  type        = number
}

variable "shared_volume_count" {
  description = "Count of shared volumes that need to created and attached to every Power Virtual Server instances."
  type        = number
}

variable "dedicated_volume_attributes" {
  description = "Size(In GB) of dedicated volumes that need to be created and attached to every Power Virtual Server instance separately."
  type = object({
    size = number
    tier = string
  })
}

variable "shared_volume_attributes" {
  description = "Size(In GB) of shared volumes that need to be created and attached to every Power Virtual Server instance separately."
  type = object({
    size = number
    tier = string
  })
}

variable "pha_shared_volume" {
  description = "List which contains size and tier of shared volumes for PowerHA volume groups."
  type = list(object({
    size = number
    tier = string
  }))
}
