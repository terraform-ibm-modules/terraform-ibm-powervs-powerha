variable "prefix" {
  description = "A unique identifier for resources. The identifier must begin with a lowercase letter and end with a lowercase letter or a number. This prefix will be prepended to any resources provisioned by this template. Prefix must be 8 characters or fewer than 8 characters."
  type        = string
}

variable "powervs_zone" {
  description = "IBM Cloud data center location corresponding to the location used in 'Power Virtual Server with VPC landing zone' pre-requisite deployment."
  type        = string
}

variable "landing_zone_configuration" {
  description = "VPC landing zone configuration."
  type        = string

  validation {
    condition     = contains(["3VPC_RHEL", "3VPC_SLES", "1VPC_RHEL"], var.landing_zone_configuration)
    error_message = "Provided value must be one of ['3VPC_RHEL', '3VPC_SLES', '1VPC_RHEL'] only"
  }
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
  description = "AIX operating system images for Power Virtual Server instances. Power Virtual Server instances are installed with the given AIX OS image. The supported AIX OS images are: 7300-02-01, 7300-00-01, 7200-05-06."
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
  description = "IBM Cloud Power Virtual Server subnet configuration details like name, CIDR, and reserved IP count used for PowerHA service label to be created."
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

variable "cos_powerha_image_download" {
  description = <<EOT
  Details about cloud object storage bucket where PowerHA installation media folder and ssl file are located. For more details click [here](https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-service-credentials).
  Example:
    {
      "bucket_name":"bucket-name",
      "cos_access_key_id":"1dxxxxxxxxxx36",
      "cos_secret_access_key":"4dxxxxxx5c",
      "cos_endpoint":"https://s3.region.cloud-object-storage.appdomain.cloud",
      "folder_name":"powerha-build-parent-folder-name",
      "ssl_file_name": "ssl-file-path"
    }

  You can keep the PowerHA images in the following format in the IBM Cloud COS Bucket.
  Example: 728 is a parent folder
    728/Gold/<filename>.tar.gz
    728/SPx/<filename>.tar.gz
  EOT
  type = object({
    bucket_name           = string
    cos_access_key_id     = string
    cos_secret_access_key = string
    cos_endpoint          = string
    folder_name           = string
    ssl_file_name         = string
  })
  default = {
    "bucket_name" : "powerha-images",
    "cos_access_key_id" : "21d4d77f64434315ac16801c439e6136",
    "cos_secret_access_key" : "4f4d1c599b4e149241da080092d68fe2e489e221ffcf225c",
    "cos_endpoint" : "https://s3.us-east.cloud-object-storage.appdomain.cloud",
    "folder_name" : "728",
    "ssl_file_name" : "openssl-1.1.2.2200.tar.Z"
  }
}

variable "powerha_resource_group" {
  description = "Number of Resource Groups which need to be created in PowerHA."
  type        = number
  default     = 1
}

variable "volume_group" {
  description = "Number of Volume Groups which need to be created in PowerHA."
  type        = number
  default     = 2
}

variable "file_system" {
  description = "Number of File systems which need to be created in PowerHA."
  type        = number
  default     = 2
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

variable "powerha_resource_group_list" {
  description = "List of parameters for Resource group - Individual PowerHA Resource group configuration. Based on the powerha_resource_group count, you can provide all the resource group configuration like name, start up, fallover and fallback polices. Default configuration will be taken if details are not provided."
  type = list(object({
    name     = string
    startup  = string
    fallover = string
    fallback = string
  }))
  default = [{
    name : "RG1",
    startup : "OHN",
    fallover : "FNPN",
    fallback : "NFB"
  }]
}

variable "volume_group_list" {
  description = "List of parameters for volume group - Individual PowerHA volume group configuration. Based on the volume_group count, you can provide all the volume group configuration like name, resource group name, type, size, tier. Default configuration will be taken if details are not provided."
  type = list(object({
    name    = string
    rg_name = string
    type    = string
    size    = number
    tier    = string
  }))
  default = [
    { "name" : "VG1", "rg_name" : "RG1", "size" : 40, "type" : "original", "tier" : "tier0" },
    { "name" : "VG2", "rg_name" : "RG2", "size" : 50, "type" : "original", "tier" : "tier1" }
  ]
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
  default = [
    { "name" : "fs2", "type" : "enhanced", "volume_group" : "VG1", "units" : "100", "size_per_unit" : "megabytes", "block_size" : "1024" },
    { "name" : "FS1", "type" : "enhanced", "volume_group" : "VG1", "units" : "100", "size_per_unit" : "megabytes", "block_size" : "1024" }
  ]
}
