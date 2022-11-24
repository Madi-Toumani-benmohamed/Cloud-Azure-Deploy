# création de la ressource group

resource "azurerm_resource_group" "terraform" {
name = var.resource_group_name
location = var.location

}

# création de la range d ip

resource "azurerm_virtual_network" "net01" {
name = var.reseau
address_space = ["10.0.0.0/16"]
location = azurerm_resource_group.terraform.location
resource_group_name = azurerm_resource_group.terraform.name 

}

# création de lu sous réseau

resource "azurerm_subnet" "subnet" {
  name = var.subnet
  address_prefixes = var.subnet-cidr
  virtual_network_name = azurerm_virtual_network.net01.name
  resource_group_name  = azurerm_resource_group.terraform.name
}

# création de la security group

resource "azurerm_network_security_group" "linux-vm-nsg" {
    depends_on=[azurerm_virtual_network.net01]
    name                = var.nsg_name
    location            = azurerm_resource_group.terraform.location
    resource_group_name = azurerm_resource_group.terraform.name
    

}  
  
# création de la règle entrante pour le protocole ssh

resource "azurerm_network_security_rule" "ssh" {
    resource_group_name         = azurerm_resource_group.terraform.name
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


    resource_group_name         = azurerm_resource_group.terraform.name
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
  name                = var.ip_public_name
  location            = azurerm_resource_group.terraform.location
  resource_group_name = azurerm_resource_group.terraform.name
  allocation_method   = "Static"
}

# création de la carte réseau 

resource "azurerm_network_interface" "linux-vm-nic" {
  depends_on=[azurerm_subnet.subnet]
  name                = var.nic_name
  location            = azurerm_resource_group.terraform.location
  resource_group_name = azurerm_resource_group.terraform.name
    ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.linux-vm-ip.id
  }
}

# création de la clé publique ssh


resource "azurerm_ssh_public_key" "example" {
  name                = var.ssh_key_public_name
  resource_group_name = var.resource_group_name
  location            = var.location
  public_key          = file("~/.ssh/yes.pub")

}


resource "azurerm_linux_virtual_machine" "VM" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [azurerm_network_interface.linux-vm-nic.id]
 
  admin_ssh_key {
    username   = var.default_user_name
    public_key = file("~/.ssh/yes.pub")
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}