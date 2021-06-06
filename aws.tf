################################################
######## Create keypair for k8s cluster ########
################################################

resource "aws_key_pair" "terraform_k8s" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

########################################
######## Create k8s master node ########
########################################

resource "aws_instance" "k8s_master" {
  ami           = data.aws_ami.amazon_linux_2.image_id
  instance_type = var.aws_instance_type

  tags = {
    Name    = "aws-k8s-master"
  }

  key_name = aws_key_pair.terraform_k8s.key_name
}

#########################################
######## Create k8s worker nodes ########
#########################################

resource "aws_instance" "k8s_worker" {
  count         = var.aws_nodes
  ami           = data.aws_ami.amazon_linux_2.image_id
  instance_type = var.aws_instance_type

  # Created after and destroyed before master node 
  depends_on = [
    aws_instance.k8s_master,
  ]

  tags = {
    Name    = "aws-k8s-worker-${count.index}"
  }

  key_name = aws_key_pair.terraform_k8s.key_name

  provisioner "local-exec" {
    when    = destroy
    command = "ansible-playbook ansible/destroy-k8s-worker.yaml -i ansible-inventory -e 'node=${self.private_dns}'"
  }
}