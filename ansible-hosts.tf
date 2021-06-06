resource "ansible_host" "aws_k8s_master" {
  inventory_hostname = aws_instance.k8s_master.public_ip
  groups             = ["aws-k8s-master", "aws-k8s"]
  vars = {
    ansible_user                 = "ec2-user"
    ansible_ssh_private_key_file = var.private_key_path
  }
}

resource "ansible_host" "aws_k8s_node" {
  count              = var.aws_nodes
  inventory_hostname = aws_instance.k8s_worker[count.index].public_ip
  groups             = ["aws-k8s-node-${count.index}", "aws-k8s-nodes", "aws-k8s", "k8s-nodes"]
  vars = {
    ansible_user                 = "ec2-user"
    ansible_ssh_private_key_file = var.private_key_path
  }
}

resource "ansible_host" "azure_k8s_node" {
  count              = var.azure_nodes
  inventory_hostname = azurerm_linux_virtual_machine.k8s_worker[count.index].public_ip_address
  groups             = ["azure-k8s-node-${count.index}", "azure-k8s-nodes", "k8s-nodes"]
  vars = {
    ansible_user                 = "adminuser"
    ansible_ssh_private_key_file = var.private_key_path
  }
}

resource "ansible_host" "gcp_k8s_node" {
  count              = var.gcp_nodes
  inventory_hostname = google_compute_instance.k8s_worker[count.index].network_interface.0.access_config.0.nat_ip
  groups             = ["gcp-k8s-node-${count.index}", "gcp-k8s-nodes", "k8s-nodes"]
  vars = {
    ansible_user                 = "dev"
    ansible_ssh_private_key_file = var.private_key_path
  }
}