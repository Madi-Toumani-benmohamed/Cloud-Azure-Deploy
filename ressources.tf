
# création de la range d ip

resource "azurerm_virtual_network" "net01" {
name = var.reseau
address_space = ["10.0.0.0/16"]
location = var.location
resource_group_name = var.rg_name

}

# création de lu sous réseau

resource "azurerm_subnet" "subnet" {
  name = var.subnet
  address_prefixes = var.subnet-cidr
  virtual_network_name = azurerm_virtual_network.net01.name
  resource_group_name  = var.rg_name
}

# création de la security group

resource "azurerm_network_security_group" "linux-vm-nsg" {
    depends_on=[azurerm_virtual_network.net01]
    name                = var.nsg_name
    location            = var.location
    resource_group_name = var.rg_name
    

}  
  
# création de la règle entrante pour le protocole ssh

resource "azurerm_network_security_rule" "ssh" {
    resource_group_name         = var.rg_name
    network_security_group_name = azurerm_network_security_group.linux-vm-nsg.name
    name                       = "AllowSSH"
    description                = "Allow SSH"
    priority                   = 150
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"

}

# création de la règle entrante pour le protocole http

resource "azurerm_network_security_rule" "http" {


    resource_group_name         = var.rg_name
    network_security_group_name = azurerm_network_security_group.linux-vm-nsg.name
    name                         = "AllowHTTP"
    description                = "Allow HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
   
}


# Association de la sécurity group avec la carte réseau 

resource "azurerm_subnet_network_security_group_association" "linux-vm-nsg-association" {
  depends_on=[azurerm_virtual_network.net01,azurerm_network_security_group.linux-vm-nsg]
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.linux-vm-nsg.id
}

# création de l'adresse ip publique

resource "azurerm_public_ip" "linux-vm-ip" {
  depends_on=[azurerm_virtual_network.net01]
  count               = var.nombre
  name                = "ippubname${count.index}"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
}

# création de la carte réseau 

resource "azurerm_network_interface" "linux-vm-nic" {
  depends_on=[azurerm_subnet.subnet]
  count               = var.nombre 
  name                = "nicname${count.index}"
  location            = var.location
  resource_group_name = var.rg_name
    ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    #public_ip_address_id          = [element(azurerm_public_ip.linux-vm-ip.id.*.id, count.index)]
    public_ip_address_id          = azurerm_public_ip.linux-vm-ip[count.index].id
  }
}

# création de la clé publique ssh

/*
resource "azurerm_ssh_public_key" "example" {
  name                = var.ssh_key_public_name
  resource_group_name = var.resource_group_name
  location            = var.location
  public_key          = file("~/.ssh/yes.pub")

}*/


resource "azurerm_linux_virtual_machine" "VM" {
  count               = var.nombre
  name                = "vmname${count.index}"
  resource_group_name = var.rg_name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = var.default_user_name
  network_interface_ids = [element(azurerm_network_interface.linux-vm-nic.*.id, count.index)]
 
  admin_ssh_key {
    username   = var.default_user_name
    public_key = file("~/.ssh/yes.pub")
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = var.source_image[0]
    offer     = var.source_image[1]
    sku       = var.source_image[2]
    version   = var.source_image[3]
  }
}