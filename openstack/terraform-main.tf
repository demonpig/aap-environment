# Define required providers

terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
  }
}

provider "openstack" {
  cloud = "openstack"
}


# Ansible Automation Platform Environment

resource "openstack_compute_instance_v2" "controller" {
  name = "${var.username}_aap_${var.aap_version}_controller_${count.index + 1}"
  image_name = "${var.os_release}"
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
  image_name = "${var.os_release}"
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

resource "openstack_compute_instance_v2" "database" {
  name = "${var.username}_aap_${var.aap_version}_database_${count.index + 1}"
  image_name = "${var.os_release}"
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

resource "openstack_compute_instance_v2" "automation_hub" {
  name = "${var.username}_aap_${var.aap_version}_automation_hub_${count.index + 1}"
  image_name = "${var.os_release}"
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

resource "openstack_compute_instance_v2" "execution_node" {
  name = "${var.username}_aap_${var.aap_version}_execution_node_${count.index + 1}"
  image_name = "${var.os_release}"
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

resource "openstack_compute_instance_v2" "sso" {
  name = "${var.username}_aap_${var.aap_version}_sso_${count.index + 1}"
  image_name = "${var.os_release}"
  flavor_name = "g.memory.medium"
  count = var.sso_count

  key_pair = "${var.username}-rsa"
  security_groups = ["default"]

  network {
      name = "provider_net_shared_3"
  }

  metadata = {
    description = "Red Hat SSO"
  }
}

resource "openstack_compute_instance_v2" "managed" {
  name = "${var.username}_aap_${var.aap_version}_managed_${count.index + 1}"
  image_name = "${var.os_release_managed}"
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
  image_name = "RHEL-8.6.0-x86_64-released"
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

resource "openstack_compute_instance_v2" "windows" {
  name = "${var.username}_aap_${var.aap_version}_windows_${count.index + 1}"
  image_name = "${var.os_release_windows}"
  flavor_name = "g.standard.medium"
  count = var.windows_count

  security_groups = ["default"]

  network {
      name = "provider_net_shared_3"
  }

  metadata = {
    description = "Windows Server"
  }
}