locals {
  dst_files_dir                = "/installation_script"
  template_dir                 = "${path.module}/template-files"
  src_script_tftpl_path        = "${local.template_dir}/powervs_installation.sh.tftpl"
  dst_script_file_path         = "${local.dst_files_dir}/install_packages.sh"
  python_cos_path              = "${local.template_dir}/download_files.py"
  destination_python_file_path = "download_files.py"
  destination_ansible_yml_file = "/etc/ansible/external_var.yml"
  python_path                  = "/opt/freeware/bin/python3.9"
}

# ##############################
# For AIX 7.2 some additional steps
# ##############################

# ##########################################################
# 0.1  Installation of SSL certificate in AIX 7.2 machines
# ##########################################################
resource "terraform_data" "download_ssl_packages" {
  count = startswith(var.aix_image_id, "7200") || startswith(var.aix_image_id, "7300-00-01") ? 1 : 0
  connection {
    type        = "ssh"
    user        = "root"
    host        = var.bastion_host_ip
    private_key = var.ssh_private_key
    agent       = false
    timeout     = "20m"
  }

  provisioner "file" {
    content     = var.ssh_private_key
    destination = "/root/.ssh/private_key.pem"
  }

  ####### Copy Template file to target host ############
  provisioner "file" {
    source      = local.python_cos_path
    destination = local.destination_python_file_path
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'y' | sudo yum install python3",
      "pip3 install boto3",
      "chmod 700 /root/.ssh/private_key.pem",
      "chmod +x ${local.destination_python_file_path}",
      "/usr/bin/python3 ${local.destination_python_file_path} 'file' ${var.pi_cos_data.bucket_name} ${var.pi_cos_data.ssl_file_name} ${var.pi_cos_data.cos_endpoint} ${var.pi_cos_data.cos_access_key_id} ${var.pi_cos_data.cos_secret_access_key}",
      <<EOT
      %{for ip in var.nodes~}
        ssh-keyscan -H ${ip} >> /root/.ssh/known_hosts;
        scp -i /root/.ssh/private_key.pem /root/${var.pi_cos_data.ssl_file_name} root@${ip}:/;
      %{endfor~}
    EOT
    ]
  }
}

# ##########################################################
# 0.2  Installation of SSL certificate in AIX 7.2 machines
# ##########################################################
resource "terraform_data" "install_ssl_packages" {
  depends_on = [terraform_data.download_ssl_packages]
  count      = startswith(var.aix_image_id, "7200") || startswith(var.aix_image_id, "7300-00-01") ? length(var.nodes) : 0
  connection {
    type         = "ssh"
    user         = "root"
    bastion_host = var.bastion_host_ip
    host         = var.nodes[count.index]
    private_key  = var.ssh_private_key
    agent        = false
    timeout      = "20m"
  }
  ####### Unzip powerha tar file ############
  provisioner "remote-exec" {
    inline = [
      "chfs -a size=+1G /",
      "gunzip -c ${var.pi_cos_data.ssl_file_name} | tar -xvf -",
      "cd /openssl-1.1.2.2200",
      "installp -agXYd . all"
    ]
  }
}


# ##############################
# 1.  Package Installation
# ##############################
resource "terraform_data" "install_packages" {
  depends_on = [terraform_data.install_ssl_packages]
  count      = length(var.nodes)
  connection {
    type         = "ssh"
    user         = "root"
    bastion_host = var.bastion_host_ip
    host         = var.nodes[count.index]
    private_key  = var.ssh_private_key
    agent        = false
    timeout      = "20m"
  }

  ####### Create Terraform scripts directory ############
  provisioner "remote-exec" {
    inline = ["mkdir -p ${local.dst_files_dir}", "chmod 777 ${local.dst_files_dir}"]
  }

  provisioner "file" {
    content     = var.ssh_private_key
    destination = "/.ssh/private_key.pem"
  }

  ####### Copy Template file to target host ############
  provisioner "file" {
    content     = templatefile(local.src_script_tftpl_path, { "proxy_ip_and_port" = var.proxy_ip_and_port, "index" = count.index, "extended_volume" = var.node_details[count.index].pi_volume_80 })
    destination = local.dst_script_file_path
  }

  ####### Execute script: Install packages ############
  provisioner "remote-exec" {
    inline = ["chmod 700 /.ssh/private_key.pem", "chmod +x ${local.dst_script_file_path}", local.dst_script_file_path]
  }
}


# #####################################
#  2. Download powerha filesets
# #####################################
resource "null_resource" "download_pha" {
  depends_on = [terraform_data.install_packages]
  count      = length(var.nodes)
  connection {
    type         = "ssh"
    user         = "root"
    bastion_host = var.bastion_host_ip
    host         = var.nodes[count.index]
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
      "${local.python_path} ${local.destination_python_file_path} 'pha' ${var.pi_cos_data.bucket_name} ${var.pi_cos_data.folder_name} ${var.pi_cos_data.cos_endpoint} ${var.pi_cos_data.cos_access_key_id} ${var.pi_cos_data.cos_secret_access_key}"
    ]
  }
}


locals {
  src_ansible_tar_file  = "${path.module}/ansible/ansible_powerha_tarball.tar.gz"
  dest_ansible_tar_file = "ansible_powerha_tarball.tar.gz"
  pha_build_path        = "/${var.pi_cos_data.folder_name}/pha/"
}

