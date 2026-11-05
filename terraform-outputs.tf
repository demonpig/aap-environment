output "instances" {
  description = "Provisioned instances keyed by name, with addresses when available."
  value = var.compute_backend == "libvirt" ? {
    for key, domain in libvirt_domain.instance : domain.name => {
      addresses = tolist(try(domain.network_interface[0].addresses, []))
    }
    } : {
    for instance in concat(
      openstack_compute_instance_v2.controller,
      openstack_compute_instance_v2.eda,
      openstack_compute_instance_v2.gateway,
      openstack_compute_instance_v2.automation_hub,
      openstack_compute_instance_v2.database,
      openstack_compute_instance_v2.execution_node,
      openstack_compute_instance_v2.managed_rhel10,
      openstack_compute_instance_v2.managed_rhel9,
      openstack_compute_instance_v2.managed_rhel8
      ) : instance.name => {
      addresses = compact([try(instance.access_ip_v4, "")])
    }
  }
}

output "libvirt_addresses_note" {
  description = "Libvirt guest addresses require a running guest and DHCP lease reporting; an empty list means add the address to inventory manually or configure DHCP reservation."
  value       = var.compute_backend == "libvirt" ? "Check instances addresses; use DHCP reservations/manual inventory if lease reporting is unavailable." : null
}
