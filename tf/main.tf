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

# Ansible Automation Platform Environment

resource "openstack_compute_instance_v2" "controller" {
  name = "${var.username}_aap_${var.aap_version}_controller_${count.index + 1}"
  image_name = "${var.os_release}"
  flavor_name = "g.memory.medium"
  count = var.controller_count

  key_pair = "${var.username}-rsa"
  security_groups = ["default"]
  
  network {
      name = "provider_net_shared"
  }

  metadata = {
    descirption = "Automation Controller"
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
      name = "provider_net_shared"
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
      name = "provider_net_shared"
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
      name = "provider_net_shared"
  }

  metadata = {
    description = "Execution Node"
  }
}