# ##########################################################################
#  3. Download ansible filesets : After galaxy we need to modify it
# ##########################################################################
resource "null_resource" "download_ansible" {
  depends_on = [terraform_data.install_packages]
  count      = length(var.nodes)
  connection {
    type         = "ssh"
    user         = "root"
    bastion_host = var.bastion_host_ip
    host         = var.nodes[count.index]
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
# 4. creating ansible configuration files locally
# #########################################################################

resource "terraform_data" "ansible_hosts" {
  depends_on = [
    null_resource.download_ansible,
    null_resource.download_pha
  ]
  provisioner "local-exec" {
    command = <<-EOT
      cat <<EOF > ${local.template_dir}/host
      [powerha_remote_servers]
      ${join("\n", var.nodes)}
      [powerha_remote_servers:vars]
      ansible_user='root'
      ansible_python_interpreter= '${local.python_path}'
      ansible_ssh_private_key_file= '/.ssh/private_key.pem'
      EOF
          EOT
  }
}

# #########################################################################
# 5. Copy host and ansible_config.py files to the remote machine
#    Create ansible.yml file using ansible_config.py
# #########################################################################

resource "terraform_data" "copy_files_to_remote" {
  depends_on = [
    null_resource.download_ansible,
    null_resource.download_pha,
    terraform_data.ansible_hosts
  ]

  connection {
    type         = "ssh"
    user         = "root"
    bastion_host = var.bastion_host_ip
    host         = var.nodes[0]
    private_key  = var.ssh_private_key
    agent        = false
    timeout      = "10m"
  }

  provisioner "file" {
    source      = "${local.template_dir}/host"
    destination = "/etc/ansible/hosts"
  }

  provisioner "file" {
    content = templatefile("${local.template_dir}/ansible_config.py.tftpl", { "rg_count" = var.powerha_resource_group_count, "rg_list" = jsonencode(var.powerha_resource_group_list),
      "vg_count"         = var.volume_group_count, "vg_list" = jsonencode(var.volume_group_list),
      "fs_count"         = var.file_system_count, "fs_list" = jsonencode(var.file_system_list),
      "shared_wwn_disks" = jsonencode(var.shared_disk_wwns), "node_details" = jsonencode(var.node_details),
      "subnet_list"      = jsonencode(var.subnet_list), "reserve_ip_data" = jsonencode(var.reserve_ip_data),
    "pha_build_path" = jsonencode(local.pha_build_path), "destination_ansible_yml_file" = jsonencode(local.destination_ansible_yml_file) })
    destination = "ansible_config.py"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ansible_config.py",
      "${local.python_path} ansible_config.py"
    ]
  }
}

# #########################################################################
# 6. Executing Ansible Playbook to the remote machine
# #########################################################################


resource "terraform_data" "ansible_playbook_execution" {
  depends_on = [
    null_resource.download_ansible,
    null_resource.download_pha,
    terraform_data.ansible_hosts,
    terraform_data.copy_files_to_remote
  ]

  connection {
    type         = "ssh"
    user         = "root"
    bastion_host = var.bastion_host_ip
    host         = var.nodes[0]
    private_key  = var.ssh_private_key
    agent        = false
    timeout      = "10m"
  }


  provisioner "remote-exec" {
    inline = [
      "cd /.ansible/collections/ansible_collections/ibm/power_ha/playbooks",
      "/opt/freeware/bin/ansible-playbook -i /etc/ansible/hosts demo_map_hosts.yml"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "cd /.ansible/collections/ansible_collections/ibm/power_ha/playbooks",
      "/opt/freeware/bin/ansible-playbook -i /etc/ansible/hosts demo_PowerHA.yml --tags install"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "cd /.ansible/collections/ansible_collections/ibm/power_ha/playbooks",
      "/opt/freeware/bin/ansible-playbook -i /etc/ansible/hosts demo_cluster.yml --tags standard"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "cd /.ansible/collections/ansible_collections/ibm/power_ha/playbooks",
      "/opt/freeware/bin/ansible-playbook -i /etc/ansible/hosts demo_network.yml --tags create"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "cd /.ansible/collections/ansible_collections/ibm/power_ha/playbooks",
      "/opt/freeware/bin/ansible-playbook -i /etc/ansible/hosts demo_interface.yml --tags create"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "cd /.ansible/collections/ansible_collections/ibm/power_ha/playbooks",
      "/opt/freeware/bin/ansible-playbook -i /etc/ansible/hosts demo_service_ip.yml --tags create"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "cd /.ansible/collections/ansible_collections/ibm/power_ha/playbooks",
      "/opt/freeware/bin/ansible-playbook -i /etc/ansible/hosts demo_resource_group.yml --tags create"

    ]
  }

  provisioner "remote-exec" {
    inline = [
      "cd /.ansible/collections/ansible_collections/ibm/power_ha/playbooks",
      "/opt/freeware/bin/ansible-playbook -i /etc/ansible/hosts demo_volume_groups.yml --tags create"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "cd /.ansible/collections/ansible_collections/ibm/power_ha/playbooks",
      "/opt/freeware/bin/ansible-playbook -i /etc/ansible/hosts demo_file_system.yml  --tags create"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "cd /.ansible/collections/ansible_collections/ibm/power_ha/playbooks",
      "/opt/freeware/bin/ansible-playbook -i /etc/ansible/hosts demo_add_vg_to_rg.yml"
    ]
  }

}
