# Introduction

This repository contains content that I use to setup Ansible Tower / Ansible Automation Platform environments.

# Setup
- [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [Install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

# Openstack
Before proceeding, make sure to setup a `$HOME/.config/openstack/clouds.yaml` file. One thing to note is that the SSH key, within Openstack, needs to be named `${USERNAME}-rsa`.

- Change into the `openstack` directory
- Initialize terraform
  ```
  terraform init
  ```

- Create a `terraform.tfvars` file with the following default content
  ```
  username = ""
  aap_version = ""
  ```

- Add additional variables from `terraform-defaults.tf` to the `terraform.tfvars` to further configure the environment
- Apply the configuration to Openstack
  ```
  terraform apply
  ```

- Show the configuration to get the IPs of the servers
  ```
  terraform show
  ```

At a later point, I will be working on using Ansible to execute Terraform and then to install Ansible Automation Platform.