terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# -------------------------------
# Resource Group
# -------------------------------
resource "azurerm_resource_group" "devops_rg" {
  name     = "devops-rg"
  location = "Canada Central"
}

# -------------------------------
# Virtual Network
# -------------------------------
resource "azurerm_virtual_network" "devops_vnet" {
  name                = "devops-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.devops_rg.location
  resource_group_name = azurerm_resource_group.devops_rg.name

  depends_on = [
    azurerm_resource_group.devops_rg
  ]
}

# -------------------------------
# Subnet
# -------------------------------
resource "azurerm_subnet" "devops_subnet" {
  name                 = "devops-subnet"
  resource_group_name  = azurerm_resource_group.devops_rg.name
  virtual_network_name = azurerm_virtual_network.devops_vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  depends_on = [
    azurerm_virtual_network.devops_vnet
  ]
}

# -------------------------------
# AKS Cluster
# -------------------------------
resource "azurerm_kubernetes_cluster" "devops_aks" {
  name                = "devops-aks"
  location            = azurerm_resource_group.devops_rg.location
  resource_group_name = azurerm_resource_group.devops_rg.name
  dns_prefix          = "devopsaks"

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_D2s_v3"
    vnet_subnet_id = azurerm_subnet.devops_subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    service_cidr   = "10.2.0.0/16"   # <-- changed to avoid conflict with subnet
    dns_service_ip = "10.2.0.10"
  }

  tags = {
    environment = "dev"
  }

  depends_on = [
    azurerm_subnet.devops_subnet
  ]
}
