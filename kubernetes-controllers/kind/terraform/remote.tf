provider "remote" {
  max_sessions = 10
}

data "remote_file" "kubeconfig" {
    for_each = var.vms
    

    depends_on = [ vsphere_virtual_machine.this ]

    path = "/home/${each.value.username}/.kube/config"

    conn {
		host = each.value.ip
     	user     = each.value.username
        private_key = file("~/.ssh/id_rsa-appuser")
	} 
}

resource "null_resource" "kubeconfig" {
  for_each = var.vms

  depends_on = [  data.remote_file.kubeconfig ]

  provisioner "local-exec" {
    command = <<-EOT
      /usr/bin/mkdir -p /tmp/${each.key}/.kube
      echo "${data.remote_file.kubeconfig[each.key].content}" > "/tmp/${each.key}/.kube/config"
    EOT
  }
}

output "kubeconfig" {
  value = { for vm_name in keys(var.vms) : vm_name => data.remote_file.kubeconfig[vm_name].content }
}
