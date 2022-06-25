# Introduction

This repository contains content that I use to setup Ansible Tower / Ansible Automation Platform environments. The main supported backend will be `libvirt`. Feel free to modify the `Vagrantfile` to support Virtualbox. Ansible should also be installed in some way on the host system.

# Setup
## Vagrant
- Configure the Vagrantfile variables (near the top of the file) to values that are suitable for the environment you are trying to build

- Boot up the environment
  ```
  vagrant up
  ```

- Export the ssh-config for the environment. This is an important step as ansible is configured to read this config file when making a connection to the servers.
  ```
  vagrant ssh-config > .ssh-config
  ```

## Ansible
- Install collections
  ```
  ansible-galaxy collection install -r requirements.yml
  ```

# Usage
## Rebuilding
- Destroy the Vagrant environment
  ```
  vagrant destroy -f
  ```

- Create the new Vagrant environment
  ```
  vagrant up
  ```

- Create new `.ssh-config` file for the new environment
  ```
  vagrant ssh-config > .ssh-config
  ```

- Make any adjustments to `inventory` file

## Connecting to hosts manually
- Run the following command
  ```
  ssh -F .ssh-config $HOSTNAME
  ```

## Windows
- Change into the `windows/` directory
  ```
  cd windows
  ```

- Create the Windows server
  ```
  vagrant up
  ```