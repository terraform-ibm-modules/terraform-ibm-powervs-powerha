#####################################################
# Create Private Subnets
#####################################################

## Adding sleep because of PER enabled workspace
## which needs some time to initialize
resource "time_sleep" "wait_30_sec" {
  depends_on      = [module.powervs_workspace]
  create_duration = "30s"
}

resource "ibm_pi_network" "private_subnet_1" {
  depends_on = [time_sleep.wait_30_sec]
  count      = length(var.powervs_subnet_list) > 0 ? 1 : 0

  pi_cloud_instance_id = module.powervs_workspace.pi_workspace_guid
  pi_network_name      = var.powervs_subnet_list[0].name
  pi_cidr              = var.powervs_subnet_list[0].cidr
  pi_network_type      = "vlan"
  pi_network_mtu       = 9000
  pi_ipaddress_range {
    pi_starting_ip_address = cidrhost(var.powervs_subnet_list[0].cidr, 200)
    pi_ending_ip_address   = cidrhost(var.powervs_subnet_list[0].cidr, 254)
  }
}

resource "ibm_pi_network" "private_subnet_2" {
  depends_on = [ibm_pi_network.private_subnet_1]
  count      = length(var.powervs_subnet_list) > 1 ? 1 : 0

  pi_cloud_instance_id = module.powervs_workspace.pi_workspace_guid
  pi_network_name      = var.powervs_subnet_list[1].name
  pi_cidr              = var.powervs_subnet_list[1].cidr
  pi_network_type      = "vlan"
  pi_network_mtu       = 9000
  pi_ipaddress_range {
    pi_starting_ip_address = cidrhost(var.powervs_subnet_list[1].cidr, 200)
    pi_ending_ip_address   = cidrhost(var.powervs_subnet_list[1].cidr, 254)
  }
}

resource "ibm_pi_network" "private_subnet_3" {
  depends_on = [ibm_pi_network.private_subnet_2]
  count      = length(var.powervs_subnet_list) > 2 ? 1 : 0

  pi_cloud_instance_id = module.powervs_workspace.pi_workspace_guid
  pi_network_name      = var.powervs_subnet_list[2].name
  pi_cidr              = var.powervs_subnet_list[2].cidr
  pi_network_type      = "vlan"
  pi_network_mtu       = 9000
  pi_ipaddress_range {
    pi_starting_ip_address = cidrhost(var.powervs_subnet_list[2].cidr, 200)
    pi_ending_ip_address   = cidrhost(var.powervs_subnet_list[2].cidr, 254)
  }
}

resource "ibm_pi_network" "private_subnet_4" {
  depends_on = [ibm_pi_network.private_subnet_3]
  count      = length(var.powervs_subnet_list) > 3 ? 1 : 0

  pi_cloud_instance_id = module.powervs_workspace.pi_workspace_guid
  pi_network_name      = var.powervs_subnet_list[3].name
  pi_cidr              = var.powervs_subnet_list[3].cidr
  pi_network_type      = "vlan"
  pi_network_mtu       = 9000
  pi_ipaddress_range {
    pi_starting_ip_address = cidrhost(var.powervs_subnet_list[3].cidr, 200)
    pi_ending_ip_address   = cidrhost(var.powervs_subnet_list[3].cidr, 254)
  }
}

resource "ibm_pi_network" "private_subnet_5" {
  depends_on = [ibm_pi_network.private_subnet_4]
  count      = length(var.powervs_subnet_list) > 4 ? 1 : 0

  pi_cloud_instance_id = module.powervs_workspace.pi_workspace_guid
  pi_network_name      = var.powervs_subnet_list[4].name
  pi_cidr              = var.powervs_subnet_list[4].cidr
  pi_network_type      = "vlan"
  pi_network_mtu       = 9000
  pi_ipaddress_range {
    pi_starting_ip_address = cidrhost(var.powervs_subnet_list[4].cidr, 200)
    pi_ending_ip_address   = cidrhost(var.powervs_subnet_list[4].cidr, 254)
  }
}

resource "ibm_pi_network" "private_subnet_6" {
  depends_on = [ibm_pi_network.private_subnet_5]
  count      = length(var.powervs_subnet_list) > 5 ? 1 : 0

  pi_cloud_instance_id = module.powervs_workspace.pi_workspace_guid
  pi_network_name      = var.powervs_subnet_list[5].name
  pi_cidr              = var.powervs_subnet_list[5].cidr
  pi_network_type      = "vlan"
  pi_network_mtu       = 9000
  pi_ipaddress_range {
    pi_starting_ip_address = cidrhost(var.powervs_subnet_list[5].cidr, 200)
    pi_ending_ip_address   = cidrhost(var.powervs_subnet_list[5].cidr, 254)
  }
}





