#####################################################
# Import Catalog Images
#####################################################

data "ibm_pi_catalog_images" "catalog_images_ds" {
  pi_cloud_instance_id = var.powervs_workspace_guid
}

locals {
  powervs_images = { for image in data.ibm_pi_catalog_images.catalog_images_ds.images : image.name => image.image_id if image.name == var.aix_os_image }
}


#######################################################
# Import required aix image to workspace
#######################################################

resource "ibm_pi_image" "import_images" {
  count                = var.aix_os_image == null ? 0 : 1
  pi_cloud_instance_id = var.powervs_workspace_guid
  pi_image_id          = local.powervs_images[var.aix_os_image]
  pi_image_name        = var.aix_os_image

  timeouts {
    create = "10m"
  }
}

################
# For output
################

locals {
  pi_images = var.aix_os_image == null ? null : ibm_pi_image.import_images[0].image_id
}
