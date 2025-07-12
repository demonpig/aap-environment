
import datetime

from ansible.errors import AnsibleFilterError

def create_aap_group_dict(a, name='', **kwargs):
    host_list = a if isinstance(a, list) else []
    if not name or not host_list:
        return {}
    hosts = {i:'' for i in host_list}
    return {name: hosts}


class FilterModule(object):
    def filters(self):
        return {
            'create_aap_group_dict': create_aap_group_dict
        }