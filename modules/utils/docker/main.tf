data "template_file" "setup" {
  template = "${file("${path.module}/setup.sh.tpl")}"
}

output "setup" {
  value = "${data.template_file.setup.rendered}"
}
