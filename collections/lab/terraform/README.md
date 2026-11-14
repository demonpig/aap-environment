# lab.terraform

Ansible collection for the Terraform-managed Ansible Automation Platform lab environment. The `playbooks/baseline.yml` playbook groups hosts by distribution, registers RHEL hosts, enables only BaseOS and AppStream, applies the baseline configuration, updates packages, and reboots hosts when required.

## Requirements

- `ansible-core` 2.16 or newer
- `ansible.posix`
- `community.general`

From the repository root, `./setup.sh` creates the virtual environment, installs missing Python and collection dependencies, and launches the baseline playbook.

## Run the baseline

After applying the infrastructure from the repository root, the default inventory automatically reads the `instances` output using `terraform` or `tofu`. No inventory file edits are needed; Terraform must report reachable addresses for the hosts. Put `rhel_username` and `rhel_password` in `~/.ansible/secrets.yml`, then run `./setup.sh` from the repository root.

The inventory carries the default login, SSH key, and RHEL 8/9/10 group variables. Collection roles divide the workflow into RHSM registration/repository setup, baseline host configuration, and package patching. Collection metadata is defined in `galaxy.yml`; `meta/runtime.yml` declares the minimum supported Ansible version.
