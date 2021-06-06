###################################################
######## Configure instances using ansible ########
###################################################

resource "null_resource" "configure_aws_k8s_master" {
  depends_on = [aws_instance.k8s_master, ansible_host.aws_k8s_master]

  provisioner "local-exec" {
    command = "ansible-playbook ansible/aws/configure-k8s-master.yaml -i ansible-inventory"
  }
}

resource "null_resource" "configure_aws_k8s_worker" {
  depends_on = [null_resource.configure_aws_k8s_master, aws_instance.k8s_worker, ansible_host.aws_k8s_node]

  triggers = {
    cluster_instance_ids = join(", ", aws_instance.k8s_worker.*.id)
  }

  provisioner "local-exec" {
    command = "ansible-playbook ansible/aws/configure-k8s-worker.yaml -i terraform.py"
  }
}

resource "null_resource" "configure_gcp_k8s_worker" {
  depends_on = [null_resource.configure_aws_k8s_master, google_compute_instance.k8s_worker, ansible_host.gcp_k8s_node]

  triggers = {
    cluster_instance_ids = join(", ", google_compute_instance.k8s_worker.*.id)
  }

  provisioner "local-exec" {
    command = "ansible-playbook ansible/gcp/configure-k8s-worker.yaml -i ansible-inventory"
  }
}

resource "null_resource" "configure_azure_k8s_worker" {
  depends_on = [null_resource.configure_aws_k8s_master, azurerm_linux_virtual_machine.k8s_worker, ansible_host.azure_k8s_node]

  triggers = {
    cluster_instance_ids = join(", ", azurerm_linux_virtual_machine.k8s_worker.*.id)
  }

  provisioner "local-exec" {
    command = "ansible-playbook ansible/azure/configure-k8s-worker.yaml -i ansible-inventory"
  }
}