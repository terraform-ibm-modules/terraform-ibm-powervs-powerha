variable "prerequisite_workspace_id" {
  description = "IBM Cloud Schematics workspace ID of an existing Power Virtual Server with VPC landing zone catalog solution. If you do not yet have an existing deployment, click [here](https://cloud.ibm.com/catalog/architecture/deploy-arch-ibm-pvs-inf-2dd486c7-b317-4aaa-907b-42671485ad96-global?) to create one."
  type        = string
}

variable "prefix" {
  description = "A unique identifier for resources. This identifier must start with a letter, followed by a combination of letters, numbers, hyphens (-), or underscores (_). It should be between 1 and 8 characters in length. This prefix will be added to any resources created by using this template."
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-_]{0,7}$", var.prefix))
    error_message = "The prefix must start with a letter, followed by a combination of letters, numbers, hyphens (-), or underscores (_). It should be between 1 and 8 characters in length."
  }
}

variable "site2_powervs_zone" {
  description = "IBM Cloud data center location for the site2, where IBM PowerVS infrastructure will be created for the site2."
  type        = string
}

variable "ssh_public_key" {
  description = "Public SSH Key for workspace and Power Virtual Server instance creation. The public SSH key must be an RSA key with a key size of either 2048 bits or 4096 bits (recommended). It must be a valid SSH key and the same SSH Key that was used in VPC creation."
  type        = string
}

variable "ssh_private_key" {
  description = "Private SSH key (RSA format) used to login to IBM Power Virtual Server instances. The private SSH key should match with the public SSH key referenced by the 'ssh_public_key' parameter. The input data must be in heredoc strings format (https://www.terraform.io/language/expressions/strings#heredoc-strings). The private SSH key is not uploaded or stored anywhere. For more information about SSH keys, see [SSH keys](https://cloud.ibm.com/docs/vpc?topic=vpc-ssh-keys)."
  type        = string
  sensitive   = true
}

variable "ibmcloud_api_key" {
  description = "The IBM Cloud platform API key is needed to deploy IAM-enabled resources."
  type        = string
  sensitive   = true
}

variable "powervs_resource_group_name" {
  description = "Existing IBM Cloud resource group name."
  type        = string
}

variable "site1_powervs_instance_count" {
  description = "Number of Power Virtual Server instances required to create in the site1 workspace for PowerHA cluster. Allowed values are between 1 and 8."
  type        = number
  validation {
    condition     = var.site1_powervs_instance_count <= 8 && var.site1_powervs_instance_count >= 1
    error_message = "Allowed values are between 1 and 8.."
  }
}

variable "site2_powervs_instance_count" {
  description = "Number of Power Virtual Server instances required to create in the site2 workspace for PowerHA cluster. Allowed values are between 1 and 8."
  type        = number
  validation {
    condition     = var.site2_powervs_instance_count <= 8 && var.site2_powervs_instance_count >= 1
    error_message = "Allowed values are between 1 and 8."
  }
}

variable "site1_tshirt_size" {
  description = <<EOT
  Power Virtual Server instance profiles for site1. Power Virtual Server instance will be created based on the following values:
    proc_type: shared
    tier: tier1 (This value is the same for all profiles)
  EOT
  type        = string
}

variable "site2_tshirt_size" {
  description = <<EOT
  Power Virtual Server instance profiles for site2. Power Virtual Server instance will be created based on the following values:
    proc_type: shared
    tier: tier1 (This value is the same for all profiles)
  EOT
  type        = string
}

