#############################################
######## Add pub ssh key to instance ########
#############################################

resource "google_compute_project_metadata" "my_ssh_key" {
  metadata = {
    ssh-keys = <<EOF
      dev: ${file(var.public_key_path)}
    EOF
  }
}

#########################################
######## Create k8s worker nodes ########
#########################################

resource "google_compute_instance" "k8s_worker" {
  count        = var.gcp_nodes
  name         = "gcp-k8s-worker-${count.index}"
  machine_type = var.gcp_machine_type
  zone         = var.gcp_zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"
    access_config {}
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