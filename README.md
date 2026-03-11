# Introduction

This repository contains content that I use to setup Ansible Tower / Ansible Automation Platform environments.

# Setup

Make sure to do the following prior to running any playbook within this repository.

- Install the following programs

  - [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

  - [Ansible 2.16](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

    ```
    python3 -m venv .env && ./.env/bin/pip install --upgrade 'ansible-core<2.17' pip setuptools
    ```

  - `jq`

- Obtain an Ansible Automation Platform [manifest file](https://docs.redhat.com/en/documentation/red_hat_ansible_automation_platform/2.5/html/access_management_and_authentication/assembly-gateway-licensing)

- Get offline access token from https://console.redhat.com/ansible/automation-hub/token

- Setup a `$HOME/.config/openstack/clouds.yaml`

- Make sure that the SSH key name, within OpenStack, is following `${USERNAME}-rsa`

# Openstack

- Initialize terraform

  ```
  terraform init
  ```

- Create a `terraform.tfvars` file using the provided `terraform.tfvars.example` file

  ```
  cp terraform.tfvars.example terraform.tfvars
  ```

- Fill out the `terraform.tfvars` file

- Apply the configuration to Openstack

  ```
  terraform apply -auto-approve
  ```

- Wait for Terraform to finish provisioning your environment

- Run the following command to get a list of all servers and their IPs

  ```
  terraform show -json | jq -r '.values.root_module.resources[] | .name + " : " + .values.access_ip_v4'
  ```

You can use the output from the above function and apply it to the `inventories/hosts` file.

# Server Configuration

- Fill out the `inventories/hosts` file using the output from the `terraform` command (see above)


- Install some collections / roles

  ```
  ansible-galaxy collection install -r requirements.yml
  ```
  ```
  ansible-galaxy role install -r requirements.yml
  ```

- Run the server configuration playbook to apply a baseline configuration and update / reboot them

  ```
  ansible-playbook site.yml -vv -b --ask-vault-pass
  ```