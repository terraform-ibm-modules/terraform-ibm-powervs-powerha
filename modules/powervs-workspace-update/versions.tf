#####################################################
# PowerVS workspace extension
#####################################################

terraform {
  required_version = ">= 1.3"
  required_providers {
    ibm = {
      source                = "IBM-Cloud/ibm"
      version               = ">=1.64.1"
      configuration_aliases = [ibm]
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9.1"
    }
  }
}
