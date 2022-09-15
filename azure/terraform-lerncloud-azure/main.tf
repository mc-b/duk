

# Ressource Gruppe

resource "azurerm_resource_group" "lerncloud" {
  name     = var.module
  location = var.location
}

# Netzwerk

resource "azurerm_virtual_network" "lerncloud" {
  name                  = "${var.module}-network"
  address_space         = ["10.0.0.0/16"]
  location              = azurerm_resource_group.lerncloud.location
  resource_group_name   = azurerm_resource_group.lerncloud.name
}

resource "azurerm_subnet" "lerncloud" {
  name                  = "${var.module}-subnet"
  virtual_network_name  = azurerm_virtual_network.lerncloud.name
  resource_group_name   = azurerm_resource_group.lerncloud.name
  address_prefixes      = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "lerncloud" {
  name                = "${var.module}-pip"
  resource_group_name = azurerm_resource_group.lerncloud.name
  location            = azurerm_resource_group.lerncloud.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "lerncloud" {
  name                = "${var.module}-nic1"
  resource_group_name = azurerm_resource_group.lerncloud.name
  location            = azurerm_resource_group.lerncloud.location

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.lerncloud.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.lerncloud.id
  }
}


# Security 

resource "azurerm_network_security_group" "lerncloud" {
  name                = "${var.module}-nsg"
  location            = azurerm_resource_group.lerncloud.location
  resource_group_name = azurerm_resource_group.lerncloud.name
  
  dynamic "security_rule" {
    for_each = local.expanded_ports 
      content {
            access                     = "Allow"
            direction                  = "Inbound"
            name                       = "port-${lookup(security_rule.value, "port")}"
            priority                   = lookup( security_rule.value, "priority" )
            protocol                   = "Tcp"
            source_port_range          = "*"
            source_address_prefix      = "*"
            destination_port_range     = "${lookup(security_rule.value, "port")}"
            destination_address_prefix = "*"
      } 
  }
  dynamic "security_rule" {
    for_each = local.expanded_ports_udp 
      content {
            access                     = "Allow"
            direction                  = "Inbound"
            name                       = "port-${lookup(security_rule.value, "port")}-udp"
            priority                   = lookup( security_rule.value, "priority" )
            protocol                   = "Udp"
            source_port_range          = "*"
            source_address_prefix      = "*"
            destination_port_range     = "${lookup(security_rule.value, "port")}"
            destination_address_prefix = "*"
      } 
  }  
  
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "alltcp"
    priority                   = 500
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "0.0.0.0/0"
    destination_port_range     = "22-65535"
    destination_address_prefix = "*"
  }
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "alludp"
    priority                   = 501
    protocol                   = "Udp"
    source_port_range          = "*"
    source_address_prefix      = "0.0.0.0/0"
    destination_port_range     = "22-65535"
    destination_address_prefix = "*"
  }  
}

resource "azurerm_network_interface_security_group_association" "lerncloud" {
  network_interface_id      = azurerm_network_interface.lerncloud.id
  network_security_group_id = azurerm_network_security_group.lerncloud.id
}

# VM 

resource "azurerm_linux_virtual_machine" "lerncloud" {
  name                              = var.module
  resource_group_name               = azurerm_resource_group.lerncloud.name
  location                          = azurerm_resource_group.lerncloud.location
  size                              = lookup( var.instance_type, var.memory )
  admin_username                    = "ubuntu"
  admin_password                    = "P@ssw0rd1234!"
  disable_password_authentication   = false  
  custom_data                       = base64encode(data.template_file.userdata.rendered)
  network_interface_ids             = [azurerm_network_interface.lerncloud.id]

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}



