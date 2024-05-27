variable "prefix" {
  description = "A unique identifier for resources. This identifier must start with a letter, followed by a combination of letters, numbers, hyphens (-), or underscores (_). It should be between 1 and 8 characters in length. This prefix will be added to any resources created by using this template."
  type        = string
}

variable "powervs_zone" {
  description = "IBM Cloud data center location corresponding to the location used in 'Power Virtual Server with VPC landing zone' pre-requisite deployment."
  type        = string
}

variable "ssh_public_key" {
  description = "Public SSH Key for VSI creation. Must be an RSA key with a key size of either 2048 bits or 4096 bits (recommended). Must be a valid SSH key that does not already exist in the deployment region."
  type        = string
}

variable "ssh_private_key" {
  description = "Private SSH key (RSA format) used to login to IBM Power Virtual Server instances. The private SSH key should match with the public SSH key referenced by the 'ssh_public_key' parameter. The input data must be in heredoc strings format (https://www.terraform.io/language/expressions/strings#heredoc-strings). The private SSH key is not uploaded or stored anywhere. For more information about SSH keys, see [SSH keys](https://cloud.ibm.com/docs/vpc?topic=vpc-ssh-keys)."
  type        = string
  sensitive   = true
}

variable "external_access_ip" {
  description = "Specify the IP address or CIDR to login through SSH to the environment after deployment. Access to this environment will be allowed only from this IP address."
  type        = string
}

variable "powervs_resource_group_name" {
  description = "Existing IBM Cloud resource group name."
  type        = string
}

variable "ibmcloud_api_key" {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources."
  type        = string
  sensitive   = true
}

variable "powervs_instance_count" {
  description = "Number of Power Virtual Server instances required to create in the workspace for PowerHA cluster."
  type        = number
  default     = 2
}

variable "tshirt_size" {
  description = <<EOT
  Power Virtual Server instance profiles. Power Virtual instance will be created based on the following values:
    proc_type: shared
    tier: tier1 (This value is the same for all profiles)
  EOT
  type        = string
  default     = "aix_xs"
}

variable "powervs_machine_type" {
  description = <<EOT
  IBM Powervs machine type. The supported machine types are: s922, e980, s1022, e1080.
  For more details:
    [Availability of the machine type](https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-creating-power-virtual-server#creating-service)
    [IBM Cloud PowerVS documentation](https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-getting-started)
  EOT
  type        = string
  default     = "s922"
}

variable "aix_os_image" {
  description = "AIX operating system images for Power Virtual Server instances. Power Virtual Server instances are installed with the given AIX OS image."
  type        = string
  default     = "7300-02-01"
}

variable "powervs_subnet_list" {
  description = "IBM Cloud Power Virtual Server subnet configuration details like name and CIDR."
  type = list(object({
    name = string
    cidr = string
  }))
  default = [{ cidr = "10.68.15.0/24", name = "network_1" }]
}

variable "powervs_reserve_subnet_list" {
  description = "IBM Cloud Power Virtual Server subnet configuration details like name, CIDR, and reserved IP count used for PowerHA Service Label to be created. Ensure no duplicate subnet names or CIDRs, and reserved_ip_count must be greater than 0."
  type = list(object({
    name              = string
    cidr              = string
    reserved_ip_count = number
  }))
  default = [{ cidr = "10.65.18.0/24", name = "reserve_net", reserved_ip_count = 1 }]
}

variable "dedicated_volume" {
  description = "Count of dedicated volumes that need to be created and attached to every Power Virtual Server instance separately."
  type        = number
  default     = 0
}

variable "shared_volume" {
  description = "Count of shared volumes that need to created and attached to every Power Virtual Server instances."
  type        = number
  default     = 1
}

#####################################################
# Optional Parameters
#####################################################

variable "configure_dns_forwarder" {
  description = "Specify if DNS forwarder will be configured. This will allow you to use central DNS servers (e.g. IBM Cloud DNS servers) sitting outside of the created IBM PowerVS infrastructure. If yes, ensure 'dns_forwarder_config' optional variable is set properly. DNS forwarder will be installed on the private-svs vsi."
  type        = bool
  default     = true
}

variable "configure_ntp_forwarder" {
  description = "Specify if NTP forwarder will be configured. This will allow you to synchronize time between IBM PowerVS instances. NTP forwarder will be installed on the private-svs vsi."
  type        = bool
  default     = true
}

variable "configure_nfs_server" {
  description = "Specify if NFS server will be configured. This will allow you easily to share files between PowerVS instances (e.g., SAP installation files). NFS server will be installed on the private-svs vsi. If yes, ensure 'nfs_server_config' optional variable is set properly below. Default value is 1TB which will be mounted on /nfs."
  type        = bool
  default     = true
}

variable "custom_profile" {
  description = "Overrides t-shirt profile: Custom PowerVS instance. Specify combination of cores, memory, proc_type and storage tier."
  type = object({
    cores     = number
    memory    = number
    proc_type = string
    tier      = string
  })
  default = {
    "cores" : 0.25,
    "memory" : 4,
    "proc_type" : "shared",
    "tier" : "tier1"
  }
}

variable "dedicated_volume_attributes" {
  description = "Size(In GB) of dedicated volumes that need to be created and attached to every Power Virtual Server instance separately."
  type = object({
    size = number
    tier = string
  })
  default = {
    size : 30,
    tier : "tier3"
  }
}

variable "shared_volume_attributes" {
  description = "Size(In GB) of shared volumes that need to be created and attached to every Power Virtual Server instance separately."
  type = object({
    size = number
    tier = string
  })
  default = {
    size : 30,
    tier : "tier3"
  }
}
