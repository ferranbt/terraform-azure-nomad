
data "template_file" "setup" {
    template = "${file("${path.module}/setup.sh.tpl")}"

    vars {
        user_data           = "${var.user_data}"
        nomad_version       = "${var.nomad_version}"
        nomad_dir           = "${var.nomad_dir}"
        nomad_config_dir    = "${var.nomad_config_dir}"
        datacenter          = "${var.datacenter}"
        server_service_name = "${var.server_service_name}"
        client_service_name = "${var.client_service_name}"
        client              = "${var.client}"
        server              = "${var.server}"
        bootstrap           = "${var.bootstrap}"
    }
}

output "setup" {
    value = "${data.template_file.setup.rendered}"
}
