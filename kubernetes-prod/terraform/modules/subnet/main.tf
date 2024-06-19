data "yandex_client_config" "client" {}

locals {
  folder_id = var.folder_id == null ? data.yandex_client_config.client.folder_id : var.folder_id
}

data "yandex_vpc_subnet" "this" {
  name       = var.name
  folder_id  = var.folder_id
  depends_on = [yandex_vpc_subnet.this]
}

resource "yandex_vpc_subnet" "this" {
  name           = var.name
  zone           = var.zone
  network_id     = var.network_id
  folder_id      = var.folder_id
  v4_cidr_blocks = var.v4_cidr_blocks
}
