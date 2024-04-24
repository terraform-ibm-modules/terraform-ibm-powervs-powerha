variable "powervs_workspace_guid" {
  description = "PowerVS infrastructure workspace guid. The GUID of the resource instance."
  type        = string
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

variable "aix_os_image" {
  description = "AIX operating system images for Power Virtual Server instances. Power Virtual Server instances are installed with the given AIX OS image. The supported AIX OS images are: 7300-02-01, 7300-00-01, 7200-05-06."
  type        = string
}
