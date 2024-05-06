locals {
  dst_files_dir                = "/installation_script"
  template_dir                 = "${path.module}/template-files"
  src_script_tftpl_path        = "${local.template_dir}/powervs_installation.sh.tftpl"
  dst_script_file_path         = "${local.dst_files_dir}/install_packages.sh"
  python_cos_path              = "${local.template_dir}/download_files.py"
  src_extend_filesystem        = "${local.template_dir}/extend_filesystems.sh.tftpl"
  dst_extend_filesystem        = "${local.dst_files_dir}/extend_filesystems.sh"
  destination_python_file_path = "download_files.py"
  destination_ansible_yml_file = "/etc/ansible/external_var.yml"
  python_path                  = "/usr/bin/python3"
  nodes_ip                     = var.node_details[*].pi_instance_primary_ip
}


# ##########################################################################
# 1. Extending the rootvg and Increase filesystem sizes
# ##########################################################################

resource "terraform_data" "extend_increase_filesystem" {
  count = length(local.nodes_ip)
  connection {
    type         = "ssh"
    user         = "root"
    bastion_host = var.bastion_host_ip
    host         = local.nodes_ip[count.index]
    private_key  = var.ssh_private_key
    agent        = false
    timeout      = "20m"
  }

  ####### Create Terraform scripts directory ############
  provisioner "remote-exec" {
    inline = ["mkdir -p ${local.dst_files_dir}", "chmod 777 ${local.dst_files_dir}"]
  }

  ####### Copy Template file to target host ############
  provisioner "file" {
    content     = templatefile(local.src_extend_filesystem, { "extend_volume_wwn" = var.node_details[count.index].pi_extend_volume })
    destination = local.dst_extend_filesystem
  }

  ####### Execute script: Extend Filesystems ############
  provisioner "remote-exec" {
    inline = ["chmod +x ${local.dst_extend_filesystem}", local.dst_extend_filesystem]
  }
}


# ##########################################################################
# 2. Package Installation
# ##########################################################################

resource "terraform_data" "install_packages" {
  depends_on = [terraform_data.extend_increase_filesystem]
  count      = length(local.nodes_ip)
  connection {
    type         = "ssh"
    user         = "root"
    bastion_host = var.bastion_host_ip
    host         = local.nodes_ip[count.index]
    private_key  = var.ssh_private_key
    agent        = false
    timeout      = "20m"
  }

  provisioner "file" {
    content     = var.ssh_private_key
    destination = "/.ssh/private_key.pem"
  }

  ####### Copy Template file to target host ############
  provisioner "file" {
    content     = templatefile(local.src_script_tftpl_path, { "proxy_ip_and_port" = var.proxy_ip_and_port })
    destination = local.dst_script_file_path
  }

  ####### Execute script: Install packages ############
  provisioner "remote-exec" {
    inline = ["chmod 700 /.ssh/private_key.pem", "chmod +x ${local.dst_script_file_path}", local.dst_script_file_path]
  }
}


# ##########################################################################
# 3. Download powerha filesets
# ##########################################################################

resource "terraform_data" "download_pha" {
  depends_on = [terraform_data.install_packages]
  count      = length(local.nodes_ip)
  connection {
    type         = "ssh"
    user         = "root"
    bastion_host = var.bastion_host_ip
    host         = local.nodes_ip[count.index]
    private_key  = var.ssh_private_key
    agent        = false
    timeout      = "20m"
  }

  ####### Copy Template file to target host ############
  provisioner "file" {
    source      = local.python_cos_path
    destination = local.destination_python_file_path
  }

  provisioner "remote-exec" {
    inline = [
      "export http_proxy='${var.proxy_ip_and_port}' ",
      "export https_proxy='${var.proxy_ip_and_port}' ",
      "chmod +x ${local.destination_python_file_path}",
      "${local.python_path} ${local.destination_python_file_path} 'pha' ${var.pha_cos_data.bucket_name} ${var.pha_cos_data.folder_name} ${var.pha_cos_data.cos_endpoint} ${var.pha_cos_data.cos_access_key_id} ${var.pha_cos_data.cos_secret_access_key}"
    ]
  }
}


locals {
  src_ansible_tar_file  = "${path.module}/ansible/ansible_powerha_tarball.tar.gz"
  dest_ansible_tar_file = "ansible_powerha_tarball.tar.gz"
  pha_build_path        = "/${var.pha_cos_data.folder_name}/pha/"
}


# ##########################################################################
# 4. Download ansible filesets : After galaxy we need to modify it
# ##########################################################################

resource "terraform_data" "download_ansible" {
  depends_on = [terraform_data.install_packages]
  count      = length(local.nodes_ip)
  connection {
    type         = "ssh"
    user         = "root"
    bastion_host = var.bastion_host_ip
    host         = local.nodes_ip[count.index]
    private_key  = var.ssh_private_key
    agent        = false
    timeout      = "20m"
  }

  provisioner "file" {
    source      = local.src_ansible_tar_file
    destination = local.dest_ansible_tar_file
  }

  provisioner "remote-exec" {
    inline = [
      "gunzip -c ${local.dest_ansible_tar_file} | tar -xvf -"
    ]
  }
}


# #########################################################################
# 5. Creating ansible configuration files locally
# #########################################################################

