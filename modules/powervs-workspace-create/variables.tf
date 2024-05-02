variable "prefix" {
  description = "A unique identifier for resources. Must begin with a lowercase letter and end with a lowercase letter or number. This prefix will be prepended to any resources provisioned by this template. Prefixes must be 16 or fewer characters."
  type        = string
}

variable "powervs_zone" {
  description = "IBM Cloud data center location where IBM PowerVS infrastructure will be created."
  type        = string
}

variable "ssh_public_key" {
  description = "Public SSH Key for VSI creation. Must be an RSA key with a key size of either 2048 bits or 4096 bits (recommended). Must be a valid SSH key that does not already exist in the deployment region."
  type        = string
}

variable "powervs_resource_group_name" {
  description = "Existing IBM Cloud resource group name."
  type        = string
}

variable "cloud_connection" {
  description = "Cloud connection configuration: speed (50, 100, 200, 500, 1000, 2000, 5000, 10000 Mb/s), count (1 or 2 connections), global_routing (true or false), metered (true or false). Not applicable for DCs where PER is enabled."
  type = object({
    count          = string
    speed          = number
    global_routing = bool
    metered        = bool
  })
}

variable "transit_gateway_connection" {
  description = "Set enable to true and provide ID of the existing transit gateway to attach the CCs( Non PER DC) to TGW or to attach PowerVS workspace to TGW (PER DC). If enable is false, CCs will not be attached to TGW , or PowerVS workspace will not be attached to TGW, but CCs in (Non PER DC) will be created."
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
    error_message = "More than 16 subnets and Duplicate subnet name and cidr are not allowed."
  }
}
