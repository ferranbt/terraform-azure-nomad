
variable "user_data" {
    type    = "string"
    default = ""
}

variable "nomad_version" {
    type    = "string"
    default = "0.7.0"
}

variable "nomad_dir" {
    type    = "string"
    default = "/data"
}

variable "nomad_config_dir" {
    type    = "string"
    default = "/etc/nomad.d"
}

variable "datacenter" {
    type    = "string"
    default = "dc1"
}

variable "server_service_name" {
    type    = "string"
    default = "nomad"
}

variable "client_service_name" {
    type    = "string"
    default = "nomad-client"
}

variable "client" {
    type    = "string"
    default = "false"
}

variable "server" {
    type    = "string"
    default = "false"
}

variable "bootstrap" {
    type    = "string"
    default = "0"
}
