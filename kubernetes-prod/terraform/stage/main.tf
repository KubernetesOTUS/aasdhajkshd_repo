provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

locals {
  project_name   = "kubernetes-prod"
  folder_name    = "repo-folder"
  folder_id      = length(var.folder_id) > 0 ? var.folder_id : data.yandex_resourcemanager_folder.this.id
  zone           = length(var.zone) > 0 ? var.zone : "ru-central1-a"
  v4_cidr_blocks = ["192.168.99.0/24"]

}

data "yandex_resourcemanager_folder" "this" {
  name     = local.folder_name
  cloud_id = var.cloud_id
}

resource "yandex_vpc_network" "this" {
  name      = "network-${local.project_name}"
  folder_id = local.folder_id
}

module "subnet" {
  source         = "../modules/subnet"
  name           = "subnet-${local.project_name}"
  network_id     = yandex_vpc_network.this.id
  folder_id      = local.folder_id
  zone           = local.zone
  v4_cidr_blocks = local.v4_cidr_blocks

  depends_on = [yandex_vpc_network.this]
}

module "kubernetes" {
  source           = "../modules/kubernetes"
  public_key_path  = var.public_key_path
  private_key_path = var.private_key_path
  subnet_id        = module.subnet.id
  cloud_id         = var.cloud_id
  folder_id        = local.folder_id
  image_id = var.image_id

  depends_on = [module.subnet]
}
