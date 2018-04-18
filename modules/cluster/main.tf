resource "azurerm_virtual_machine_scale_set" "cluster" {
  name                = "${var.name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"
  upgrade_policy_mode = "Manual"

  sku {
    name     = "${var.vm_name}"
    tier     = "${var.vm_tier}"
    capacity = "${var.count}"
  }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun           = 0
    caching       = "ReadWrite"
    create_option = "Empty"
    disk_size_gb  = "${var.disk_size}"
  }

  os_profile {
    computer_name_prefix = "${var.name}-"
    admin_username       = "${var.username}"
    admin_password       = "${var.password}"
    custom_data          = "${var.custom_data}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  network_profile {
    name    = "network_profile"
    primary = true

    ip_configuration {
      name      = "consul_ip_configuration"
      subnet_id = "${var.subnet_id}"
    }
  }
}
