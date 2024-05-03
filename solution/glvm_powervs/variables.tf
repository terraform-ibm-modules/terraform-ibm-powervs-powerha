variable "prerequisite_workspace_id" {
  description = "IBM Cloud Schematics workspace ID of an existing Power Virtual Server with VPC landing zone catalog solution. If you do not yet have an existing deployment, click [here](https://cloud.ibm.com/catalog/architecture/deploy-arch-ibm-pvs-inf-2dd486c7-b317-4aaa-907b-42671485ad96-global?) to create one."
  type        = string
}

variable "prefix" {
  description = "A unique identifier for resources. The identifier must begin with a lowercase letter and end with a lowercase letter or a number. This prefix will be prepended to any resources provisioned by this template. Prefix must be 8 characters or fewer than 8 characters."
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-_]{0,7}$", var.prefix))
    error_message = "The prefix must begin with an alphabetic character followed by an alphanumeric character, an underscore, and a hyphen. Prefixes must be a maximum of 8  characters."
  }
}

variable "site2_powervs_zone" {
  description = "IBM Cloud data center location for site2, where IBM PowerVS infrastructure will be created for site2."
  type        = string
}

variable "ssh_public_key" {
  description = "Public SSH Key for workspace and Power Virtual Server instance creation. The public SSH key must be an RSA key with a key size of either 2048 bits or 4096 bits (recommended). It must be a valid SSH key that does not already exist in the deployment region."
  type        = string
}

