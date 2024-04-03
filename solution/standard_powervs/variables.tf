variable "prerequisite_workspace_id" {
  description = "IBM Cloud Schematics workspace ID of an existing Power Virtual Server with VPC landing zone catalog solution. If you do not yet have an existing deployment, click [here](https://cloud.ibm.com/catalog/architecture/deploy-arch-ibm-pvs-inf-2dd486c7-b317-4aaa-907b-42671485ad96-global?) to create one."
  type        = string
}

variable "prefix" {
  description = "A unique identifier for resources. The identifier must begin with a lowercase letter and end with a lowercase letter or a number. This prefix will be prepended to any resources provisioned by this template. Prefixes must be 8 characters or fewer than 8 characters."
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-_]{0,7}$", var.prefix))
    error_message = "The prefix must begin with an alphabetic character followed by an alphanumeric character, an underscore, and a hyphen. Prefixes must be a maximum of 8  characters."
  }
}

variable "powervs_zone" {
  description = "IBM Cloud data center location where IBM Power Virtual Server infrastructure will be created."
  type        = string
}

variable "ssh_public_key" {
  description = "Public SSH Key for workspace and Power Virtual Server instance creation. The public SSH key must be an RSA key with a key size of either 2048 bits or 4096 bits (recommended). It must be a valid SSH key that does not already exist in the deployment region."
  type        = string
}

variable "ssh_private_key" {
  description = "Private SSH key (RSA format) used to login to IBM Power Virtual Server instances. The private SSH key should match with the public SSH key referenced by the 'ssh_public_key' parameter. The input data must be in heredoc strings format (https://www.terraform.io/language/expressions/strings#heredoc-strings). The private SSH key is not uploaded or stored anywhere. For more information about SSH keys, see [SSH keys](https://cloud.ibm.com/docs/vpc?topic=vpc-ssh-keys)."
  type        = string
  sensitive   = true
}

variable "ibmcloud_api_key" {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources."
  type        = string
  sensitive   = true
}

variable "powervs_resource_group_name" {
  description = "Existing IBM Cloud resource group name."
  type        = string
}

variable "powervs_instance_count" {
  description = "Number of Power Virtual Server instances required to create in the workspace for PowerHA cluster."
  type        = number
  validation {
    condition     = var.powervs_instance_count < 9 && var.powervs_instance_count > 1
    error_message = "Allowed values are between 2 and 8."
  }
}

variable "tshirt_size" {
  description = <<EOT
  Power Virtual Server instance profiles. Power Virtual instance will be created based on the following values:
    proc_type: shared
    tier: tier1 (This value is the same for all profiles)

  The following specific AIX levels used for Power Virtual Machine are supported:
    aix_xs = { cores: 0.25, memory: 4 }
    aix_s  = { cores: 1, memory: 16 }
    aix_m  = { cores: 4, memory: 64 }
    aix_l  = { cores: 8, memory: 128 }
    aix_xl = { cores: 16, memory: 256 }
  EOT
  type        = string
}

variable "powervs_machine_type" {
  description = "IBM Powervs machine type. The supported machine types are: s922, e980."
  type        = string
}

variable "aix_os_image" {
  description = "AIX operating system images for Power Virtual Server instances. Power Virtual Server instances are installed with the given AIX OS image. The supported AIX I images are: 7300-01-02, 7300-00-01, 7200-05-06."
  type        = string
}

variable "powervs_subnet_list" {
  description = "IBM Cloud Power Virtual Server subnet configuration details like name, CIDR, and reserved IP count used for PowerHA service label to be created."
  type = list(object({
    name              = string
    cidr              = string
    reserved_ip_count = number
  }))
  validation {
    condition     = (length(var.powervs_subnet_list) == length(distinct([for item in var.powervs_subnet_list : lower(item.name)]))) && (length(var.powervs_subnet_list) == length(distinct([for item in var.powervs_subnet_list : join(".", slice(split(".", item.cidr), 0, 3))]))) && length(var.powervs_subnet_list) < 17
    error_message = "More than 16 subnets and Duplicate subnet name and cidr are not allowed."
  }
}

variable "dedicated_volume" {
  description = "Count of dedicated volumes that need to be created and attached to every Power Virtual Server instance separately."
  type        = number
  validation {
    condition     = var.dedicated_volume >= 0
    error_message = "Dedicated volume count can be 0 or positive number."
  }
}

variable "dedicated_volume_size" {
  description = "Size(In GB) of dedicated volumes that need to be created and attached to every Power Virtual Server instance separately."
  type        = number
  validation {
    condition     = var.dedicated_volume_size >= 10 && var.dedicated_volume_size <= 1000
    error_message = "Allowed values are between 10 and 1000."
  }
}

variable "shared_volume" {
  description = "Count of shared volumes that need to created and attached to all powervs instances."
  type        = number
  validation {
    condition     = var.shared_volume >= 1
    error_message = "Shared volume count can not be less than 1."
  }
}

variable "shared_volume_size" {
  description = "Size(In GB) of shared volumes that need to be created and attached to every Power Virtual Server instance separately."
  type        = number
  validation {
    condition     = var.shared_volume_size >= 10 && var.shared_volume_size <= 1000
    error_message = "Allowed values are between 10 and 1000."
  }
}

#####################################################
# Optional Parameters
#####################################################

