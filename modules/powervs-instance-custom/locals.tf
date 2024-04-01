locals {
  shared_volume_size         = 10
  shared_volume_storage_type = "tier3"
  dedicated_volume_size      = 10
  default_pi_storage_config = var.pi_dedicated_volume_count > 0 ? [
    { name = "${var.pi_prefix}-extended-volume", size = "80", count = "1", tier = var.pi_storage_type, mount = null },
    { name = "${var.pi_prefix}-volume", size = local.dedicated_volume_size, count = var.pi_dedicated_volume_count, tier = local.shared_volume_storage_type, mount = null }
    ] : [
    { name = "${var.pi_prefix}-extended-volume", size = "80", count = "1", tier = var.pi_storage_type, mount = null }
  ]


  powervs_instances = slice([module.powervs_instance_node_1, module.powervs_instance_node_2[0],
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


  reserve_ips = [for i, pairs in setproduct(flatten([
    for item in var.powervs_subnet_list : [
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


  # Option 2 to select IP address to reserve
  # ip_range = [for i in range(5,(length(local.powervs_all_instances)*2)*length(var.powervs_subnet_list),2): [i,i+2]]

  # reserve_ips = flatten([for idx, item in local.powervs_all_instances :
  #   [for item1 in var.powervs_subnet_list : [
  #       for i in range(local.ip_range[idx][0], local.ip_range[idx][1]) : {
  #         name = item1.name
  #         ip   = cidrhost(item1.cidr, i)
  #         pvm_instance_id = item.pvm_instance_id
  #       }
  #     ]]
  # ])
}