variable "ssh_private_key" {
  description = "Private SSH key (RSA format) used to login to IB;M Power Virtual Server instances. The private SSH key should match with the public SSH key referenced by the 'ssh_public_key' parameter. The input data must be in heredoc strings format (https://www.terraform.io/language/expressions/strings#heredoc-strings). The private SSH key is not uploaded or stored anywhere. For more information about SSH keys, see [SSH keys](https://cloud.ibm.com/docs/vpc?topic=vpc-ssh-keys)."
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

variable "site1_powervs_instance_count" {
  description = "Number of Power Virtual Server instances required to create in the site1 workspace for PowerHA cluster."
  type        = number
  validation {
    condition     = var.site1_powervs_instance_count <= 8 && var.site1_powervs_instance_count >= 1
    error_message = "Allowed values are between 1 and 8."
  }
}

variable "site2_powervs_instance_count" {
  description = "Number of Power Virtual Server instances required to create in the site2 workspace for PowerHA cluster."
  type        = number
  validation {
    condition     = var.site2_powervs_instance_count <= 8 && var.site2_powervs_instance_count >= 1
    error_message = "Allowed values are between 1 and 8."
  }
}

variable "site1_tshirt_size" {
  description = <<EOT
  Power Virtual Server instance profiles for site1. Power Virtual instance will be created based on the following values:
    proc_type: shared
    tier: tier1 (This value is the same for all profiles)
  EOT
  type        = string
}

variable "site2_tshirt_size" {
  description = <<EOT
  Power Virtual Server instance profiles for site2. Power Virtual instance will be created based on the following values:
    proc_type: shared
    tier: tier1 (This value is the same for all profiles)
  EOT
  type        = string
}

variable "powervs_machine_type" {
  description = <<EOT
  IBM Powervs machine type. The supported machine types are: s922, e980, s1022, e1080.
  For more details:
    [Availability of the machine type](https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-creating-power-virtual-server#creating-service)
    [IBM Cloud PowerVS documentation](https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-getting-started)
  EOT
  type        = string
}

variable "aix_os_image" {
  description = "AIX operating system images for Power Virtual Server instances. Power Virtual Server instances are installed with the given AIX OS image."
  type        = string
}

variable "site1_subnet_list" {
  description = "IBM Cloud Power Virtual Server subnet configuration details like name and CIDR."
  type = list(object({
    name = string
    cidr = string
  }))
  validation {
    condition     = (length(var.site1_subnet_list) == length(distinct([for item in var.site1_subnet_list : lower(item.name)]))) && (length(var.site1_subnet_list) == length(distinct([for item in var.site1_subnet_list : join(".", slice(split(".", item.cidr), 0, 3))]))) && length(var.site1_subnet_list) >= 1 && length(var.site1_subnet_list) <= 14
    error_message = "More than 14 subnets and Duplicate subnet name and cidr are not allowed."
  }
}

variable "site1_reserve_subnet_list" {
  description = "IBM Cloud Power Virtual Server subnet configuration details like name, CIDR, and reserved IP count used for PowerHA service label to be created."
  type = list(object({
    name              = string
    cidr              = string
    reserved_ip_count = number
  }))
  validation {
    condition     = (length(var.site1_reserve_subnet_list) == length(distinct([for item in var.site1_reserve_subnet_list : lower(item.name)]))) && (length(var.site1_reserve_subnet_list) == length(distinct([for item in var.site1_reserve_subnet_list : join(".", slice(split(".", item.cidr), 0, 3))]))) && length(var.site1_reserve_subnet_list) >= 1 && length(var.site1_reserve_subnet_list) <= 2 && alltrue([for data in var.site1_reserve_subnet_list : true if data.reserved_ip_count >= 1])
    error_message = "More than 2 subnets and Duplicate subnet name and cidr are not allowed. reserved_ip_count should be more than 0."
  }
}

variable "site2_subnet_list" {
  description = "IBM Cloud Power Virtual Server subnet configuration details like name and CIDR."
  type = list(object({
    name = string
    cidr = string
  }))
  validation {
    condition     = (length(var.site2_subnet_list) == length(distinct([for item in var.site2_subnet_list : lower(item.name)]))) && (length(var.site2_subnet_list) == length(distinct([for item in var.site2_subnet_list : join(".", slice(split(".", item.cidr), 0, 3))]))) && length(var.site2_subnet_list) >= 1 && length(var.site2_subnet_list) <= 14
    error_message = "More than 14 subnets and Duplicate subnet name and cidr are not allowed."
  }
}

variable "site2_reserve_subnet_list" {
  description = "IBM Cloud Power Virtual Server subnet configuration details like name, CIDR, and reserved IP count used for PowerHA service label to be created."
  type = list(object({
    name              = string
    cidr              = string
    reserved_ip_count = number
  }))
  validation {
    condition     = (length(var.site2_reserve_subnet_list) == length(distinct([for item in var.site2_reserve_subnet_list : lower(item.name)]))) && (length(var.site2_reserve_subnet_list) == length(distinct([for item in var.site2_reserve_subnet_list : join(".", slice(split(".", item.cidr), 0, 3))]))) && length(var.site2_reserve_subnet_list) >= 1 && length(var.site2_reserve_subnet_list) <= 2 && alltrue([for data in var.site2_reserve_subnet_list : true if data.reserved_ip_count >= 1])
    error_message = "More than 2 subnets and Duplicate subnet name and cidr are not allowed, reserved_ip_count should be more than 0."
  }
}

variable "dedicated_volume" {
  description = "Count of dedicated volumes that need to be created and attached to every Power Virtual Server instance separately."
  type        = number
  validation {
    condition     = var.dedicated_volume >= 0 && var.dedicated_volume <= 127
    error_message = "Dedicated volume count can be 0 or positive number."
  }
}

variable "shared_volume" {
  description = "Count of shared volumes that need to created and attached to every Power Virtual Server instances."
  type        = number
  validation {
    condition     = var.shared_volume >= 1 && var.shared_volume <= 127
    error_message = "Shared volume count can not be less than 1."
  }
}

variable "cos_powerha_image_download" {
  description = <<EOT
  Details about cloud object storage bucket where PowerHA installation media folder and ssl file are located. For more details click [here](https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-service-credentials).
  Example:
    {
      "bucket_name":"bucket-name",
      "cos_access_key_id":"1dxxxxxxxxxx36",
      "cos_secret_access_key":"4dxxxxxx5c",
      "cos_endpoint":"https://s3.region.cloud-object-storage.appdomain.cloud",
      "folder_name":"powerha-build-parent-folder-name",
      "ssl_file_name": "ssl-file-path"
    }

  You can keep the PowerHA images in the following format in the IBM Cloud COS Bucket.
  Example: 728 is a parent folder
    728/Gold/<filename>.tar.gz
    728/SPx/<filename>.tar.gz
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
  description = "Number of Resource Groups which need to be created in PowerHA."
  type        = number
  validation {
    condition     = var.powerha_resource_group >= 1 && var.powerha_resource_group <= 256
    error_message = "PowerHA resource group count should be between 1 to 256."
  }
}

variable "powerha_glvm_volume_group" {
  description = "Number of Volume Groups which need to be created in PowerHA."
  type        = number
  validation {
    condition     = var.powerha_glvm_volume_group >= 1 && var.powerha_glvm_volume_group <= 512
    error_message = "PowerHA volume group count should be between 1 to 512."
  }
}


#####################################################
# Optional Parameters
#####################################################

variable "site2_cloud_connection" {
  description = "Cloud connection configuration: speed (50, 100, 200, 500, 1000, 2000, 5000, 10000 Mb/s), count (1 or 2 connections), global_routing (true or false), metered (true or false). Not applicable for DCs where PER is enabled. All the Power Virtual Server subnets which are created as part of the powervs_subnet_list are attached to this cloud connection."
  type = object({
    count          = number
    speed          = number
    global_routing = bool
    metered        = bool
  })
  validation {
    condition     = var.site2_cloud_connection.count <= 2 && var.site2_cloud_connection.count >= 1
    error_message = "Cloud connection allowed maximum 2."
  }
}

variable "site1_custom_profile" {
  description = "Overrides t-shirt profile for site1: Custom PowerVS instance. Specify combination of cores, memory, proc_type and storage tier."
  type = object({
    cores     = number
    memory    = number
    proc_type = string
    tier      = string
  })
  validation {
    condition     = var.site1_custom_profile.cores >= 0.25 && var.site1_custom_profile.memory >= 2 && contains(["dedicated", "shared", "capped"], var.site1_custom_profile.proc_type) && contains(["tier0", "tier1", "tier3", "fixed IOPS"], var.site1_custom_profile.tier)
    error_message = <<EOT
    Invalid custom config. Please provide valid cores, memory, proc_type and storage tier.
    Cores must be greater than 0.25 and memory must be greater than 2 GB.
    Supported values:
      proc_type: [dedicated, shared, capped]
      tier: [tier0, tier1, tier3, fixed IOPS]
    EOT
  }
}

variable "site2_custom_profile" {
  description = "Overrides t-shirt profile for site2: Custom PowerVS instance. Specify combination of cores, memory, proc_type and storage tier."
  type = object({
    cores     = number
    memory    = number
    proc_type = string
    tier      = string
  })
  validation {
    condition     = var.site2_custom_profile.cores >= 0.25 && var.site2_custom_profile.memory >= 2 && contains(["dedicated", "shared", "capped"], var.site2_custom_profile.proc_type) && contains(["tier0", "tier1", "tier3", "fixed IOPS"], var.site2_custom_profile.tier)
    error_message = <<EOT
    Invalid custom config. Please provide valid cores, memory, proc_type and storage tier.
    Cores must be greater than 0.25 and memory must be greater than 2 GB.
    Supported values:
      proc_type: [dedicated, shared, capped]
      tier: [tier0, tier1, tier3, fixed IOPS]
    EOT
  }
}

variable "dedicated_volume_attributes" {
  description = "Size(In GB) of dedicated volumes that need to be created and attached to every Power Virtual Server instance separately."
  type = object({
    size = number
    tier = string
  })
  validation {
    condition     = var.dedicated_volume_attributes.size >= 10 && var.dedicated_volume_attributes.size <= 10000 && contains(["tier0", "tier1", "tier3", "fixed IOPS"], var.dedicated_volume_attributes.tier)
    error_message = "Dedicated Volume Size should be between 10 and 10000 and tier should be tier0, tier1, tier3, fixed IOPS."
  }
}

variable "shared_volume_attributes" {
  description = "Size(In GB) of shared volumes that need to be created and attached to every Power Virtual Server instance separately."
  type = object({
    size = number
    tier = string
  })
  validation {
    condition     = var.shared_volume_attributes.size >= 10 && var.shared_volume_attributes.size <= 10000 && contains(["tier0", "tier1", "tier3", "fixed IOPS"], var.shared_volume_attributes.tier)
    error_message = "Shared Volume Size should be between 10 and 10000 and tier should be tier0, tier1, tier3, fixed IOPS."
  }
}

variable "powerha_resource_group_list" {
  description = "List of parameters for Resource group - Individual PowerHA Resource group configuration. Based on the powerha_resource_group count, you can provide all the resource group configuration like name, start up, fallover and fallback polices. Default configuration will be taken if details are not provided."
  type = list(object({
    name        = string
    startup     = string
    fallover    = string
    fallback    = string
    site_policy = string
  }))
  validation {
    condition     = (length(var.powerha_resource_group_list) == length(distinct([for item in var.powerha_resource_group_list : lower(item.name)]))) && alltrue([for data in var.powerha_resource_group_list : contains(["OHN", "OFAN", "OAAN", "OUDP"], data.startup)]) && alltrue([for data in var.powerha_resource_group_list : contains(["FNPN", "FUDNP", "BO"], data.fallover)]) && alltrue([for data in var.powerha_resource_group_list : contains(["NFB", "FBHPN"], data.fallback)])
    error_message = <<EOT
    Duplicate PowerHA resource group name or incorrect startup, fallover, fallback values.
    Supported values:
      startup: [OHN, OFAN, OAAN, OUDP]
      fallover: [FNPN, FUDNP, BO]
      fallback: [NFB, FBHPN]
    EOT
  }
}

variable "powerha_glvm_volume_group_list" {
  description = "List of parameters for volume group - Individual PowerHA volume group configuration. Based on the volume_group count, you can provide all the volume group configuration like name, resource group name, type, size, tier. Default configuration will be taken if details are not provided."
  type = list(object({
    name    = string
    rg_name = string
    type    = string
    size    = number
    tier    = string
  }))
  validation {
    condition     = (length(var.powerha_glvm_volume_group_list) == length(distinct([for item in var.powerha_glvm_volume_group_list : lower(item.name)]))) && alltrue([for data in var.powerha_glvm_volume_group_list : contains(["original", "big", "scalable", "legacy"], data.type)]) && alltrue([for data in var.powerha_glvm_volume_group_list : data.size >= 30 && data.size <= 1000]) && alltrue([for data in var.powerha_glvm_volume_group_list : contains(["tier0", "tier1", "tier3", "fixed IOPS"], data.tier)])
    error_message = <<EOT
    Duplicate volume group name and size is less than 30 and more than 1000 is not allowed.
    Supported values:
      type: [original, big, scalable, legacy]
      tier: [tier0, tier1, tier3, fixed IOPS]
    EOT
  }
}

variable "tags" {
  description = "List of tag names for the IBM Cloud PowerVS workspace for identification separately from other resources."
  type        = list(string)
}
