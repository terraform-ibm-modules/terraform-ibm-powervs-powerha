variable "powervs_workspace_guid" {
  description = "PowerVS infrastructure workspace guid. The GUID of the resource instance."
  type        = string
}

variable "powervs_subnet_list" {
  description = "IBM Cloud Power Virtual Server subnet configuration details like name and CIDR. Ensure no duplicate subnet names or CIDRs. A maximum of 16 subnets are allowed."
  type = list(object({
    name              = string
    cidr              = string
    reserved_ip_count = number
  }))
  validation {
    condition     = (length(var.powervs_subnet_list) == length(distinct([for item in var.powervs_subnet_list : lower(item.name)]))) && (length(var.powervs_subnet_list) == length(distinct([for item in var.powervs_subnet_list : join(".", slice(split(".", item.cidr), 0, 3))]))) && length(var.powervs_subnet_list) >= 1 && length(var.powervs_subnet_list) <= 16
    error_message = "Ensure no duplicate subnet names or CIDRs. A maximum of 16 subnets are allowed."
  }
}

variable "aix_os_image" {
  description = "AIX image to be imported into cloud account from catalog images. Supported values can be found [here](https://github.com/terraform-ibm-modules/terraform-ibm-powervs-infrastructure/blob/main/solutions/full-stack/docs/catalog_image_names.md)"
  type        = string
}
