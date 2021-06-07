resource "ansible_host" "aws_k8s_master" {
  inventory_hostname = aws_instance.k8s_master.public_ip
  groups             = ["aws-k8s-master"]
  vars = {
    ansible_user                 = "ec2-user"
    ansible_ssh_private_key_file = var.private_key_path
  }
}

resource "ansible_host" "aws_k8s_node" {
  count              = var.aws_nodes
  inventory_hostname = [for x in aws_instance.k8s_worker : x.public_ip][count.index]
  groups             = ["aws-k8s-node-${count.index}"]
  vars = {
    ansible_user                 = "ec2-user"
    ansible_ssh_private_key_file = var.private_key_path
  }
}

resource "ansible_host" "azure_k8s_node" {
  count              = var.azure_nodes
  inventory_hostname = [for x in azurerm_linux_virtual_machine.k8s_worker : x.public_ip_address][count.index]
  groups             = ["azure-k8s-node-${count.index}"]
  vars = {
    ansible_user                 = "adminuser"
    ansible_ssh_private_key_file = var.private_key_path
  }
}

resource "ansible_host" "gcp_k8s_node" {
  count              = var.gcp_nodes
  inventory_hostname = [for x in google_compute_instance.k8s_worker : x.network_interface.0.access_config.0.nat_ip][count.index]
  groups             = ["gcp-k8s-node-${count.index}"]
  vars = {
    ansible_user                 = "dev"
    ansible_ssh_private_key_file = var.private_key_path
  }
}