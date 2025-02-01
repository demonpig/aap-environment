# -*- coding: utf-8 -*-


from __future__ import absolute_import, division, print_function

__metaclass__ = type


DOCUMENTATION = r"""
name: dynamic_servicenow
author:
  - Max Mitschke <maxmitschke@fastmail.com>
short_description: Inventory source for ServiceNow table records.
description:
  - Builds inventory from ServiceNow table records.
version_added: 1.0.0
extends_documentation_fragment: []
notes: []
options:
  plugin:
    description:
      - The name of the ServiceNow Inventory Plugin.
      - This should always be C(dynamic_servicenow).
    required: true
    type: str
    choices: [ dynamic_servicenow ]
  count:
    description:
      - Number of hosts to generate
    required: false
    type: integer
    default: 10
"""

import random
import string

from ansible.plugins.inventory import BaseInventoryPlugin


def create_servicenow_instance(name):
    return {
      "environment": 'production',
      "fqdn": f"{name}.example.com",
      "location": "USA",
      "name": name,
      "os_version": "10.0",
      "os": "Linux Red Hat",
      "serial_number": random.randint(1000,9999),
      "short_description": f"{name} - production",
      "sys_class_name": "cmdb_ci_linux_server",
      "u_business_identifier": 73,
      "u_business_thing": "Software",
      "virtual": False,

      # ansible specific variables
      "ansible_host": "127.0.0.1",
      "ansible_connection": "local"
    }


class InventoryModule(BaseInventoryPlugin):

    NAME = 'dynamic_servicenow'

    def verify_file(self, path):
        ''' return true/false if this is possibly a valid file for this plugin to consume '''
        return True

    def parse(self, inventory, loader, path, cache=True):

        # call base method to ensure properties are available for use with other helper methods
        super(InventoryModule, self).parse(inventory, loader, path, cache)
        self._read_config_data(path=path)

        count = self.get_option('count')
        self.display.vv(f"Inventory Count: {count}")
        for i in range(0, count):
            name = ''.join(random.choices(string.ascii_uppercase + string.digits, k=12))
            hostvars = create_servicenow_instance(name)

            self.inventory.add_host(name)
            for k,v in hostvars.items():
                self.inventory.set_variable(name, k, v)