resource "terraform_data" "ansible_hosts" {
  depends_on = [
    terraform_data.download_ansible,
    terraform_data.download_pha
  ]

  provisioner "local-exec" {
    command = <<-EOT
      cat <<EOF > ${local.template_dir}/host
      [powerha_remote_servers]
      ${join("\n", local.nodes_ip)}
      [powerha_remote_servers:vars]
      ansible_user='root'
      ansible_python_interpreter= '${local.python_path}'
      ansible_ssh_private_key_file= '/.ssh/private_key.pem'
      EOF
          EOT
  }
}


# # #########################################################################
# # 6. Copy host and ansible_config.py files to the remote machine
# #    Create ansible.yml file using ansible_config.py
# # #########################################################################

# resource "terraform_data" "copy_files_to_remote" {
#   depends_on = [
#     terraform_data.download_ansible,
#     terraform_data.download_pha,
#     terraform_data.ansible_hosts
#   ]
#   connection {
#     type         = "ssh"
#     user         = "root"
#     bastion_host = var.bastion_host_ip
#     host         = local.nodes_ip[0]
#     private_key  = var.ssh_private_key
#     agent        = false
#     timeout      = "20m"
#   }

#   provisioner "file" {
#     source      = "${local.template_dir}/host"
#     destination = "/etc/ansible/hosts"
#   }

#   provisioner "file" {
#     content = templatefile("${local.template_dir}/ansible_config.py.tftpl", { "rg_count" = var.powerha_resource_group_count, "rg_list" = jsonencode(var.powerha_resource_group_list),
#       "vg_count"             = var.volume_group_count, "vg_list" = jsonencode(var.volume_group_list),
#       "fs_count"             = var.file_system_count, "fs_list" = jsonencode(var.file_system_list),
#       "repository_disk_wwn"  = jsonencode(var.repository_disk_wwn),
#       "shared_wwn_disks"     = jsonencode(var.shared_disk_wwns), "node_details" = jsonencode(var.node_details),
#       "subnet_list"          = jsonencode(var.subnet_list), "reserve_ip_data" = jsonencode(var.reserve_ip_data),
#       "reserved_subnet_list" = jsonencode(var.reserved_subnet_list),
#     "pha_build_path" = jsonencode(local.pha_build_path), "destination_ansible_yml_file" = jsonencode(local.destination_ansible_yml_file) })
#     destination = "ansible_config.py"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "chmod +x ansible_config.py",
#       "${local.python_path} ansible_config.py"
#     ]
#   }
# }


# # #########################################################################
# # 7. Executing Ansible Playbook to the remote machine
# # #########################################################################

# resource "terraform_data" "ansible_playbook_execution" {
#   depends_on = [
#     terraform_data.download_ansible,
#     terraform_data.download_pha,
#     terraform_data.ansible_hosts,
#     terraform_data.copy_files_to_remote
#   ]
#   connection {
#     type         = "ssh"
#     user         = "root"
#     bastion_host = var.bastion_host_ip
#     host         = local.nodes_ip[0]
#     private_key  = var.ssh_private_key
#     agent        = false
#     timeout      = "20m"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "cd /.ansible/collections/ansible_collections/ibm/power_ha/playbooks",
#       "/opt/freeware/bin/ansible-playbook -i /etc/ansible/hosts demo_map_hosts.yml"
#     ]
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "cd /.ansible/collections/ansible_collections/ibm/power_ha/playbooks",
#       "/opt/freeware/bin/ansible-playbook -i /etc/ansible/hosts demo_PowerHA.yml --tags install"
#     ]
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "cd /.ansible/collections/ansible_collections/ibm/power_ha/playbooks",
#       "/opt/freeware/bin/ansible-playbook -i /etc/ansible/hosts demo_cluster.yml --tags standard"
#     ]
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "cd /.ansible/collections/ansible_collections/ibm/power_ha/playbooks",
#       "/opt/freeware/bin/ansible-playbook -i /etc/ansible/hosts demo_network.yml --tags create"
#     ]
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "cd /.ansible/collections/ansible_collections/ibm/power_ha/playbooks",
#       "/opt/freeware/bin/ansible-playbook -i /etc/ansible/hosts demo_interface.yml --tags create"
#     ]
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "cd /.ansible/collections/ansible_collections/ibm/power_ha/playbooks",
#       "/opt/freeware/bin/ansible-playbook -i /etc/ansible/hosts demo_service_ip.yml --tags create"
#     ]
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "cd /.ansible/collections/ansible_collections/ibm/power_ha/playbooks",
#       "/opt/freeware/bin/ansible-playbook -i /etc/ansible/hosts demo_resource_group.yml --tags create"

#     ]
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "cd /.ansible/collections/ansible_collections/ibm/power_ha/playbooks",
#       "/opt/freeware/bin/ansible-playbook -i /etc/ansible/hosts demo_volume_groups.yml --tags create"
#     ]
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "cd /.ansible/collections/ansible_collections/ibm/power_ha/playbooks",
#       "/opt/freeware/bin/ansible-playbook -i /etc/ansible/hosts demo_file_system.yml  --tags create"
#     ]
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "cd /.ansible/collections/ansible_collections/ibm/power_ha/playbooks",
#       "/opt/freeware/bin/ansible-playbook -i /etc/ansible/hosts demo_add_vg_to_rg.yml"
#     ]
#   }
# }
