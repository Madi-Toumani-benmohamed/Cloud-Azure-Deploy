output "resource_group_name" {
value = azurerm_resource_group.terraform.name
}

output "location" {
value = azurerm_resource_group.terraform.location
}

output "reseau" {
value = azurerm_virtual_network.net01.name
}

output "subnet" {
value = azurerm_subnet.subnet.address_prefixes
}

output "security_group_protocol_open" {
value = azurerm_network_security_rule.http.protocol
}

output "ip_public_vm" {
value = azurerm_public_ip.linux-vm-ip.ip_address
}


output "ip_public_privee_vm" {
value = azurerm_linux_virtual_machine.VM.private_ip_addresses
}
