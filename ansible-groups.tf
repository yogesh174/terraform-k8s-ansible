resource "ansible_group" "aws_k8s_nodes" {
  inventory_group_name = "aws-k8s-nodes"
  children             = [for i in range(var.aws_nodes) : format("aws-k8s-node-%d", i)]
}

resource "ansible_group" "aws_k8s" {
  inventory_group_name = "aws-k8s"
  children             = ["aws-k8s-master", "aws-k8s-nodes"]
}

resource "ansible_group" "azure_k8s_nodes" {
  inventory_group_name = "azure-k8s-nodes"
  children             = [for i in range(var.azure_nodes) : format("azure-k8s-node-%d", i)]
}

resource "ansible_group" "gcp_k8s_nodes" {
  inventory_group_name = "gcp-k8s-nodes"
  children             = [for i in range(var.gcp_nodes) : format("gcp-k8s-node-%d", i)]
}

resource "ansible_group" "k8s-nodes" {
  inventory_group_name = "k8s-nodes"
  children             = ["gcp-k8s-nodes", "aws-k8s-nodes", "azure-k8s-nodes"]
}