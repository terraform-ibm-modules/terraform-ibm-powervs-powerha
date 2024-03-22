variable "pi_prefix" {
  description = "A unique identifier for resources. Must begin with a lowercase letter and end with a lowercase letter or number. This prefix will be prepended to any resources provisioned by this template. Prefixes must be 16 or fewer characters."
  type        = string
}

variable "bastion_host_ip" {
  description = "Virtual privide cloud's VSI ip address to access private powervs nodes"
  type        = string
}

variable "proxy_ip_and_port" {
  description = "proxy ip and port value. e.g. 10.30.10.4:3128"
  type        = string
}

variable "ssh_public_key" {
  description = "Public SSH Key for workspace and powervs instance creation. Must be an RSA key with a key size of either 2048 bits or 4096 bits (recommended). Must be a valid SSH key that does not already exist in the deployment region."
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

#######################################
# Ansible config setup
#######################################
variable "pi_cos_data" {
  type = object({
    bucket_name           = string
    cos_access_key_id     = string
    cos_secret_access_key = string
    cos_endpoint          = string
    folder_name           = string
  })
}

variable "shared_disk_wwns" {
  description = "List of wwn of shared volumes"
  type        = list(string)
}

variable "nodes" {
  description = "ip addresses of the nodes"
  type        = list(string)
}

variable "node_details" {
  description = "list of the node details"
  type = list(object({
    pi_instance_name = string
    pi_instance_primary_ip        = string
    pi_instance_private_ips      = list(string)
  }))
}

variable "aix_image_id" {
  description = "aix image"
  type        = string
}

variable "powerha_resource_group_count" {
  description = "Count of Resource Group In PowerHA"
  type        = number
}

variable "powerha_resource_group_list" {
  description = "List Of parameter for Resource Group"
  type = list(object({
    name     = string
    startup  = string
    fallover = string
    fallback = string
  }))
}

variable "volume_group_count" {
  description = "Count of Volume Group In PowerHA"
  type        = number
}

variable "volume_group_list" {
  description = "List Of parameter for Volume Group"
  type = list(object({
    name                  = string
    rg_name               = string
    physical_volume_count = number
    type                  = string
  }))
}

variable "file_system_count" {
  description = "Count of File System"
  type        = number
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
}

variable "subnet_list" {
  description = "Name of the IBM Cloud PowerVS subnet, CIDR and reserved IP count used for PowerHA service label to create."
  type = list(object({
    name              = string
    cidr              = string
    reserved_ip_count = number
  }))
}

variable "reserve_ip_data" {
  description = "details of reserved ip"
  type = list(object({
    ip              = string
    name            = string
    pvm_instance_id = string
  }))
}
