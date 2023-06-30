variable "cloud_id" {
  description = "Cloud"
}

variable "folder_id" {
  description = "Folder"
}

variable "zone" {
  description = "Zone"
  default     = "ru-central1-a"
}

variable "public_key_path" {
  description = "Path to the public key used for ssh access"
}

variable "private_key_path" {
  description = "Path to the public key used for ssh access"
}

variable "image_id" {
  description = "Disk image"
}

variable "subnet_id" {
  description = "Subnet"
}

variable "token" {
  description = "auth_token"
}

variable "inst_count" {
  description = "Number of instances"
  type        = number
  default     = 1
}

variable "ssh_user" {
  description = "User name for SSH connection"
  default     = "ubuntu"
}
