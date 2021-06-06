###############################
######## Instance keys ########
###############################

variable "private_key_path" {
  type = string
}

variable "public_key_path" {
  type = string
}

############################
######## AWS config ########
############################

variable "aws_credentials_path" {
  type    = string
  default = "~/.aws/credentials"
}

variable "aws_credentials_profile" {
  type    = string
  default = "default"
}

variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "key_name" {
  type    = string
  default = "terraform_k8s"
}

variable "aws_instance_type" {
  type    = string
  default = "t2.micro"
}

############################
######## GCP config ########
############################

variable "gcp_credentials_path" {
  type = string
}

variable "gcp_region" {
  type    = string
  default = "asia-south1"
}

variable "gcp_project" {
  type = string
}

variable "gcp_machine_type" {
  type    = string
  default = "e2-micro"
}

variable "gcp_zone" {
  type    = string
  default = "asia-south1-a"
}

##############################
######## Azure config ########
##############################

variable "azure_rg_name" {
  type = string
  default = "k8s-resources"
}

variable "azure_rg_location" {
  type = string
  default = "South India"
}

variable "azure_vn_name" {
  type = string
  default = "k8s-network"
}

variable "azure_vn_adress_space" {
  type = list
  default = ["10.0.0.0/16"]
}

variable "azure_subnet_name" {
  type = string
  default = "k8s-subnet"
}

variable "azure_subnet_adress_prefixes" {
  type = list
  default = ["10.0.2.0/24"]
}

variable "azure_vm_size" {
  type = string
  default = "Standard_A1_v2"
}

##################################
######## K8s nodes config ########
##################################

variable "aws_nodes" {
  type    = number
  default = 1
}

variable "azure_nodes" {
  type    = number
  default = 1
}

variable "gcp_nodes" {
  type    = number
  default = 1
}