
#################################################
# Attach PowerVS Subnets to CCs
#################################################

data "ibm_pi_cloud_connections" "cloud_connection_ds" {
  pi_cloud_instance_id = var.powervs_workspace_guid
}

################################################################
# Attach 16 private subnets to First Cloud Connection
################################################################

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_network_attach_1" {
  depends_on = [data.ibm_pi_cloud_connections.cloud_connection_ds]
  count      = var.cloud_connection_count > 0 && length(var.private_subnet_ids) > 0 ? 1 : 0

  pi_cloud_instance_id   = var.powervs_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[0].cloud_connection_id
  pi_network_id          = var.private_subnet_ids[0]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_network_attach_2" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_network_attach_1]
  count      = var.cloud_connection_count > 0 && length(var.private_subnet_ids) > 1 ? 1 : 0

  pi_cloud_instance_id   = var.powervs_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[0].cloud_connection_id
  pi_network_id          = var.private_subnet_ids[1]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_network_attach_3" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_network_attach_2]
  count      = var.cloud_connection_count > 0 && length(var.private_subnet_ids) > 2 ? 1 : 0

  pi_cloud_instance_id   = var.powervs_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[0].cloud_connection_id
  pi_network_id          = var.private_subnet_ids[2]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_network_attach_4" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_network_attach_3]
  count      = var.cloud_connection_count > 0 && length(var.private_subnet_ids) > 3 ? 1 : 0

  pi_cloud_instance_id   = var.powervs_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[0].cloud_connection_id
  pi_network_id          = var.private_subnet_ids[3]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_network_attach_5" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_network_attach_4]
  count      = var.cloud_connection_count > 0 && length(var.private_subnet_ids) > 4 ? 1 : 0

  pi_cloud_instance_id   = var.powervs_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[0].cloud_connection_id
  pi_network_id          = var.private_subnet_ids[4]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_network_attach_6" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_network_attach_5]
  count      = var.cloud_connection_count > 0 && length(var.private_subnet_ids) > 5 ? 1 : 0

  pi_cloud_instance_id   = var.powervs_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[0].cloud_connection_id
  pi_network_id          = var.private_subnet_ids[5]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_network_attach_7" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_network_attach_6]
  count      = var.cloud_connection_count > 0 && length(var.private_subnet_ids) > 6 ? 1 : 0

  pi_cloud_instance_id   = var.powervs_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[0].cloud_connection_id
  pi_network_id          = var.private_subnet_ids[6]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_network_attach_8" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_network_attach_7]
  count      = var.cloud_connection_count > 0 && length(var.private_subnet_ids) > 7 ? 1 : 0

  pi_cloud_instance_id   = var.powervs_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[0].cloud_connection_id
  pi_network_id          = var.private_subnet_ids[7]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_network_attach_9" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_network_attach_8]
  count      = var.cloud_connection_count > 0 && length(var.private_subnet_ids) > 8 ? 1 : 0

  pi_cloud_instance_id   = var.powervs_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[0].cloud_connection_id
  pi_network_id          = var.private_subnet_ids[8]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_network_attach_10" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_network_attach_9]
  count      = var.cloud_connection_count > 0 && length(var.private_subnet_ids) > 9 ? 1 : 0

  pi_cloud_instance_id   = var.powervs_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[0].cloud_connection_id
  pi_network_id          = var.private_subnet_ids[9]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_network_attach_11" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_network_attach_10]
  count      = var.cloud_connection_count > 0 && length(var.private_subnet_ids) > 10 ? 1 : 0

  pi_cloud_instance_id   = var.powervs_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[0].cloud_connection_id
  pi_network_id          = var.private_subnet_ids[10]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_network_attach_12" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_network_attach_11]
  count      = var.cloud_connection_count > 0 && length(var.private_subnet_ids) > 11 ? 1 : 0

  pi_cloud_instance_id   = var.powervs_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[0].cloud_connection_id
  pi_network_id          = var.private_subnet_ids[11]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_network_attach_13" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_network_attach_12]
  count      = var.cloud_connection_count > 0 && length(var.private_subnet_ids) > 12 ? 1 : 0

  pi_cloud_instance_id   = var.powervs_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[0].cloud_connection_id
  pi_network_id          = var.private_subnet_ids[12]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_network_attach_14" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_network_attach_13]
  count      = var.cloud_connection_count > 0 && length(var.private_subnet_ids) > 13 ? 1 : 0

  pi_cloud_instance_id   = var.powervs_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[0].cloud_connection_id
  pi_network_id          = var.private_subnet_ids[13]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_network_attach_15" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_network_attach_14]
  count      = var.cloud_connection_count > 0 && length(var.private_subnet_ids) > 14 ? 1 : 0

  pi_cloud_instance_id   = var.powervs_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[0].cloud_connection_id
  pi_network_id          = var.private_subnet_ids[14]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_network_attach_16" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_network_attach_15]
  count      = var.cloud_connection_count > 0 && length(var.private_subnet_ids) > 15 ? 1 : 0

  pi_cloud_instance_id   = var.powervs_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[0].cloud_connection_id
  pi_network_id          = var.private_subnet_ids[15]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}


resource "time_sleep" "wait_for_second_cloud_connection_network_attach" {
  depends_on      = [ibm_pi_cloud_connection_network_attach.private_subnet_network_attach_16]
  count           = var.cloud_connection_count > 1 ? 1 : 0
  create_duration = "30s"
}


