variable "powervs_workspace_guid" {
  description = "powervs workspace guid"
  type        = string
}

variable "powervs_subnet_list" {
  description = "Count of subnet that is required for the workspace"
  type = list(object({
    name              = string
    cidr              = string
    reserved_ip_count = number
  }))
}

variable "aix_os_image" {
  description = "List of Images to be imported into cloud account from catalog images. Supported values can be found [here](https://github.com/terraform-ibm-modules/terraform-ibm-powervs-infrastructure/blob/main/solutions/full-stack/docs/catalog_image_names.md)"
  type        = string
}
