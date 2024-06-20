# tflint-ignore: terraform_unused_declarations
variable "cloud_id" {
  description = "Cloud"
  type        = string
}

variable "folder_id" {
  description = "Folder"
  type        = string
}

variable "zone" {
  description = "Zone"
  type        = string
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
  description = "Disk image for docker"
  nullable = true
}

variable "subnet_id" {
  type        = string
  description = "Subnets for modules"
}

variable "service_account_key_file" {
  type        = string
  description = "Key .json"
}

variable "instance_id" {
  type        = list(string)
  description = "Docker instance ID"
  default     = []
}

variable "instance_hostname" {
  type        = list(string)
  description = "Docker instance hostname"
  default     = []
}

variable "ip_address" {
  type    = list(string)
  default = []
}

variable "ansible" {
  type        = bool
  description = "Run ansible playbook"
  default     = false
}

variable "ansible_inventory" {
  type        = string
  description = "Ansible dynamic inventory"
}

variable "ansible_config" {
  type        = string
  description = "Ansible config file"
}

variable "ansible_playbook" {
  type        = string
  description = "Ansible playbook"
}
