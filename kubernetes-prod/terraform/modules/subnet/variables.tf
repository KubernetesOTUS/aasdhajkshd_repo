variable "name" {
  type        = string
  description = "Subnet name"
}

variable "zone" {
  type        = string
  description = "Subnet availability zone"
  default     = "ru-central1-a"
}

variable "network_id" {
  type        = string
  description = "Subnet network ID"
  nullable    = false
}

variable "folder_id" {
  type        = string
  description = "Folder ID"
  default     = null
}

variable "v4_cidr_blocks" {
  type        = list(any)
  description = "Subnet v4 CIDR blocks"
}