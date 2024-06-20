resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.json.tpl",
  {
    master_ips = module.kubernetes.master_ip_address
    master_ids = module.kubernetes.master_instance[0]
    master_names = module.kubernetes.master_instance[1]
    worker_ips = module.kubernetes.worker_ip_address
    worker_ids = module.kubernetes.worker_instance[0]
    worker_names = module.kubernetes.worker_instance[1]
  })
  filename = "${var.ansible_inventory}"
}

resource "null_resource" "run_ansible" {
  count = var.ansible == false ? 0 : 1
  triggers = {
    inventory_file = local_file.ansible_inventory.filename
  }
    
  provisioner "local-exec" {

    command = "ansible-playbook -T 300 -i ${local_file.ansible_inventory.filename} ${var.ansible_playbook}"
    environment = {
      ANSIBLE_CONFIG = "${var.ansible_config}"
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
  }
}

resource "local_file" "kubespray_inventory" {
  content = templatefile("${path.module}/templates/kubespray.ini.tpl",
  {
    master_ips = module.kubernetes.master_ip_address
    master_ids = module.kubernetes.master_instance[0]
    worker_ips = module.kubernetes.worker_ip_address
    worker_ids = module.kubernetes.worker_instance[0]
    node_ips = concat(module.kubernetes.master_ip_address, module.kubernetes.worker_ip_address)
  })
  filename = "../../kubespray/inventory/local/inventory.ini"
}
