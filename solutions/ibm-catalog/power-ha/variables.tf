variable "ibmcloud_api_key" {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources."
  type        = string
  sensitive   = true
}

variable "prerequisite_workspace_id" {
  description = "IBM Cloud Schematics workspace ID of an existing 'Power Virtual Server with VPC landing zone' catalog solution. If you do not yet have an existing deployment, click [here](https://cloud.ibm.com/catalog/architecture/deploy-arch-ibm-pvs-inf-2dd486c7-b317-4aaa-907b-42671485ad96-global?) to create one."
  type        = string
}

variable "powervs_zone" {
  description = "IBM Cloud data center location corresponding to the location used in 'Power Virtual Server with VPC landing zone' pre-requisite deployment."
  type        = string
}

variable "powervs_cluster_nodes" {
  description = "Number of PowerVS instances in the cluster."
  type        = number
}

variable "powervs_os_image" {
  description = "Aix image name to use for all instances"
  type        = string
}

variable "powervs_boot_image_storage_tier" {
  description = "Storage type for server deployment; Possible values tier0, tier1 and tier3"
  type        = string
}

variable "powervs_cluster_name" {
  description = "Cluster name for all instances which will be created."
  type        = string
}

variable "powervs_server_type" {
  description = "Processor type e980/s922/e1080/s1022."
  type        = string
}

variable "powervs_cpu_proc_type" {
  description = "Dedicated, shared or capped processors."
  type        = string
}

variable "powervs_number_of_processors" {
  description = "Number of processors."
  type        = string
}

variable "powervs_memory_size" {
  description = "Amount of memory in GB."
  type        = string
}

variable "powervs_shareable_volumes" {
  description = "Shareable volumes to be created and attached to the cluster nodes"
  type = list(object({
    name = string
    size = string
    tier = string
  }))
}

variable "powervs_dedicated_filesystem_config" {
  description = "Custom File systems to be created and attached to PowerVS instance. 'disk_size' is in GB. 'count' specify over how many storage volumes the file system will be striped. 'tier' specifies the storage tier in PowerVS workspace. 'mount' specifies the mount point on the OS."
  type = list(object({
    name  = string
    size  = string
    count = string
    tier  = string
    mount = string
  }))
}
