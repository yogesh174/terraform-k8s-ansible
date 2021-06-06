provider "aws" {
  region                  = var.aws_region
  shared_credentials_file = var.aws_credentials_path
  profile                 = var.aws_credentials_profile
}

provider "google" {
  project     = var.gcp_project
  region      = var.gcp_region
  credentials = var.gcp_credentials_path
}

provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    ansible = {
      source  = "nbering/ansible"
      version = "1.0.4"
    }
  }
}

provider "ansible" {}

provider "null" {}