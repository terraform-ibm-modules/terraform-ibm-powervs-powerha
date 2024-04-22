variable "bastion_host_ip" {
  description = "Virtual private cloud's VSI ip address to access private powervs nodes"
  type        = string
}

variable "proxy_ip_and_port" {
  description = "Proxy host:port of created PowerVS infrastructure."
  type        = string
}

variable "ssh_private_key" {
  description = "Private SSH key (RSA format) used to login to IBM PowerVS instances. Should match to public SSH key referenced by 'ssh_public_key'. Entered data must be in [heredoc strings format](https://www.terraform.io/language/expressions/strings#heredoc-strings). The key is not uploaded or stored. For more information about SSH keys, see [SSH keys](https://cloud.ibm.com/docs/vpc?topic=vpc-ssh-keys)."
  type        = string
  sensitive   = true
}


#######################################
# Ansible config setup
#######################################
variable "pha_cos_data" {
  description = "Details about cloud object storage bucket where PowerHA installation media folder and ssl file are located. For more details click [here](https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-service-credentials)."
  type = object({
    bucket_name           = string
    cos_access_key_id     = string
    cos_secret_access_key = string
    cos_endpoint          = string
    folder_name           = string
    ssl_file_name         = string
  })
}

variable "repository_disk_wwn" {
  description = "WWN of PowerVS shared disk as repository disk for powerHA cluster creation."
  type        = string
}

variable "shared_disk_wwns" {
  description = "List of wwn of shared volumes to create volume group."
  type        = list(string)
}

variable "node_details" {
  description = "PowerVS instances data for powerHA cluster creation."
  type = list(object({
    pi_instance_name        = string
    pi_instance_primary_ip  = string
    pi_instance_private_ips = list(string)
    pi_extend_volume        = string
  }))
}

variable "aix_image_id" {
  description = "ID of AIX image."
  type        = string
}

variable "powerha_resource_group_count" {
  description = "Number of Resource Groups which need to be created in PowerHA."
  type        = number
}

variable "powerha_resource_group_list" {
  description = "List of parameters for Resource group - Individual PowerHA Resource group configuration. Based on the powerha_resource_group count, you can provide all the resource group configuration like name, start up, fallover and fallback polices. Default configuration will be taken if details are not provided."
  type = list(object({
    name     = string
    startup  = string
    fallover = string
    fallback = string
  }))
}

variable "volume_group_count" {
  description = "Number of Volume Groups which need to be created in PowerHA."
  type        = number
}

variable "volume_group_list" {
  description = "List of parameters for volume group - Individual PowerHA volume group configuration. Based on the volume_group count, you can provide all the volume group configuration like name, resource group name and type. Default configuration will be taken if details are not provided."
  type = list(object({
    name    = string
    rg_name = string
    size    = number
    type    = string
  }))
}

variable "file_system_count" {
  description = "Number of File systems which need to be created in PowerHA."
  type        = number
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
}

variable "subnet_list" {
  description = "IBM Cloud Power Virtual Server subnet configuration details like name and CIDR."
  type = list(object({
    name = string
    cidr = string
  }))
}

variable "reserved_subnet_list" {
  description = "IBM Cloud Power Virtual Server subnet configuration details like name, CIDR, and reserved IP count used for PowerHA service label to be created."
  type = list(object({
    name              = string
    cidr              = string
    reserved_ip_count = number
  }))
}

variable "reserve_ip_data" {
  description = "Reserve IP address of the network interface of IBM PowerVS instance."
  type = list(object({
    ip              = string
    name            = string
    pvm_instance_id = string
  }))
}