resource "ibm_pi_network" "private_subnet_7" {
  depends_on = [ibm_pi_network.private_subnet_6]
  count      = length(var.powervs_subnet_list) > 6 ? 1 : 0

  pi_cloud_instance_id = module.powervs_workspace.pi_workspace_guid
  pi_network_name      = var.powervs_subnet_list[6].name
  pi_cidr              = var.powervs_subnet_list[6].cidr
  pi_network_type      = "vlan"
  pi_network_mtu       = 9000
  pi_ipaddress_range {
    pi_starting_ip_address = cidrhost(var.powervs_subnet_list[6].cidr, 200)
    pi_ending_ip_address   = cidrhost(var.powervs_subnet_list[6].cidr, 254)
  }
}

resource "ibm_pi_network" "private_subnet_8" {
  depends_on = [ibm_pi_network.private_subnet_7]
  count      = length(var.powervs_subnet_list) > 7 ? 1 : 0

  pi_cloud_instance_id = module.powervs_workspace.pi_workspace_guid
  pi_network_name      = var.powervs_subnet_list[7].name
  pi_cidr              = var.powervs_subnet_list[7].cidr
  pi_network_type      = "vlan"
  pi_network_mtu       = 9000
  pi_ipaddress_range {
    pi_starting_ip_address = cidrhost(var.powervs_subnet_list[7].cidr, 200)
    pi_ending_ip_address   = cidrhost(var.powervs_subnet_list[7].cidr, 254)
  }
}

resource "ibm_pi_network" "private_subnet_9" {
  depends_on = [ibm_pi_network.private_subnet_8]
  count      = length(var.powervs_subnet_list) > 8 ? 1 : 0

  pi_cloud_instance_id = module.powervs_workspace.pi_workspace_guid
  pi_network_name      = var.powervs_subnet_list[8].name
  pi_cidr              = var.powervs_subnet_list[8].cidr
  pi_network_type      = "vlan"
  pi_network_mtu       = 9000
  pi_ipaddress_range {
    pi_starting_ip_address = cidrhost(var.powervs_subnet_list[8].cidr, 200)
    pi_ending_ip_address   = cidrhost(var.powervs_subnet_list[8].cidr, 254)
  }
}

resource "ibm_pi_network" "private_subnet_10" {
  depends_on = [ibm_pi_network.private_subnet_9]
  count      = length(var.powervs_subnet_list) > 9 ? 1 : 0

  pi_cloud_instance_id = module.powervs_workspace.pi_workspace_guid
  pi_network_name      = var.powervs_subnet_list[9].name
  pi_cidr              = var.powervs_subnet_list[9].cidr
  pi_network_type      = "vlan"
  pi_network_mtu       = 9000
  pi_ipaddress_range {
    pi_starting_ip_address = cidrhost(var.powervs_subnet_list[9].cidr, 200)
    pi_ending_ip_address   = cidrhost(var.powervs_subnet_list[9].cidr, 254)
  }
}

resource "ibm_pi_network" "private_subnet_11" {
  depends_on = [ibm_pi_network.private_subnet_10]
  count      = length(var.powervs_subnet_list) > 10 ? 1 : 0

  pi_cloud_instance_id = module.powervs_workspace.pi_workspace_guid
  pi_network_name      = var.powervs_subnet_list[10].name
  pi_cidr              = var.powervs_subnet_list[10].cidr
  pi_network_type      = "vlan"
  pi_network_mtu       = 9000
  pi_ipaddress_range {
    pi_starting_ip_address = cidrhost(var.powervs_subnet_list[10].cidr, 200)
    pi_ending_ip_address   = cidrhost(var.powervs_subnet_list[10].cidr, 254)
  }
}

resource "ibm_pi_network" "private_subnet_12" {
  depends_on = [ibm_pi_network.private_subnet_11]
  count      = length(var.powervs_subnet_list) > 11 ? 1 : 0

  pi_cloud_instance_id = module.powervs_workspace.pi_workspace_guid
  pi_network_name      = var.powervs_subnet_list[11].name
  pi_cidr              = var.powervs_subnet_list[11].cidr
  pi_network_type      = "vlan"
  pi_network_mtu       = 9000
  pi_ipaddress_range {
    pi_starting_ip_address = cidrhost(var.powervs_subnet_list[11].cidr, 200)
    pi_ending_ip_address   = cidrhost(var.powervs_subnet_list[11].cidr, 254)
  }
}


resource "ibm_pi_network" "private_subnet_13" {
  depends_on = [ibm_pi_network.private_subnet_12]
  count      = length(var.powervs_subnet_list) > 12 ? 1 : 0

  pi_cloud_instance_id = module.powervs_workspace.pi_workspace_guid
  pi_network_name      = var.powervs_subnet_list[12].name
  pi_cidr              = var.powervs_subnet_list[12].cidr
  pi_network_type      = "vlan"
  pi_network_mtu       = 9000
  pi_ipaddress_range {
    pi_starting_ip_address = cidrhost(var.powervs_subnet_list[12].cidr, 200)
    pi_ending_ip_address   = cidrhost(var.powervs_subnet_list[12].cidr, 254)
  }
}

