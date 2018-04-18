// ---- consul client

module "consul_client_setup" {
  source = "github.com/melonproject/terraform-azure-consul/modules/client"

  datacenter = "${var.datacenter}"
  retry_join = "${var.retry_join}"
}

// ---- nomad server

resource "azurerm_resource_group" "nomad_server" {
  name     = "${var.name}_nomad_server"
  location = "${var.location}"
}

module "nomad_server_setup" {
  source = "./modules/setup"

  user_data = "${module.consul_client_setup.setup}"
  server    = "true"
  bootstrap = "${var.server_count}"
}

module "nomad_server_cluster" {
  source = "./modules/cluster"

  name           = "nomad-server"
  count          = "${var.server_count}"
  custom_data    = "${module.nomad_server_setup.setup}"
  resource_group = "${azurerm_resource_group.nomad_server.name}"
  subnet_id      = "${var.subnet_id}"

  username = "${var.server_username}"
  password = "${var.server_password}"

  vm_tier = "${var.server_vm_tier}"
  vm_name = "${var.server_vm_name}"
}

// ---- nomad client

resource "azurerm_resource_group" "nomad_client" {
  name     = "${var.name}_nomad_client"
  location = "${var.location}"
}

module "docker_setup" {
  source = "./modules/utils/docker"
}

module "nomad_client_setup" {
  source = "./modules/setup"

  user_data = <<EOF
${module.consul_client_setup.setup}
${module.docker_setup.setup}
EOF

  client = "true"
}

module "nomad_client_cluster" {
  source = "./modules/cluster"

  name           = "nomad-client"
  count          = "${var.client_count}"
  custom_data    = "${module.nomad_client_setup.setup}"
  resource_group = "${azurerm_resource_group.nomad_client.name}"
  subnet_id      = "${var.subnet_id}"

  username = "${var.client_username}"
  password = "${var.client_password}"

  vm_tier = "${var.client_vm_tier}"
  vm_name = "${var.client_vm_name}"
}
