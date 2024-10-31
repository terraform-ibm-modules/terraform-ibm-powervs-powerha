variable "bastion_host_ip" {
  description = "Virtual private cloud's VSI ip address to access private powervs nodes."
  type        = string
}

variable "proxy_ip_and_port" {
  description = "Proxy host:port of created PowerVS infrastructure."
  type        = string
}

variable "ssh_private_key" {
  description = "Private SSH key (RSA format) used to login to IBM PowerVS instances."
  type        = string
  sensitive   = true
}

#######################################
# Ansible config setup
#######################################

variable "pha_cos_data" {
  description = "Details about cloud object storage bucket where PowerHA installation media folder are located."
  type = object({
    bucket_name           = string
    cos_access_key_id     = string
    cos_secret_access_key = string
    cos_endpoint          = string
    folder_name           = string
  })
}

variable "site1_repository_disk_wwn" {
  description = "WWN of PowerVS shared disk as repository disk for PowerHA cluster creation."
  type        = string
}

variable "site2_repository_disk_wwn" {
  description = "WWN of PowerVS shared disk as repository disk for PowerHA cluster creation."
  type        = string
}

variable "site1_shared_disk_wwns" {
  description = "List of wwn of shared volumes to create volume group."
  type        = list(string)
}

variable "site2_shared_disk_wwns" {
  description = "List of wwn of shared volumes to create volume group."
  type        = list(string)
}

variable "site1_node_details" {
  description = "PowerVS instances data for PowerHA cluster creation."
  type = list(object({
    pi_instance_name        = string
    pi_instance_id          = string
    pi_instance_primary_ip  = string
    pi_instance_private_ips = list(string)
    pi_extend_volume        = string

  }))
}

variable "site2_node_details" {
  description = "PowerVS instances data for powerHA cluster creation."
  type = list(object({
    pi_instance_name        = string
    pi_instance_id          = string
    pi_instance_primary_ip  = string
    pi_instance_private_ips = list(string)
    pi_extend_volume        = string
  }))
}

variable "powerha_glvm_volume_group" {
  description = "Number of GLVM Volume Groups that need to be created in PowerHA."
  type        = number
}

variable "powerha_glvm_volume_group_list" {
  description = "List of parameters for GLVM volume group - Individual PowerHA GLVM volume group configuration. Based on the powerha_glvm_volume_group count, you can provide all the GLVM volume group configurations like name, type, size, and tier. The default configuration will be taken if details are not provided."
  type = list(object({
    name = string
    type = string
    size = number
    tier = string
  }))
}

variable "site1_subnet_list" {
  description = "IBM Cloud Power Virtual Server subnet configuration details like name and CIDR."
  type = list(object({
    name = string
    cidr = string
  }))
}

variable "site2_subnet_list" {
  description = "IBM Cloud Power Virtual Server subnet configuration details like name and CIDR."
  type = list(object({
    name = string
    cidr = string
  }))
}

variable "site1_reserve_ip_data" {
  description = "Reserve IP address of the network interface of IBM PowerVS instance."
  type = list(object({
    ip              = string
    name            = string
    pvm_instance_id = string
  }))
}

variable "site2_reserve_ip_data" {
  description = "Reserve IP address of the network interface of IBM PowerVS instance."
  type = list(object({
    ip              = string
    name            = string
    pvm_instance_id = string
  }))
}

variable "site1_persistent_ip_data" {
  description = "Persistent IP address of the network interface of IBM PowerVS instance."
  type = list(object({
    ip              = string
    name            = string
    pvm_instance_id = string
  }))
}

variable "site2_persistent_ip_data" {
  description = "Persistent IP address of the network interface of IBM PowerVS instance."
  type = list(object({
    ip              = string
    name            = string
    pvm_instance_id = string
  }))
}
