# -*- coding: utf-8 -*-

from __future__ import absolute_import, division, print_function

__metaclass__ = type

DOCUMENTATION = r'''
name: terraform
plugin_type: inventory
short_description: Build inventory from Terraform instance outputs
version_added: 1.0.0
author:
  - Max Mitschke
requirements:
  - Terraform CLI available on the controller
options:
  plugin:
    description: Token that ensures this is a source file for the terraform inventory plugin.
    required: true
    choices: [lab.terraform.terraform]
  terraform_dir:
    description: Terraform working directory, relative to this inventory source file or absolute.
    type: str
    required: true
  output_name:
    description: Terraform output containing the instance map.
    type: str
    default: instances
  terraform_binary:
    description: Executable to run. Defaults to terraform, falling back to tofu when Terraform is unavailable.
    type: str
  timeout:
    description: Maximum time in seconds to wait for Terraform.
    type: int
    default: 60
  hostvars:
    description: Variables to set on every Terraform host.
    type: dict
    default: {}
  group_vars:
    description: Variables to set on named inventory groups. Groups are created if needed.
    type: dict
    default: {}
'''

import json
import os
import shutil
import subprocess

from ansible.errors import AnsibleParserError
from ansible.plugins.inventory import BaseInventoryPlugin


class InventoryModule(BaseInventoryPlugin):
    NAME = 'lab.terraform.terraform'

    def verify_file(self, path):
        return super(InventoryModule, self).verify_file(path) and path.endswith(('terraform.yml', 'terraform.yaml'))

    def parse(self, inventory, loader, path, cache=True):
        super(InventoryModule, self).parse(inventory, loader, path, cache)
        self._read_config_data(path)

        terraform_dir = self.get_option('terraform_dir')
        if not os.path.isabs(terraform_dir):
            terraform_dir = os.path.join(os.path.dirname(os.path.abspath(path)), terraform_dir)
        terraform_dir = os.path.abspath(terraform_dir)

        terraform_binary = self.get_option('terraform_binary')
        if not terraform_binary:
            terraform_binary = shutil.which('terraform') or shutil.which('tofu')
        if not terraform_binary:
            raise AnsibleParserError(
                'Neither Terraform nor OpenTofu was found on PATH; install one or set terraform_binary.'
            )

        command = [
            terraform_binary,
            'output',
            '-json',
            self.get_option('output_name'),
        ]
        try:
            result = subprocess.run(
                command,
                cwd=terraform_dir,
                check=True,
                capture_output=True,
                text=True,
                timeout=self.get_option('timeout'),
            )
            instances = json.loads(result.stdout)
        except (OSError, subprocess.SubprocessError, json.JSONDecodeError) as exc:
            stderr = getattr(exc, 'stderr', None)
            detail = stderr.strip() if stderr else str(exc)
            raise AnsibleParserError(
                'Unable to read Terraform output {0!r} from {1}: {2}'.format(
                    self.get_option('output_name'), terraform_dir, detail
                )
            )

        if not isinstance(instances, dict):
            raise AnsibleParserError(
                'Terraform output {0!r} must be a map of host names to instance data'.format(
                    self.get_option('output_name')
                )
            )

        for group_name, variables in self.get_option('group_vars').items():
            self.inventory.add_group(group_name)
            for key, value in variables.items():
                self.inventory.set_variable(group_name, key, value)

        common_hostvars = self.get_option('hostvars')
        for hostname, instance in instances.items():
            if not isinstance(instance, dict):
                raise AnsibleParserError(
                    'Terraform instance {0!r} must contain a map of attributes'.format(hostname)
                )

            addresses = instance.get('addresses', [])
            if not isinstance(addresses, list):
                raise AnsibleParserError(
                    'Terraform instance {0!r} has a non-list addresses value'.format(hostname)
                )

            self.inventory.add_host(host=hostname)
            for key, value in common_hostvars.items():
                self.inventory.set_variable(hostname, key, value)
            self.inventory.set_variable(hostname, 'terraform_addresses', addresses)
            if addresses:
                self.inventory.set_variable(hostname, 'ansible_host', addresses[0])
