output "id" {
  description = "VPC subnet ID"
  value       = data.yandex_vpc_subnet.this.subnet_id
}