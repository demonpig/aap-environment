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
  query:
    description:
      - Provides a set of operators for use with filters, condition builders, and encoded queries.
      - The data type of a field determines what operators are available for it.
        Refer to the ServiceNow Available Filters Queries documentation at
        U(https://docs.servicenow.com/bundle/tokyo-platform-user-interface/page/use/common-ui-elements/reference/r_OpAvailableFiltersQueries.html).
      - Mutually exclusive with C(sysparm_query).
    type: list
    elements: dict
"""

import random
import string

from ansible.plugins.inventory import BaseInventoryPlugin


def create_servicenow_instance(name):
    return {
      "attestation_status": "Not Yet Reviewed",
      "attested": False,
      "category": "Hardware",
      "classification": "Production",
      "comments": "Theme: RTS",
      "cost_cc": "USD",
      "default_gateway": "169.0.0.1",
      "dns_domain": "example.com",
      "environment": 'production',
      "environment": "requirements",
      "firewall_status": "Intranet",
      "fqdn": f"{name}.example.com",
      "hardware_status": "retired",
      "host_name": name,
      "install_status": "7",
      "internet_facing": False,
      "location": "USA",
      "monitor": False,
      "name": name,
      "operational_status": "6",
      "os_version": "10.0",
      "os": "Linux Red Hat",
      "serial_number": random.randint(1000,9999),
      "short_description": f"{name} - production",
      "skip_sync": False,
      "subcategory": "Computer",
      "sys_class_name": "cmdb_ci_linux_server",
      "sys_class_path": "/!!/!2/!(/!!/!0",
      "sys_domain_path": "/",
      "sys_mod_count": "6",
      "u_actual_retirement_date": "2000-01-01",
      "u_business_identifier": 73,
      "u_business_thing": "Software",
      "u_discovery_exception": "technology limitation",
      "u_evacuated": "No",
      "u_exempt": False,
      "u_ip_numeric_value": "127127127127",
      "u_is_modifiable": False,
      "u_owned_by_override": False,
      "u_protected": False,
      "u_reboot_required": False,
      "u_related_cis_in_legal_hold": False,
      "u_related_to_atc": False,
      "u_soc_1_rebates": "Not Assessed",
      "u_sox_soc": False,
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

        for query in self.get_option('query'):
          for k, v in query.items():
              self.display.v(k)
              self.display.v(v)

        count = self.get_option('count')
        self.display.vv(f"Inventory Count: {count}")
        for i in range(0, count):
            name = ''.join(random.choices(string.ascii_uppercase + string.digits, k=12))
            hostvars = create_servicenow_instance(name)

            self.inventory.add_host(name)
            for k,v in hostvars.items():
                self.inventory.set_variable(name, k, v)