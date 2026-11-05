provider "libvirt" {
  uri = var.libvirt_uri
}

# Keep an instance-local copy of the downloaded source image as the backing disk.
resource "libvirt_volume" "instance" {
  for_each = local.libvirt_instances
  name     = "${each.value.name}.qcow2"
  pool     = var.libvirt_pool
  source   = each.value.image
  format   = "qcow2"
}

# Use a writable copy-on-write disk large enough for the guest workload.
resource "libvirt_volume" "writable" {
  for_each       = local.libvirt_instances
  name           = "${each.value.name}-disk.qcow2"
  pool           = var.libvirt_pool
  base_volume_id = libvirt_volume.instance[each.key].id
  size           = var.libvirt_disk_size_gib * 1024 * 1024 * 1024
  format         = "qcow2"
}

resource "libvirt_cloudinit_disk" "instance" {
  for_each = local.libvirt_instances
  name     = "${each.value.name}-cloudinit.iso"
  pool     = var.libvirt_pool
  user_data = templatefile("${path.module}/cloud-init-user-data.yaml.tftpl", {
    username   = var.libvirt_ssh_user
    public_key = trimspace(file(pathexpand(var.libvirt_ssh_public_key)))
  })
}

resource "libvirt_domain" "instance" {
  for_each  = local.libvirt_instances
  name      = each.value.name
  memory    = contains(["managed_rhel8", "managed_rhel9", "managed_rhel10", "execution_node"], each.value.role) ? var.libvirt_managed_memory_mb : var.libvirt_aap_memory_mb
  vcpu      = contains(["managed_rhel8", "managed_rhel9", "managed_rhel10", "execution_node"], each.value.role) ? var.libvirt_managed_vcpu : var.libvirt_aap_vcpu
  cloudinit = libvirt_cloudinit_disk.instance[each.key].id

  # RHEL 9 requires x86-64-v2; the provider's default qemu64 CPU model lacks it.
  # Host passthrough keeps the selected CPU mode stable in libvirt's domain XML.
  cpu {
    mode = "host-passthrough"
  }

  disk { volume_id = libvirt_volume.writable[each.key].id }
  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  network_interface {
    network_name   = var.libvirt_network
    wait_for_lease = true
  }
}
