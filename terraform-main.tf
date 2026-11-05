terraform {
  required_version = ">= 0.14.0"

  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
    }
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.8.3"
    }
  }
}

locals {
  libvirt_image_dir = pathexpand(var.libvirt_image_dir)

  # Stable OS-version names map to the provider-specific image identifiers.
  os_versions = {
    rhel8 = {
      libvirt_image     = "${local.libvirt_image_dir}/rhel-8.10-x86_64-kvm.qcow2"
      openstack_release = "RHEL-8.6.0-x86_64-released"
    }
    rhel9 = {
      libvirt_image     = "${local.libvirt_image_dir}/rhel-9.8-x86_64-kvm.qcow2"
      openstack_release = "RHEL-9.0.0-x86_64-released"
    }
    rhel10 = {
      libvirt_image     = "${local.libvirt_image_dir}/rhel-10.2-x86_64-kvm.qcow2"
      openstack_release = "RHEL-10.1-x86_64-ga-latest"
    }
  }

  # Role selectors use the standard version keys above for either provider.
  libvirt_role_images = {
    controller     = var.controller_os_version
    eda            = var.eda_os_version
    gateway        = var.gateway_os_version
    automation_hub = var.automation_hub_os_version
    database       = var.database_os_version
    execution_node = var.execution_node_os_version
    managed_rhel8  = "rhel8"
    managed_rhel9  = "rhel9"
    managed_rhel10 = "rhel10"
  }

  libvirt_role_counts = {
    controller     = var.controller_count
    eda            = var.eda_count
    gateway        = var.gateway_count
    automation_hub = var.automation_hub_count
    database       = var.database_count
    execution_node = var.execution_node_count
    managed_rhel8  = var.managed_node_count
    managed_rhel9  = var.managed_node_count
    managed_rhel10 = var.managed_node_count
  }

  libvirt_role_names = {
    controller     = "controller"
    eda            = "eda"
    gateway        = "gateway"
    automation_hub = "automation_hub"
    database       = "database"
    execution_node = "execution_node"
    managed_rhel8  = "managed_rhel8"
    managed_rhel9  = "managed"
    managed_rhel10 = "managed_rhel10"
  }

  libvirt_instances = {
    for instance in flatten([
      for role, count in local.libvirt_role_counts : [
        for index in range(count) : {
          key   = "${role}-${index + 1}"
          role  = role
          index = index + 1
        }
      ]
      ]) : instance.key => {
      role  = instance.role
      index = instance.index
      name  = "${var.username}_aap_${var.aap_version}_${local.libvirt_role_names[instance.role]}_${instance.index}"
      image = local.os_versions[local.libvirt_role_images[instance.role]].libvirt_image
    }
    if var.compute_backend == "libvirt"
  }
}
