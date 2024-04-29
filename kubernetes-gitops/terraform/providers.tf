provider "yandex" {
  service_account_key_file = file(".secrets/key.json")
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = "ru-central1-a"
}

provider "local" {}

provider "random" {}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "yc-k8s-otus-kuber-repo-cluster"
}