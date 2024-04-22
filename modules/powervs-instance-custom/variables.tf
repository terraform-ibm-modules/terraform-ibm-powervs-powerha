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
  description = "IBM Powervs machine type. The supported machine types are: s922, e980, s1022, e1080."
  type        = string
}

variable "pi_cpu_proc_type" {
  description = "Dedicated or shared processors."
  type        = string
}

variable "pi_number_of_processors" {
  description = "Number of processors."
  type        = string
}

variable "pi_memory_size" {
  description = "Amount of memory."
  type        = string
}

variable "pi_storage_type" {
  description = "Storage Type."
  type        = string
}

variable "pi_prefix" {
  description = "A unique identifier for resources. The identifier must begin with a lowercase letter and end with a lowercase letter or a number. This prefix will be prepended to any resources provisioned by this template. Prefixes must be 8 characters or fewer than 8 characters."
  type        = string
}

variable "pi_instance_count" {
  description = "Number of Power Virtual Server instances required to create in the workspace for PowerHA cluster."
  type        = number
}

variable "powervs_reserve_subnet_list" {
  description = "IBM Cloud Power Virtual Server subnet configuration details like name, CIDR, and reserved IP count used for PowerHA service label to be created."
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
  description = "List which contains size of shared volumes for powerHA volume groups."
  type        = list(number)
}
