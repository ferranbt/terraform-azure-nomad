variable "name" {
  type = "string"
}

variable "count" {
  type = "string"
}

variable "location" {
  default = "West Europe"
}

variable "custom_data" {
  type    = "string"
  default = ""
}

variable "disk_size" {
  default = "10"
}

variable "resource_group" {
  type = "string"
}

variable "subnet_id" {
  type = "string"
}

variable "username" {
  default = "ubuntu"
}

variable "password" {
  type = "string"
}

// -- vm

variable "vm_tier" {
  type = "string"
}

variable "vm_name" {
  type = "string"
}
