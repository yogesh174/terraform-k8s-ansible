#######################################
######## Create resource group ########
#######################################

resource "azurerm_resource_group" "k8s" {
  name     = var.azure_rg_name
  location = var.azure_rg_location
}

########################################
######## Create virtual network ########
########################################

resource "azurerm_virtual_network" "k8s" {
  name                = var.azure_vn_name
  address_space       = var.azure_vn_adress_space
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
}

###############################
######## Create subnet ########
###############################

resource "azurerm_subnet" "k8s" {
  name                 = var.azure_subnet_name
  resource_group_name  = azurerm_resource_group.k8s.name
  virtual_network_name = azurerm_virtual_network.k8s.name
  address_prefixes     = var.azure_subnet_adress_prefixes
}

##################################
######## Create public ip ########
##################################

resource "azurerm_public_ip" "k8s_public_ip" {
  count               = var.azure_nodes
  name                = "k8s-${count.index}"
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
  allocation_method   = "Static"
  sku                 = "Basic"
}

##########################################
######## Create network interface ########
##########################################

resource "azurerm_network_interface" "k8s" {
  count               = var.azure_nodes
  name                = "k8s-nic-${count.index}"
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name

  ip_configuration {
    name                          = "k8s"
    subnet_id                     = azurerm_subnet.k8s.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.k8s_public_ip[count.index].id
  }
}

########################################
######## Create virtual machine ########
########################################

resource "azurerm_linux_virtual_machine" "k8s_worker" {
  count               = var.azure_nodes
  name                = "azure-k8s-worker-${count.index}"
  resource_group_name = azurerm_resource_group.k8s.name
  location            = azurerm_resource_group.k8s.location
  size                = var.azure_vm_size
  admin_username      = "adminuser"

  network_interface_ids = [
    azurerm_network_interface.k8s[count.index].id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file(var.public_key_path)
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

  # Created after and destroyed before master node
  depends_on = [
    aws_instance.k8s_master,
  ]

  provisioner "local-exec" {
    when    = destroy
    command = "ansible-playbook ansible/destroy-k8s-worker.yaml -i ansible-inventory -e 'node=${self.name}'"
  }
}