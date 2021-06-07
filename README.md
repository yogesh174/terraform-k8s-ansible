# terraform-k8s-ansible
Create a multi cloud K8s cluster with Terraform and Ansible

# Quickstart

## One time setup

- Install terraform, ansible, AWS cli and Azure cli

- Login to your AWS cli and Azure cli

- Clone the repo
    ```
    git clone https://github.com/yogesh174/terraform-k8s-ansible.git
    cd terraform-k8s-ansible
    ```

- Create a private and public key for instances
    ```
    ssh-keygen -t rsa -f terraform.pem -N ""
    ```

- Create a GCP project, enable Compute Engine API and a key to it. Then download in json format to your workspace.

- Provide the GCP info to `gcp_credentials_path` and `gcp_project` in terraform.tfvars.

- Initialize Terraform
    ```
    terraform init
    ```

- Download the ansible dynamic script
    ```
    wget https://github.com/jtopjian/ansible-terraform-inventory/releases/download/v0.3.0/ansible-terraform-inventory_v0.3.0_linux_amd64.zip

    unzip ansible-terraform-inventory_v0.3.0_linux_amd64.zip && rm ansible-terraform-inventory_v0.3.0_linux_amd64.zip

    mv ansible-terraform-inventory_v0.3.0_x4 ansible-inventory 
    ```

## Spin up your cluster

- Create a k8s cluster
    ```
    terraform apply -auto-approve
    ```

    The k8s config file will be downloaded to `kubeconfig` folder in your workspce.

- You can scale the nodes up and down by changing `aws_nodes`, `gcp_nodes` and `azure_nodes` variables.

- Destroy a k8s cluster
    ```
    terraform destroy -auto-approve
    ```