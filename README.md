# Introduction

This repository contains content used to set up Ansible Tower / Ansible Automation Platform environments.

# Setup

Install Terraform, Ansible 2.16, and `jq` before running the playbooks. Ansible can be installed in a virtual environment with:

```sh
python3 -m venv .env && ./.env/bin/pip install --upgrade 'ansible-core<2.17' pip setuptools
```

Obtain an Ansible Automation Platform manifest from the [Red Hat documentation](https://docs.redhat.com/en/documentation/red_hat_ansible_automation_platform/2.5/html/access_management_and_authentication/assembly-gateway-licensing) and an offline access token from https://console.redhat.com/ansible/automation-hub/token.

# Libvirt (default)

The default backend is local libvirt. Install QEMU/KVM, libvirt, the Terraform libvirt provider prerequisites, and `qemu-img`; enable/start the libvirt daemon and ensure your user can connect to the selected URI. `qemu:///system` generally requires appropriate libvirt group/polkit permissions. Libvirt must also be able to read the configured image directory. System libvirt may be confined by SELinux or run with access restrictions: arrange read access through your host's supported policy rather than changing/copying the base images as part of provisioning. Alternatively use a suitable session URI/pool and configure `libvirt_uri`, `libvirt_pool`, and `libvirt_network` accordingly.

RHEL KVM images require a Red Hat account and applicable subscription/download entitlement. Manually download the QCOW2 images from the [Red Hat Customer Portal](https://access.redhat.com/downloads/content/rhel) and put these exact files in `~/Documents/iso`:

- `rhel-8.10-x86_64-kvm.qcow2`
- `rhel-9.8-x86_64-kvm.qcow2`
- `rhel-10.2-x86_64-kvm.qcow2`

Terraform expands `~` using the local Terraform user's home. Check an image before provisioning, for example:

```sh
qemu-img info ~/Documents/iso/rhel-9.8-x86_64-kvm.qcow2
```

A valid QCOW2 header does not prove that an image boots, has cloud-init installed/enabled, or accepts SSH as `cloud-user`. Test each image with one VM before scaling up. The downloaded images have 10 GiB virtual capacity. Terraform keeps an instance-local copy as a backing image and creates a writable copy-on-write VM disk with 75 GiB capacity by default (`libvirt_disk_size_gib`). The original downloads remain unchanged. The guest root partition/filesystem must also grow to use the added capacity; verify with `lsblk` and `df -h` after boot, and grow it if the image does not do so automatically.

The Terraform cloud-init data configures `libvirt_ssh_user` (default `cloud-user`) and installs the key in `libvirt_ssh_public_key` (default `~/.ssh/id_rsa.pub`). Verify that the downloaded image supports this cloud-init behavior. Each AAP component has an `*_os_version` selector accepting `rhel8`, `rhel9`, or `rhel10`; selectors default to RHEL 10 and map to provider-specific image identifiers automatically. Managed nodes are provisioned once per configured node count for each of RHEL 8, 9, and 10. Sizing is configurable through `libvirt_aap_*` and `libvirt_managed_*` inputs.

Initialize and apply:

```sh
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform validate
terraform plan
terraform apply
terraform output -json instances
```

The default `default` libvirt network typically provides DHCP/NAT rather than inbound reachability from every host. `wait_for_lease` can report addresses when the network/guest reports leases; if addresses are absent, use DHCP reservations or enter reachable addresses manually in `inventories/hosts.yml`. Configure firewall/routing as required. Do not assume the OpenStack security group/floating-IP behavior exists on libvirt.

**Keep backend state separate.** Use separate working directories/state files (for example, separate Terraform workspaces only if their state separation is explicitly maintained) for libvirt and OpenStack. Never change `compute_backend` in a state that already manages resources from the other provider: Terraform can plan destruction of resources that are no longer selected. Always inspect the full plan before applying.

# OpenStack alternative

To retain the existing OpenStack workflow, use a dedicated state and set `compute_backend = "openstack"`. Configure `$HOME/.config/openstack/clouds.yaml` and create an OpenStack key pair named `${username}-rsa`. The standardized `*_os_version` selectors map to OpenStack image release names; the same selector values map to local QCOW2 images for Libvirt.

```sh
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars: compute_backend = "openstack"
terraform init
terraform plan
terraform apply
terraform output -json instances
```

OpenStack continues to use the existing cloud, flavor, network, security-group, image and key-pair settings. Do not apply using a libvirt state.

# Server configuration

Populate `inventories/hosts.yml` with reachable addresses from the Terraform `instances` output (or DHCP reservations/manual entries where lease reporting is unavailable), and use the login appropriate for the chosen backend/image. Install collections and roles, then run the baseline playbook:

```sh
ansible-galaxy collection install -r requirements.yml
ansible-galaxy role install -r requirements.yml
ansible-playbook site.yml -vv -b --ask-vault-pass
```
