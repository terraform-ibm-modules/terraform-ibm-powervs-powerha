variable "prerequisite_workspace_id" {
  description = "IBM Cloud Schematics workspace ID of an existing 'Power Virtual Server with VPC landing zone' catalog solution. If you do not yet have an existing deployment, click [here](https://cloud.ibm.com/catalog/architecture/deploy-arch-ibm-pvs-inf-2dd486c7-b317-4aaa-907b-42671485ad96-global?) to create one."
  type        = string
}

variable "prefix" {
  description = "A unique identifier for resources. Prefix will be prepended to any resources provisioned by this template. Prefix must begin with alphabetic characters and followed by alphanumeric characters, underscore, and hyphens. Prefixes must be 8 or fewer characters."
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-_]{0,7}$", var.prefix))
    error_message = "Prefix must begin with alphabetic characters and followed by alphanumeric characters, underscore, and hyphens. Prefixes must be 8 or fewer characters."
  }
}

variable "powervs_zone" {
  description = "IBM cloud data center location where IBM PowerVS Infrastructure will be created."
  type        = string
}

variable "ssh_public_key" {
  description = "Public SSH Key for workspace and PowerVS Instances creation. Must be an RSA key with a key size of either 2048 bits or 4096 bits (recommended). Must be a valid SSH key that does not already exist in the deployment region."
  type        = string
}

variable "ssh_private_key" {
  description = "Private SSH key (RSA format) used to login to IBM PowerVS instances. Should match to public SSH key referenced by 'ssh_public_key'. Entered data must be in [heredoc strings format](https://www.terraform.io/language/expressions/strings#heredoc-strings). The key is not uploaded or stored. For more information about SSH keys, see [SSH keys](https://cloud.ibm.com/docs/vpc?topic=vpc-ssh-keys)."
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

variable "power_virtual_server" {
  description = "Number of PowerVS Instaces required to create in the workspace."
  type        = number
  validation {
    condition     = var.power_virtual_server < 9 && var.power_virtual_server > 1
    error_message = "More than 8 PowerVS Instances and less than 2 PowerVS Instances are not allowed."
  }
}

variable "tshirt_size" {
  description = <<EOT
  PowerVS Instance profiles, based on this profile values PowerVS Instance will be created. server_type: s922, proc_type: shared and tier: tier1 will be same for all profiles.
    aix_xs = { cores: 0.25, memory: 4 }
    aix_s  = { cores: 1, memory: 16 }
    aix_m  = { cores: 4, memory: 64 } 
    aix_l  = { cores: 8, memory: 128 } 
    aix_xl = { cores: 16, memory: 256 }
  EOT
  type        = string
}


variable "powervs_image_names" {
  description = "AIX OS Images for PowerVS Instaces. PowerVS Instances install the given AIX OS image. Supported AIX Images: [7300-01-02, 7300-00-01, 7200-05-06]"
  type        = string
}

variable "powervs_subnet_list" {
  description = "Name of the IBM Cloud PowerVS subnet, CIDR and reserved IP count used for PowerHA service label to create."
  type = list(object({
    name              = string
    cidr              = string
    reserved_ip_count = number
  }))
  validation {
    condition     = (length(var.powervs_subnet_list) == length(distinct([for item in var.powervs_subnet_list : lower(item.name)])) && length(var.powervs_subnet_list) < 17)
    error_message = "More than 16 subnets are not allowed."
  }
}

variable "dedicated_volume" {
  description = "Count of dedicated voulumes which need to be created and attached to each and every PowerVS Instance seperately. (By default 10 GB volume will be created and attached to PowerVS Instance)"
  type        = number
  validation {
    condition     = var.dedicated_volume > 0
    error_message = "dedicated volume count should be 1 or more than 1"
  }
}

variable "shared_volume" {
  description = "Count of shared voulumes which need to created and attached to all PowerVS Instances. (10 GB size for each shared volume)"
  type        = number
  validation {
    condition     = var.shared_volume >= 2
    error_message = "shared volume count can not be less than 2."
  }
}


#####################################################
# Optional Parameters
#####################################################

variable "cloud_connection" {
  description = "Cloud connection configuration: speed (50, 100, 200, 500, 1000, 2000, 5000, 10000 Mb/s), count (1 or 2 connections), global_routing (true or false), metered (true or false). Not applicable for DCs where PER is enabled."
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
  description = "List of tag names for the IBM Cloud PowerVS workspace for identification seperately from other resources"
  type        = list(string)
  default     = []
}


#######################################
# Ansible config setup
#######################################

variable "cos_powerha_image_download" {
  description = "Details of COS"
  type = object({
    bucket_name           = string
    cos_access_key_id     = string
    cos_secret_access_key = string
    cos_endpoint          = string
    folder_name           = string
  })
}


variable "powerha_resource_group" {
  description = "Count of Resource Group In PowerHA"
  type        = number
  validation {
    condition     = var.powerha_resource_group >= 1 && var.powerha_resource_group <= 256
    error_message = "PowerHA resource group count should be between 1 to 256"
  }
}

variable "powerha_resource_group_list" {
  description = "List Of parameter for Resource Group"
  type = list(object({
    name     = string
    startup  = string
    fallover = string
    fallback = string
  }))
  validation {
    condition     = length(var.powerha_resource_group_list) == length(distinct([for item in var.powerha_resource_group_list : lower(item.name)]))
    error_message = "Duplicate powerha resource group name is not allowed"
  }
}

variable "volume_group" {
  description = "Count of Volume Group In PowerHA"
  type        = number
  validation {
    condition     = var.volume_group >= 1 && var.volume_group <= 512
    error_message = "PowerHA volume group count should be between 1 to 512"
  }
}

variable "volume_group_list" {
  description = "List Of parameter for Volume Group"
  type = list(object({
    name                  = string
    rg_name               = string
    physical_volume_count = number
    type                  = string
  }))
  validation {
    condition     = length(var.volume_group_list) == length(distinct([for item in var.volume_group_list : lower(item.name)]))
    error_message = "Duplicate volume group name is not allowed"
  }
}

variable "file_system" {
  description = "Count of File System"
  type        = number
  validation {
    condition     = var.file_system >= 1 && var.file_system <= 512
    error_message = "PowerHA file system count should be between 1 to 512"
  }
}


variable "file_system_list" {
  description = "Name of file system"
  type = list(object({
    name          = string
    type          = string
    volume_group  = string
    units         = number
    size_per_unit = string
    block_size    = number
  }))
  validation {
    condition     = length(var.file_system_list) == length(distinct([for item in var.file_system_list : lower(item.name)]))
    error_message = "Duplicate file system name is not allowed"
  }
}

#############################################################################
# Schematics Output
#############################################################################

# tflint-ignore: terraform_naming_convention
variable "IC_SCHEMATICS_WORKSPACE_ID" {
  default     = ""
  type        = string
  description = "leave blank if running locally. This variable will be automatically populated if running from an IBM Cloud Schematics workspace"
}


