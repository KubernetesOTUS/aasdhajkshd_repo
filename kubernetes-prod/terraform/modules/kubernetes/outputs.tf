output "master_instance" {
  value = [yandex_compute_instance.master[*].id, yandex_compute_instance.master[*].name]
}

output "master_ip_address" {
  value = [for instance in yandex_compute_instance.master: instance.network_interface[0].nat_ip_address]
}

output "worker_ip_address" {
  value = [for instance in yandex_compute_instance.worker: instance.network_interface[0].nat_ip_address]
}

output "worker_instance" {
  value = [yandex_compute_instance.worker[*].id, yandex_compute_instance.worker[*].name]
}

output "image_id" {
  value = data.yandex_compute_image.this.image_id
}
  