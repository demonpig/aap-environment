# Introduction

This repository contains content that I use to setup Ansible Tower / Ansible Automation Platform environments.

# Setup

Make sure to do the following prior to running any playbook within this repository.

- Install the following programs

  - [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

  - [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

  - `jq`

- Obtain an Ansible Automation Platform [manifest file](https://docs.redhat.com/en/documentation/red_hat_ansible_automation_platform/2.5/html/access_management_and_authentication/assembly-gateway-licensing)

- Get offline access token from https://console.redhat.com/ansible/automation-hub/token

- Setup a `$HOME/.config/openstack/clouds.yaml`

- Make sure that the SSH key name, within OpenStack, is following `${USERNAME}-rsa`

# Openstack

- Change into the `openstack` directory

  ```
  cd environments/openstack
  ```

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
  terraform show -json | jq -r '.values.root_module.resources[] | .name + " ansible_host=" + .values.access_ip_v4'
  ```

You can use the output from the above function and apply it to the `inventories/hosts` file.

# Server Configuration

- Copy the manifest file to `~/.ansible/manifest.zip`

- Fill in the missing `token` fields within the `ansible.cfg` with the offline access token from console.redhat.com

- Fill out the `inventories/hosts` file using the output from the `terraform` command (see above)


- Install the some general collections

  ```
  ansible-galaxy collection install -r collections/requirements.yml
  ```

- Install one set of collections for either AAP 2.4 or 2.5

  ```
  # AAP 2.5
  ansible-galaxy collection install -f -r collections/requirements.aap.yml
  ```
  ```
  # AAP 2.4
  ansible-galaxy collection install -f -r collections/requirements.aap24.yml
  ```

- Run the server configuration playbook to apply a baseline configuration and update / reboot them

  ```
  ansible-playbook -i inventories/hosts playbooks/servers/pipeline.yml -vv -b --ask-vault-pass
  ```