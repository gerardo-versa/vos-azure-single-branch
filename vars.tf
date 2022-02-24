variable "subscription_id" {
  description = "Subscription ID of Azure account."
}

variable "client_id" {
  description = "Client ID of Terraform account to be used to deploy VM on Azure."
}

variable "client_secret" {
  description = "Client Secret of Terraform account to be used to deploy VM on Azure."
}

variable "tenant_id" {
  description = "Tenant ID of Terraform account to be used to deploy VM on Azure."
}

variable "location" {
  description = "Location where Versa Head End setup to be deployed."
}

variable "resource_group" {
  description = "Name of the resource group in which Versa Head End setup will be deployed."
  default = "Versa_FlexVNF_RG"
}

variable "ssh_key" {
  description = "SSH Key to be injected into VMs deployed on Azure."
}

variable "image_flexvnf" {
  description = "FlexVNF Image ID to be used to deploy Versa FlexVNF Branch."
}

variable "vm_name" {
  description = "Name of the VM to be used which will be displayed in Virtual machines list under Azure Portal."
  default = "Versa_FlexVNF"
}

variable "vnet_name" {
  description  = "Name for the VNET to be deployed"
}

variable "vnet_address_space" {
  description = "Adress space to be used by the VNET"
}

variable "mgmt_address_space" {
  description = "Adress space to be used by the MGMT Subnet. Must be a subnet inside of the VNET address space"
}

variable "wan_address_space" {
  description = "Adress space to be used by the WAN Subnet. Must be a subnet inside of the VNET address space"
}

variable "lan_address_space" {
  description = "Adress space to be used by the LAN Subnet. Must be a subnet inside of the VNET address space"
}

variable "flexvnf_vm_size" {
  description = "Size of Versa FlexVNF-1 Router VM."
  default = "Standard_DS3"
}

variable "local_authentication_id" {
  description = "local authentication for staging script"
  default = "Controller-01-staging@Versa-networks.com"
}

variable "remote_authentication_id" {
  description = "remote authentication for staging script"
  default = "SDWAN-Branch@Versa.com"
}

variable "serial_number" {
  description = "appliance serial number"
  default = "branch02"
}

variable "controller_ip" {
  description = "Controller WAN IP used for staging"
}

variable "director_sb_ip" {
  description = "Director Southbound IP"
}
