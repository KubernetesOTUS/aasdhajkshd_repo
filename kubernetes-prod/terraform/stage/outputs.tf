output "kubernetes_master_instance" {
  description = "The ID of docker instance"
  value       = module.kubernetes.master_instance
}

output "kubernetes_master_ip_address" {
  description = "NAT IP address of master k8s instance"
  value       = module.kubernetes.master_ip_address[0]
}

output "kubernetes_worker_instance" {
  description = "The ID of docker instance"
  value       = module.kubernetes.worker_instance
}

output "kubernetes_worker_ip_address" {
  description = "NAT IP address of worker k8s instance"
  value       = module.kubernetes.worker_ip_address[0]
}

output "kubernetes_image_id" {
  description = "Image ID of Kubernetes instance"
  value       = module.kubernetes.image_id
}
