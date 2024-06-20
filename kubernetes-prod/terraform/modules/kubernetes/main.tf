locals { 
  timestamp = replace(timestamp(), "[- TZ:]", "")
  image_id = length(var.image_id) > 0 ? var.image_id : data.yandex_compute_image.this.id
  ssh_public_keygen    = chomp(data.tls_public_key.this.public_key_pem)
  ssh_public_key_paths = ["~/.ssh/id_rsa-appuser.pub", "${path.root}/.secrets/id_rsa.pub", ]
  ssh_public_key       = try(coalesce([for path in local.ssh_public_key_paths : fileexists(path) ? file(path) : null]...))
}

data "yandex_compute_image" "this" {
  family = var.image_family
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

data "tls_public_key" "this" {
  depends_on      = [tls_private_key.this]
  private_key_pem = tls_private_key.this.private_key_pem
}

resource "null_resource" "keys-export" {
  depends_on = [data.tls_public_key.this]

  provisioner "local-exec" {
    command = <<-EOT
      mkdir -p ${path.root}/.secrets
      echo "${chomp(tls_private_key.this.private_key_pem)}" > ${path.root}/.secrets/id_rsa
      echo "${local.ssh_public_keygen}" > ${path.root}/.secrets/id_rsa.pub
    EOT
  }
}

resource "yandex_compute_instance" "master" {

  timeouts {
    create = "30m"
    delete = "2h"
  }

  count = var.instance_count["master"]

  allow_stopping_for_update = true

  name        = "${var.cluster_name}-${var.instance_tag[0]}-${count.index}"
  platform_id = "standard-v2"

  labels = {
    tags = "${var.instance_tag[0]}"
  }

  metadata = {
    user-data = file("meta.yaml")
  }

  resources {
    cores         = var.instance_resources["cores"]
    memory        = var.instance_resources["memory"]
    core_fraction = var.instance_resources["fraction"]
  }

  boot_disk {
    initialize_params {
      image_id = local.image_id
      type = var.disk_type
      size = var.disk_size
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat = true
  }

  connection {
    type        = "ssh"
    host        = self.network_interface[0].nat_ip_address
    user        = "var.ssh_user"
    agent       = false
    private_key = tls_private_key.this.private_key_pem
  }
}

resource "yandex_compute_instance" "worker" {

  timeouts {
    create = "60m"
    delete = "2h"
  }

  count = var.instance_count["worker"]

  allow_stopping_for_update = true

  name        = "${var.cluster_name}-${var.instance_tag[1]}-${count.index}"
  platform_id = "standard-v2"

  labels = {
    tags = "${var.instance_tag[1]}"
  }

  metadata = {
    ssh-keys = "var.ssh_user:${file(var.public_key_path)}"
  }

  resources {
    cores         = var.instance_resources["cores"]
    memory        = var.instance_resources["memory"]
    core_fraction = var.instance_resources["fraction"]
  }

  boot_disk {
    initialize_params {
      image_id = local.image_id
      type = var.disk_type
      size = var.disk_size
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat = true
  }

}
