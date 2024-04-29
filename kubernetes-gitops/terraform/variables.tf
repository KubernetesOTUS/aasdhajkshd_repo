variable "cloud_id" {
  type        = string
  description = "YC Cloud ID"
}

variable "folder_id" {
  type        = string
  description = "YC Folder ID"
}

variable "project" {
  type        = string
  description = "Name of project (cloud)"
}

variable "environment" {
  type        = string
  description = "Name of environment"
}

variable "cluster_name" {
  type        = string
  description = "Kubernetes Cluster Name"
  default     = "k8s-otus-kuber-repo-k8s-cluster"
}

variable "cluster_id" {
  type        = string
  description = "ID of Kubernetes cluster"
}

variable "chart_version" {
  type        = string
  description = "Chart version"
  default     = "5.46.8-6"
}
