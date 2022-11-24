variable "resource_group_name" {
description = "Name of the environment"
default = "terraform"
}
variable "location" {
description = "Azure location to use"
default = "AustraliaEast"
}
variable "reseau" {
description = "Azure network to use"
default = "net01"
}

variable "subnet" {
description = "Azur subnet to use"
default = "subnet"
}


variable "subnet-cidr" {
description = "Azur CIDR to use"
default = ["10.0.0.0/18"]
}

variable "nsg_name" {
description = "Name of the nsg"
default = "nsg"
}

variable "ip_public_name" {
description = "Name of the public ip"
default = "ippublic"   
}

variable "nic_name" {
description = "Name of the network interface"
default = "nic01"   
}

variable "ssh_key_public_name" {
description = "Name of the public ssh key"
default = "ssh_k_p01"   
}


variable "vm_name" {
description = "Name of the virtual machine"
default = "vm01"   
}

variable "default_user_name" {
description = "Name of the default user"
default = "adminuser"   
}

variable "source_image" {
description = "les sources de l image"
default =  ["Canonical","UbuntuServer","16.04-LTS","latest"]

}