variable "powervs_machine_type" {
  description = <<EOT
  IBM Power Virtual Server machine type. The supported machine types are: s922, e980, s1022, e1080.
  For more details:
    [Availability of the machine type](https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-creating-power-virtual-server#creating-service)
    [IBM Cloud Power Virtual Server documentation](https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-getting-started)
  EOT
  type        = string
}

variable "aix_os_image" {
  description = "AIX operating system images for Power Virtual Server instances. Power Virtual Server instances are installed with the given AIX OS image."
  type        = string
}

variable "site1_subnet_list" {
  description = "IBM Cloud Power Virtual Server subnet configuration details for site1 like name and CIDR. Ensure no duplicate subnet names or CIDRs. A maximum of 14 subnets are allowed."
  type = list(object({
    name = string
    cidr = string
  }))
  validation {
    condition     = (length(var.site1_subnet_list) == length(distinct([for item in var.site1_subnet_list : lower(item.name)]))) && (length(var.site1_subnet_list) == length(distinct([for item in var.site1_subnet_list : join(".", slice(split(".", item.cidr), 0, 3))]))) && length(var.site1_subnet_list) >= 1 && length(var.site1_subnet_list) <= 14
    error_message = "Ensure no duplicate subnet names or CIDRs. A maximum of 14 subnets are allowed."
  }
}

variable "site1_reserve_subnet_list" {
  description = "IBM Cloud Power Virtual Server subnet configuration details for site1 like name, CIDR, and reserved IP count used for PowerHA Service Label to be created. Ensure no duplicate subnet names or CIDRs, and reserved_ip_count must be greater than 0. A maximum of 2 subnets are allowed."
  type = list(object({
    name              = string
    cidr              = string
    reserved_ip_count = number
  }))
  validation {
    condition     = (length(var.site1_reserve_subnet_list) == length(distinct([for item in var.site1_reserve_subnet_list : lower(item.name)]))) && (length(var.site1_reserve_subnet_list) == length(distinct([for item in var.site1_reserve_subnet_list : join(".", slice(split(".", item.cidr), 0, 3))]))) && length(var.site1_reserve_subnet_list) >= 1 && length(var.site1_reserve_subnet_list) <= 2 && alltrue([for data in var.site1_reserve_subnet_list : true if data.reserved_ip_count >= 1])
    error_message = "Ensure no duplicate subnet names or CIDRs, and reserved_ip_count must be greater than 0. A maximum of 2 subnets are allowed."
  }
}

variable "site2_subnet_list" {
  description = "IBM Cloud Power Virtual Server subnet configuration details for site2 like name and CIDR. Ensure no duplicate subnet names or CIDRs. A maximum of 14 subnets are allowed."
  type = list(object({
    name = string
    cidr = string
  }))
  validation {
    condition     = (length(var.site2_subnet_list) == length(distinct([for item in var.site2_subnet_list : lower(item.name)]))) && (length(var.site2_subnet_list) == length(distinct([for item in var.site2_subnet_list : join(".", slice(split(".", item.cidr), 0, 3))]))) && length(var.site2_subnet_list) >= 1 && length(var.site2_subnet_list) <= 14
    error_message = "Ensure no duplicate subnet names or CIDRs. A maximum of 14 subnets are allowed."
  }
}

variable "site2_reserve_subnet_list" {
  description = "IBM Cloud Power Virtual Server subnet configuration details for site2 like name, CIDR, and reserved IP count used for PowerHA Service Label to be created. Ensure no duplicate subnet names or CIDRs, and reserved_ip_count must be greater than 0. A maximum of 2 subnets are allowed."
  type = list(object({
    name              = string
    cidr              = string
    reserved_ip_count = number
  }))
  validation {
    condition     = (length(var.site2_reserve_subnet_list) == length(distinct([for item in var.site2_reserve_subnet_list : lower(item.name)]))) && (length(var.site2_reserve_subnet_list) == length(distinct([for item in var.site2_reserve_subnet_list : join(".", slice(split(".", item.cidr), 0, 3))]))) && length(var.site2_reserve_subnet_list) >= 1 && length(var.site2_reserve_subnet_list) <= 2 && alltrue([for data in var.site2_reserve_subnet_list : true if data.reserved_ip_count >= 1])
    error_message = "Ensure no duplicate subnet names or CIDRs, and reserved_ip_count must be greater than 0. A maximum of 2 subnets are allowed."
  }
}

variable "dedicated_volume" {
  description = "Count of dedicated volumes that need to be created and attached to every Power Virtual Server instance separately. Allowed values are between 0 and 127."
  type        = number
  validation {
    condition     = var.dedicated_volume >= 0 && var.dedicated_volume <= 127
    error_message = "Allowed values are between 0 and 127."
  }
}

variable "shared_volume" {
  description = "Count of shared volumes that need to created and attached to every Power Virtual Server instances. Allowed values are between 1 and 127."
  type        = number
  validation {
    condition     = var.shared_volume >= 1 && var.shared_volume <= 127
    error_message = "Allowed values are between 1 and 127."
  }
}

variable "cos_powerha_image_download" {
  description = <<EOT
  Details about cloud object storage bucket where PowerHA installation media folder and SSL file are located. For more details click [here](https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-service-credentials).
  ssl_file_name is only applicable to AIX 7.2 and can be skipped for AIX 7.3.
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

variable "powerha_glvm_volume_group" {
  description = "Number of GLVM Volume Groups that need to be created in PowerHA. Allowed values are between 1 and 512."
  type        = number
  validation {
    condition     = var.powerha_glvm_volume_group >= 1 && var.powerha_glvm_volume_group <= 512
    error_message = "Allowed values are between 1 and 512."
  }
}


#####################################################
# Optional Parameters
#####################################################

variable "site1_custom_profile" {
  description = "Overrides t-shirt profile: Custom Power Virtual Server instance for site1. Specify a combination of cores, memory, proc_type, and storage tier. For more details click [here](https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-creating-power-virtual-server#creating-power-virtual-server%22)."
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
  description = "Overrides t-shirt profile: Custom Power Virtual Server instance for site2. Specify a combination of cores, memory, proc_type, and storage tier. For more details click [here](https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-creating-power-virtual-server#creating-power-virtual-server%22)."
  type = object({
    cores     = number
    memory    = number
    proc_type = string
    tier      = string
  })
  validation {
    condition     = var.site2_custom_profile.cores >= 0.25 && var.site2_custom_profile.memory >= 2 && contains(["dedicated", "shared", "capped"], var.site2_custom_profile.proc_type) && contains(["tier0", "tier1", "tier3", "fixed IOPS"], var.site2_custom_profile.tier)
    error_message = <<EOT
    Invalid custom config. Please provide valid cores, memory, proc_type, and storage tier.
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
    error_message = "The dedicated volume size should be between 10 and 10000 and the tier should be tier0, tier1, tier3, and fixed IOPS."
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
    error_message = "The shared volume size should be between 10 and 10000 and the tier should be tier0, tier1, tier3, and fixed IOPS."
  }
}

variable "powerha_glvm_volume_group_list" {
  description = "List of parameters for GLVM volume group - Individual PowerHA GLVM volume group configuration. Based on the powerha_glvm_volume_group count, you can provide all the GLVM volume group configurations like name, type, size, and tier. The default configuration will be taken if details are not provided."
  type = list(object({
    name = string
    type = string
    size = number
    tier = string
  }))
  validation {
    condition     = (length(var.powerha_glvm_volume_group_list) == length(distinct([for item in var.powerha_glvm_volume_group_list : lower(item.name)]))) && alltrue([for data in var.powerha_glvm_volume_group_list : contains(["sync"], data.type)]) && alltrue([for data in var.powerha_glvm_volume_group_list : data.size >= 30 && data.size <= 1000]) && alltrue([for data in var.powerha_glvm_volume_group_list : contains(["tier0", "tier1", "tier3", "fixed IOPS"], data.tier)])
    error_message = <<EOT
    Duplicate volume group names and sizes are less than 30 and more than 1000 is not allowed.
    Supported values:
      type: [sync]
      tier: [tier0, tier1, tier3, fixed IOPS]
    EOT
  }
}

variable "tags" {
  description = "List of tag names for the IBM Cloud PowerVS workspace for identification separately from other resources."
  type        = list(string)
}