resource "ibm_pi_network" "private_subnet_14" {
  depends_on = [ibm_pi_network.private_subnet_13]
  count      = length(var.powervs_subnet_list) > 13 ? 1 : 0

  pi_cloud_instance_id = module.powervs_workspace.pi_workspace_guid
  pi_network_name      = var.powervs_subnet_list[13].name
  pi_cidr              = var.powervs_subnet_list[13].cidr
  pi_network_type      = "vlan"
  pi_network_mtu       = 9000
  pi_ipaddress_range {
    pi_starting_ip_address = cidrhost(var.powervs_subnet_list[13].cidr, 200)
    pi_ending_ip_address   = cidrhost(var.powervs_subnet_list[13].cidr, 254)
  }
}

resource "ibm_pi_network" "private_subnet_15" {
  depends_on = [ibm_pi_network.private_subnet_14]
  count      = length(var.powervs_subnet_list) > 14 ? 1 : 0

  pi_cloud_instance_id = module.powervs_workspace.pi_workspace_guid
  pi_network_name      = var.powervs_subnet_list[14].name
  pi_cidr              = var.powervs_subnet_list[14].cidr
  pi_network_type      = "vlan"
  pi_network_mtu       = 9000
  pi_ipaddress_range {
    pi_starting_ip_address = cidrhost(var.powervs_subnet_list[14].cidr, 200)
    pi_ending_ip_address   = cidrhost(var.powervs_subnet_list[14].cidr, 254)
  }
}

resource "ibm_pi_network" "private_subnet_16" {
  depends_on = [ibm_pi_network.private_subnet_15]
  count      = length(var.powervs_subnet_list) > 15 ? 1 : 0

  pi_cloud_instance_id = module.powervs_workspace.pi_workspace_guid
  pi_network_name      = var.powervs_subnet_list[15].name
  pi_cidr              = var.powervs_subnet_list[15].cidr
  pi_network_type      = "vlan"
  pi_network_mtu       = 9000
  pi_ipaddress_range {
    pi_starting_ip_address = cidrhost(var.powervs_subnet_list[15].cidr, 200)
    pi_ending_ip_address   = cidrhost(var.powervs_subnet_list[15].cidr, 254)
  }
}


#####################################################
# Created Network List
#####################################################

locals {
  powervs_subnets = slice([
    length(ibm_pi_network.private_subnet_1) > 0 ? ibm_pi_network.private_subnet_1[0] : null,
    length(ibm_pi_network.private_subnet_2) > 0 ? ibm_pi_network.private_subnet_2[0] : null,
    length(ibm_pi_network.private_subnet_3) > 0 ? ibm_pi_network.private_subnet_3[0] : null,
    length(ibm_pi_network.private_subnet_4) > 0 ? ibm_pi_network.private_subnet_4[0] : null,
    length(ibm_pi_network.private_subnet_5) > 0 ? ibm_pi_network.private_subnet_5[0] : null,
    length(ibm_pi_network.private_subnet_6) > 0 ? ibm_pi_network.private_subnet_6[0] : null,
    length(ibm_pi_network.private_subnet_7) > 0 ? ibm_pi_network.private_subnet_7[0] : null,
    length(ibm_pi_network.private_subnet_8) > 0 ? ibm_pi_network.private_subnet_8[0] : null,
    length(ibm_pi_network.private_subnet_9) > 0 ? ibm_pi_network.private_subnet_9[0] : null,
    length(ibm_pi_network.private_subnet_10) > 0 ? ibm_pi_network.private_subnet_10[0] : null,
    length(ibm_pi_network.private_subnet_11) > 0 ? ibm_pi_network.private_subnet_11[0] : null,
    length(ibm_pi_network.private_subnet_12) > 0 ? ibm_pi_network.private_subnet_12[0] : null,
    length(ibm_pi_network.private_subnet_13) > 0 ? ibm_pi_network.private_subnet_13[0] : null,
    length(ibm_pi_network.private_subnet_14) > 0 ? ibm_pi_network.private_subnet_14[0] : null,
    length(ibm_pi_network.private_subnet_15) > 0 ? ibm_pi_network.private_subnet_15[0] : null,
    length(ibm_pi_network.private_subnet_16) > 0 ? ibm_pi_network.private_subnet_16[0] : null
  ], 0, length(var.powervs_subnet_list))

  pi_private_subnet_ids = [for subnet in local.powervs_subnets : subnet.network_id if subnet != null]
}
