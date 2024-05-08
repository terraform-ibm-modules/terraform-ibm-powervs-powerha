locals {
  #####################################################
  # Storage Configuration Object Creation
  #####################################################

  default_pi_storage_config = var.dedicated_volume_count > 0 ? [
    { name = "extended-volume", size = "80", count = "1", tier = var.pi_storage_type, mount = null },
    { name = "${var.pi_prefix}-volume", size = var.dedicated_volume_attributes.size, count = var.dedicated_volume_count, tier = var.dedicated_volume_attributes.tier, mount = null }
    ] : [
    { name = "extended-volume", size = "80", count = "1", tier = var.pi_storage_type, mount = null }
  ]


  powervs_instances = slice([module.powervs_instance_node_1,
    length(module.powervs_instance_node_2) > 0 ? module.powervs_instance_node_2[0] : null,
    length(module.powervs_instance_node_3) > 0 ? module.powervs_instance_node_3[0] : null,
    length(module.powervs_instance_node_4) > 0 ? module.powervs_instance_node_4[0] : null,
    length(module.powervs_instance_node_5) > 0 ? module.powervs_instance_node_5[0] : null,
    length(module.powervs_instance_node_6) > 0 ? module.powervs_instance_node_6[0] : null,
    length(module.powervs_instance_node_7) > 0 ? module.powervs_instance_node_7[0] : null,
    length(module.powervs_instance_node_8) > 0 ? module.powervs_instance_node_8[0] : null
  ], 0, var.pi_instance_count)

  powervs_all_instances = [for item in local.powervs_instances :
    { pvm_instance_id = item.pi_instance_instance_id }
  ]


  #####################################################
  # Reserve IP Object Creation
  #####################################################

  reserve_ips = [for i, pairs in setproduct(flatten([
    for item in var.powervs_reserve_subnet_list : [
      for i in range(item.reserved_ip_count) : {
        name = item.name
        ip   = item.cidr
    }]
    ]), [local.powervs_all_instances[0]]) : {
    ip              = cidrhost(pairs[0].ip, i + 5)
    name            = pairs[0].name
    pvm_instance_id = pairs[1].pvm_instance_id
    }
  ]

}
