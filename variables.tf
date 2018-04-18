variable "name" {
  description = "Logic name to refer to all the cluster resources"
  default     = "nomad"
}

variable "location" {
  description = "The Azure region the nomad cluster will be deployed in"
  default     = "West Europe"
}

variable "subnet_id" {
  description = "The subnet id that nomad resources will be deployed into"
}

// --- consul

variable "datacenter" {
  description = "Consul datacenter"
  default     = "dc1"
}

variable "retry_join" {
  description = "Addresses of other Consul agents to bootstrap"
  default     = []
}

// --- server

variable "server_count" {
  description = "The number of server nodes to deploy"
}

variable "server_username" {
  description = "Username to access the server machines"
  default     = "ubuntu"
}

variable "server_password" {
  description = "Password to access the server machines"
}

variable "server_vm_tier" {
  description = "Specifies the tier of the server virtual machine"
}

variable "server_vm_name" {
  description = "Specifies the size of the server virtual machine"
}

// --- client

variable "client_count" {
  description = "The number of client nodes to deploy"
}

variable "client_username" {
  description = "Username to access the client machines"
  default     = "ubuntu"
}

variable "client_password" {
  description = "Password to access the client machines"
}

variable "client_vm_tier" {
  description = "Specifies the tier of the client virtual machine"
}

variable "client_vm_name" {
  description = "Specifies the size of the client virtual machine"
}
