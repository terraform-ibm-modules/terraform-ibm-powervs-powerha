variable "prefix" {
  description = "A unique identifier for resources. This identifier must start with a letter, followed by a combination of letters, numbers, hyphens (-), or underscores (_). It should be between 1 and 8 characters in length. This prefix will be added to any resources created by using this template."
  type        = string
}

variable "powervs_zone" {
  description = "IBM Cloud data center location where IBM PowerVS infrastructure will be created."
  type        = string
}

variable "ssh_public_key" {
  description = "Public SSH Key for workspace and Power Virtual Server instance creation. The public SSH key must be an RSA key with a key size of either 2048 bits or 4096 bits (recommended). It must be a valid SSH key and the same SSH Key that was used in VPC creation."
  type        = string
}

variable "powervs_resource_group_name" {
  description = "Existing IBM Cloud resource group name."
  type        = string
}

variable "transit_gateway_connection" {
  description = "Set enable to true and provide the ID of the existing transit gateway to attach the PowerVS workspace to TGW. If enable is false, the PowerVS workspace will not be attached to TGW."
  type = object({
    enable             = bool
    transit_gateway_id = string
  })
}

variable "aix_os_image" {
  description = "List of Images to be imported into cloud account from catalog images. Supported values can be found [here](https://github.com/terraform-ibm-modules/terraform-ibm-powervs-infrastructure/blob/main/solutions/full-stack/docs/catalog_image_names.md)"
  type        = list(string)
}

variable "tags" {
  description = "List of tag names for the IBM Cloud PowerVS workspace"
  type        = list(string)
  default     = []
}

variable "powervs_subnet_list" {
  description = "IBM Cloud Power Virtual Server subnet configuration details like name and CIDR."
  type = list(object({
    name              = string
    cidr              = string
    reserved_ip_count = number
  }))
  validation {
    condition     = (length(var.powervs_subnet_list) == length(distinct([for item in var.powervs_subnet_list : lower(item.name)]))) && (length(var.powervs_subnet_list) == length(distinct([for item in var.powervs_subnet_list : join(".", slice(split(".", item.cidr), 0, 3))]))) && length(var.powervs_subnet_list) >= 1 && length(var.powervs_subnet_list) <= 16
    error_message = "Ensure no duplicate subnet names or CIDRs. A maximum of 14 subnets are allowed."
  }
}
