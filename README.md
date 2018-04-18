
# Nomad Terraform Module

A terraform module to deploy a [Nomad](https://www.nomadproject.io) cluster on [Azure](https://azure.microsoft.com).

This module includes:
* Cluster: This module contains a generic scale set group used to deploy both clients and servers.
* Setup: This module generates the setup script to provision the cluster machines and configure nomad in both client and server mode.
* Docker: Utils module to install docker. It is used in the client machines.

# Usage

The next example uses consul for an automatic bootstrap of the cluster. It asumes that there exists consul servers reachable via DNS at 'consul-000001' or 'consul-000002'. [This]([this](github.com/melonproject/terraform-azure-consul)) Terraform Consul module can be used to bootstrap a consul cluster reachable in those DNS addresses. Both servers and clients are deployed on different Scale Sets so that and external jumpbox is necessary to access the virtual machines.

## Server

```
module "consul-client-setup" {
  source = "github.com/melonproject/terraform-azure-consul/modules/client"

  datacenter = "dc1"
  retry_join = ["consul-000001", "consul-000002"]
}

module "nomad-server-setup" {
  source = "./modules/setup"

  user_data = "${module.consul-client-setup.setup}"
  server    = "true"
  bootstrap = "3"
}

module "nomad-server-cluster" {
  source = "./modules/cluster"

  name           = "nomad-server"
  count          = "3"
  custom_data    = "${module.nomad-server-setup.setup}"
  resource_group = "nomad-server"
  subnet_id      = "subnet_id"

  username = "ubuntu"
  password = "SomeHardPassword"

  vm_tier = "Basic"
  vm_name = "Basic_A2"
}
```

## Client

```
module "consul-client-setup" {
  source = "github.com/melonproject/terraform-azure-consul/modules/client"

  datacenter = "dc1"
  retry_join = ["consul-000001", "consul-000002"]
}

module "docker-setup" {
  source = "./modules/utils/docker"
}

module "nomad-client-setup" {
  source = "./modules/setup"

  user_data = <<EOF
${module.consul-client-setup.setup}
${module.docker-setup.setup}
EOF

  client = "true"
}

module "nomad-client-cluster" {
  source = "./modules/cluster"

  name           = "nomad-client"
  count          = "3"
  custom_data    = "${module.nomad-client-setup.setup}"
  resource_group = "nomad-client"
  subnet_id      = "subnet_id"

  username = "ubuntu"
  password = "SomeHardPassword"

  vm_tier = "Basic"
  vm_name = "Basic_A2"
}
```
