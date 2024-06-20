# tflint-ignore: terraform_unused_declarations
variable "cloud_id" {
  type        = string
  description = "Cloud"
}

variable "folder_id" {
  type        = string
  description = "Folder"
}

variable "zone" {
  type        = string
  description = "Zone"
  default     = "ru-central1-a"
}

variable "public_key_path" {
  type        = string
  description = "Path to the public key used for ssh access"
}

variable "private_key_path" {
  type        = string
  description = "Path to the private key used for ssh access"
}

variable "image_id" {
  type        = string
  description = "Disk image"
}

variable "image_family" {
  description = <<EOF
    (Required) Yandex default based images
    (Optional) yc compute image list --folder-id standard-images
  EOF
  type = string
  default = "ubuntu-2004-lts"
}

variable "subnet_id" {
  type        = string
  description = "Subnets for modules"
}

variable "instance_count" {
  description = "Number of instances of kubernetes hosts"
  type        = map(any)
  default     = {
    master = 3
    worker = 3
  }
}

variable "cluster_name" {
  description = "Cluster name as prefix of hosts"
  type = string
  default = "k8s"
}

variable "instance_tag" {
  type = list(string)
  default = ["master", "worker"]
}

variable "instance_resources" {
  type = map(any)
  default = {
    "cores" = 2
    "memory" = 8
    "fraction" = 100
  }
  description = "Instance resources"
}

variable "disk_type" {
  description = <<EOF
    (Optional) Disk type
    (Optional) https://cloud.yandex.com/en/docs/compute/concepts/disk
  EOF
  type = string
  default = "network-hdd"
}

variable "disk_size" {
  description = "Disk size in Gb"
  type = number
  default = 40
}