#################################################################
# Attach 16 private subnets to Second Cloud Connection
#################################################################

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_network_attach_1_redundant" {
  depends_on = [time_sleep.wait_for_second_cloud_connection_network_attach]
  count      = var.cloud_connection_count > 1 && length(var.private_subnet_ids) > 0 ? 1 : 0

  pi_cloud_instance_id   = var.powervs_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[1].cloud_connection_id
  pi_network_id          = var.private_subnet_ids[0]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_network_attach_2_redundant" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_network_attach_1_redundant]
  count      = var.cloud_connection_count > 1 && length(var.private_subnet_ids) > 1 ? 1 : 0

  pi_cloud_instance_id   = var.powervs_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[1].cloud_connection_id
  pi_network_id          = var.private_subnet_ids[1]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_network_attach_3_redundant" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_network_attach_2_redundant]
  count      = var.cloud_connection_count > 1 && length(var.private_subnet_ids) > 2 ? 1 : 0

  pi_cloud_instance_id   = var.powervs_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[1].cloud_connection_id
  pi_network_id          = var.private_subnet_ids[2]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_network_attach_4_redundant" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_network_attach_3_redundant]
  count      = var.cloud_connection_count > 1 && length(var.private_subnet_ids) > 3 ? 1 : 0

  pi_cloud_instance_id   = var.powervs_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[1].cloud_connection_id
  pi_network_id          = var.private_subnet_ids[3]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_network_attach_5_redundant" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_network_attach_4_redundant]
  count      = var.cloud_connection_count > 1 && length(var.private_subnet_ids) > 4 ? 1 : 0

  pi_cloud_instance_id   = var.powervs_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[1].cloud_connection_id
  pi_network_id          = var.private_subnet_ids[4]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_network_attach_6_redundant" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_network_attach_5_redundant]
  count      = var.cloud_connection_count > 1 && length(var.private_subnet_ids) > 5 ? 1 : 0

  pi_cloud_instance_id   = var.powervs_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[1].cloud_connection_id
  pi_network_id          = var.private_subnet_ids[5]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_network_attach_7_redundant" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_network_attach_6_redundant]
  count      = var.cloud_connection_count > 1 && length(var.private_subnet_ids) > 6 ? 1 : 0

  pi_cloud_instance_id   = var.powervs_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[1].cloud_connection_id
  pi_network_id          = var.private_subnet_ids[6]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_network_attach_8_redundant" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_network_attach_7_redundant]
  count      = var.cloud_connection_count > 1 && length(var.private_subnet_ids) > 7 ? 1 : 0

  pi_cloud_instance_id   = var.powervs_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[1].cloud_connection_id
  pi_network_id          = var.private_subnet_ids[7]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_network_attach_9_redundant" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_network_attach_8_redundant]
  count      = var.cloud_connection_count > 1 && length(var.private_subnet_ids) > 8 ? 1 : 0

  pi_cloud_instance_id   = var.powervs_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[1].cloud_connection_id
  pi_network_id          = var.private_subnet_ids[8]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_network_attach_10_redundant" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_network_attach_9_redundant]
  count      = var.cloud_connection_count > 1 && length(var.private_subnet_ids) > 9 ? 1 : 0

  pi_cloud_instance_id   = var.powervs_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[1].cloud_connection_id
  pi_network_id          = var.private_subnet_ids[9]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_network_attach_11_redundant" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_network_attach_10_redundant]
  count      = var.cloud_connection_count > 1 && length(var.private_subnet_ids) > 10 ? 1 : 0

  pi_cloud_instance_id   = var.powervs_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[1].cloud_connection_id
  pi_network_id          = var.private_subnet_ids[10]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_network_attach_12_redundant" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_network_attach_11_redundant]
  count      = var.cloud_connection_count > 1 && length(var.private_subnet_ids) > 11 ? 1 : 0

  pi_cloud_instance_id   = var.powervs_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[1].cloud_connection_id
  pi_network_id          = var.private_subnet_ids[11]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_network_attach_13_redundant" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_network_attach_12_redundant]
  count      = var.cloud_connection_count > 1 && length(var.private_subnet_ids) > 12 ? 1 : 0

  pi_cloud_instance_id   = var.powervs_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[1].cloud_connection_id
  pi_network_id          = var.private_subnet_ids[12]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_network_attach_14_redundant" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_network_attach_13_redundant]
  count      = var.cloud_connection_count > 1 && length(var.private_subnet_ids) > 13 ? 1 : 0

  pi_cloud_instance_id   = var.powervs_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[1].cloud_connection_id
  pi_network_id          = var.private_subnet_ids[13]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_network_attach_15_redundant" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_network_attach_14_redundant]
  count      = var.cloud_connection_count > 1 && length(var.private_subnet_ids) > 14 ? 1 : 0

  pi_cloud_instance_id   = var.powervs_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[1].cloud_connection_id
  pi_network_id          = var.private_subnet_ids[14]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}

resource "ibm_pi_cloud_connection_network_attach" "private_subnet_network_attach_16_redundant" {
  depends_on = [ibm_pi_cloud_connection_network_attach.private_subnet_network_attach_15_redundant]
  count      = var.cloud_connection_count > 1 && length(var.private_subnet_ids) > 15 ? 1 : 0

  pi_cloud_instance_id   = var.powervs_workspace_guid
  pi_cloud_connection_id = data.ibm_pi_cloud_connections.cloud_connection_ds.connections[1].cloud_connection_id
  pi_network_id          = var.private_subnet_ids[15]
  lifecycle {
    ignore_changes = [pi_cloud_connection_id]
  }
}