variable "cloud_connection" {
  description = "Cloud connection configuration: speed (50, 100, 200, 500, 1000, 2000, 5000, 10000 Mb/s), count (1 or 2 connections), global_routing (true or false), metered (true or false). Not applicable for DCs where PER is enabled. All the Power Virtual Server subnets which are created as part of the powervs_subnet_list are attached to this cloud connection."
  type = object({
    count          = number
    speed          = number
    global_routing = bool
    metered        = bool
  })
  validation {
    condition     = var.cloud_connection.count < 3 && var.cloud_connection.count > 0
    error_message = "Cloud connection allowed maximum 2."
  }
}

variable "tags" {
  description = "List of tag names for the IBM Cloud PowerVS workspace for identification separately from other resources."
  type        = list(string)
  default     = []
}


#######################################
# Ansible config setup
#######################################

variable "cos_powerha_image_download" {
  description = <<EOT
  Details about cloud object storage bucket where PowerHA installation media folder and ssl file are located.
  Example forr COS Details
    {
      "bucket_name":"bucket-name",
      "cos_access_key_id":"1dxxxxxxxxxx36",
      "cos_secret_access_key":"4dxxxxxx5c",
      "cos_endpoint":"https://s3.region.cloud-object-storage.appdomain.cloud",
      "folder_name":"powerha-build-folder-name",
      "ssl_file_name": "ssl-file-path"
    }
  EOT
  type = object({
    bucket_name           = string
    cos_access_key_id     = string
    cos_secret_access_key = string
    cos_endpoint          = string
    folder_name           = string
    ssl_file_name         = string
  })
}


variable "powerha_resource_group" {
  description = "The number of Resource Groups which need to be created in PowerHA."
  type        = number
  validation {
    condition     = var.powerha_resource_group >= 1 && var.powerha_resource_group <= 256
    error_message = "PowerHA resource group count should be between 1 to 256."
  }
}

variable "powerha_resource_group_list" {
  description = "List of parameters for Resource group - Individual PowerHA Resource group configuration. Based on the powerha_resource_group count, you can provide all the resource group configuration like name, start up, fallover and fallback polices. Default configuration will be taken if details are not provided."
  type = list(object({
    name     = string
    startup  = string
    fallover = string
    fallback = string
  }))
  validation {
    condition     = (length(var.powerha_resource_group_list) == length(distinct([for item in var.powerha_resource_group_list : lower(item.name)]))) && alltrue([for data in var.powerha_resource_group_list : contains(["OHN", "OFAN", "OAAN", "OUDP"], data.startup)]) && alltrue([for data in var.powerha_resource_group_list : contains(["FNPN", "FUDNP", "BO"], data.fallover)]) && alltrue([for data in var.powerha_resource_group_list : contains(["NFB", "FBHPN"], data.fallback)])
    error_message = <<EOT
    Duplicate PowerHA resource group name or incorrect startup, fallover, fallback values.
    Spported values:
      startup: [OHN, OFAN, OAAN, OUDP]
      fallover: [FNPN, FUDNP, BO]
      fallback: [NFB, FBHPN]
    EOT
  }
}

variable "volume_group" {
  description = "The number of Volume Groups which need to be created in PowerHA."
  type        = number
  validation {
    condition     = var.volume_group >= 1 && var.volume_group <= 512
    error_message = "PowerHA volume group count should be between 1 to 512."
  }
}

variable "volume_group_list" {
  description = "List of parameters for volume group - Individual PowerHA volume group configuration. Based on the volume_group count, you can provide all the volume group configuration like name, resource group name and type. Default configuration will be taken if details are not provided."
  type = list(object({
    name    = string
    rg_name = string
    size    = number
    type    = string
  }))
  validation {
    condition     = (length(var.volume_group_list) == length(distinct([for item in var.volume_group_list : lower(item.name)]))) && alltrue([for data in var.volume_group_list : contains(["original", "big", "scalable", "legacy"], data.type)]) && alltrue([for data in var.volume_group_list : data.size >= 30 && data.size <= 1000])
    error_message = <<EOT
    Duplicate volume group name and size is less than 30 and more than 1000 is not allowed.
    Spported type: [original, big, scalable, legacy]
    EOT
  }
}

variable "file_system" {
  description = "The number of File systems which need to be created in PowerHA."
  type        = number
  validation {
    condition     = var.file_system >= 1 && var.file_system <= 512
    error_message = "PowerHA file system count should be between 1 to 512."
  }
}


variable "file_system_list" {
  description = "List of parameters for file system - Individual PowerHA file system configuration. Based on the file_system count, you can provide all the file system configuration like name, size_per_unit, block_size, type of file system, Units and volume group name. Default configuration will be taken if details are not provided."
  type = list(object({
    name          = string
    type          = string
    volume_group  = string
    units         = number
    size_per_unit = string
    block_size    = number
  }))
  validation {
    condition     = (length(var.file_system_list) == length(distinct([for item in var.file_system_list : lower(item.name)]))) && alltrue([for data in var.file_system_list : contains(["enhanced", "standard", "compressed", "large"], data.type)]) && alltrue([for data in var.file_system_list : data.units > 16]) && alltrue([for data in var.file_system_list : contains(["megabytes", "gigabytes"], data.size_per_unit)]) && alltrue([for data in var.file_system_list : contains([512, 1024, 2048, 4096], data.block_size)])
    error_message = <<EOT
    Duplicate file system name or units is less than 16 or incorrect type, size_per_unit, block_size values.
    Spported values:
      type: [enhanced, standard, compressed, large]
      size_per_unit: [megabytes, gigabytes]
      block_size: [512, 1024, 2048, 4096]
    EOT
  }
}
