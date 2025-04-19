# Define required providers

terraform {
  # Version of terraform cli to use within this project
  required_version = ">= 0.14.0"

  # Version of providers
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
    }
  }
}

provider "openstack" {
  cloud = "openstack"
}

locals {
    rhel9_os_release = "RHEL-9.0.0-x86_64-released"
    rhel8_os_release = "RHEL-8.6.0-x86_64-released"
}

# Ansible Automation Platform Environment

resource "openstack_compute_instance_v2" "controller" {
  name = "${var.username}_aap_${var.aap_version}_controller_${count.index + 1}"
  image_name = coalesce(var.controller_os_release, local.rhel9_os_release)
  flavor_name = "g.memory.medium"
  count = var.controller_count

  key_pair = "${var.username}-rsa"
  security_groups = ["default"]

  network {
      name = "provider_net_shared_3"
  }

  metadata = {
    description = "Automation Controller"
  }
}

resource "openstack_compute_instance_v2" "eda" {
  name = "${var.username}_aap_${var.aap_version}_eda_${count.index + 1}"
  image_name = coalesce(var.eda_os_release, local.rhel9_os_release)
  flavor_name = "g.memory.medium"
  count = var.eda_count

  key_pair = "${var.username}-rsa"
  security_groups = ["default"]

  network {
      name = "provider_net_shared_3"
  }

  metadata = {
    description = "EDA Server"
  }
}

resource "openstack_compute_instance_v2" "gateway" {
  name = "${var.username}_aap_${var.aap_version}_gateway_${count.index + 1}"
  image_name = coalesce(var.gateway_os_release, local.rhel9_os_release)
  flavor_name = "g.memory.medium"
  count = var.gateway_count

  key_pair = "${var.username}-rsa"
  security_groups = ["default"]

  network {
      name = "provider_net_shared_3"
  }

  metadata = {
    description = "Automation Gateway"
  }
}

resource "openstack_compute_instance_v2" "automation_hub" {
  name = "${var.username}_aap_${var.aap_version}_automation_hub_${count.index + 1}"
  image_name = coalesce(var.automation_hub_os_release, local.rhel9_os_release)
  flavor_name = "g.memory.medium"
  count = var.automation_hub_count

  key_pair = "${var.username}-rsa"
  security_groups = ["default"]

  network {
      name = "provider_net_shared_3"
  }

  metadata = {
    description = "Automation Hub"
  }
}

resource "openstack_compute_instance_v2" "database" {
  name = "${var.username}_aap_${var.aap_version}_database_${count.index + 1}"
  image_name = coalesce(var.database_os_release, local.rhel9_os_release)
  flavor_name = "g.disk.medium"
  count = var.database_count

  key_pair = "${var.username}-rsa"
  security_groups = ["default"]

  network {
      name = "provider_net_shared_3"
  }

  metadata = {
    description = "Database"
  }
}

resource "openstack_compute_instance_v2" "execution_node" {
  name = "${var.username}_aap_${var.aap_version}_execution_node_${count.index + 1}"
  image_name = coalesce(var.execution_node_os_release, local.rhel9_os_release)
  flavor_name = "m1.medium"
  count = var.execution_node_count

  key_pair = "${var.username}-rsa"
  security_groups = ["default"]

  network {
      name = "provider_net_shared_3"
  }

  metadata = {
    description = "Execution Node"
  }
}

resource "openstack_compute_instance_v2" "managed" {
  name = "${var.username}_aap_${var.aap_version}_managed_${count.index + 1}"
  image_name = "${local.rhel9_os_release}"
  flavor_name = "m1.medium"
  count = var.managed_node_count

  key_pair = "${var.username}-rsa"
  security_groups = ["default"]

  network {
      name = "provider_net_shared_3"
  }

  metadata = {
    description = "Managed System"
  }
}

resource "openstack_compute_instance_v2" "managed_rhel8" {
  name = "${var.username}_aap_${var.aap_version}_managed_rhel8_${count.index + 1}"
  image_name = "${local.rhel8_os_release}"
  flavor_name = "m1.medium"
  count = var.managed_node_count

  key_pair = "${var.username}-rsa"
  security_groups = ["default"]

  network {
      name = "provider_net_shared_3"
  }

  metadata = {
    description = "Managed System (RHEL 8)"
  }
}