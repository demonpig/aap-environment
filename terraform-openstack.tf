provider "openstack" {
  cloud = "openstack"
}

# OpenStack resources retain their existing addresses and provider-specific settings.
resource "openstack_compute_instance_v2" "controller" {
  name        = "${var.username}_aap_${var.aap_version}_controller_${count.index + 1}"
  image_name  = local.os_versions[var.controller_os_version].openstack_release
  flavor_name = "g.memory.medium"
  count       = var.compute_backend == "openstack" ? var.controller_count : 0

  key_pair        = "${var.username}-rsa"
  security_groups = ["default"]
  network { name = "provider_net_shared_3" }
  metadata = { description = "Automation Controller" }
}

resource "openstack_compute_instance_v2" "eda" {
  name            = "${var.username}_aap_${var.aap_version}_eda_${count.index + 1}"
  image_name      = local.os_versions[var.eda_os_version].openstack_release
  flavor_name     = "g.memory.medium"
  count           = var.compute_backend == "openstack" ? var.eda_count : 0
  key_pair        = "${var.username}-rsa"
  security_groups = ["default"]
  network { name = "provider_net_shared_3" }
  metadata = { description = "EDA Server" }
}

resource "openstack_compute_instance_v2" "gateway" {
  name            = "${var.username}_aap_${var.aap_version}_gateway_${count.index + 1}"
  image_name      = local.os_versions[var.gateway_os_version].openstack_release
  flavor_name     = "g.memory.medium"
  count           = var.compute_backend == "openstack" ? var.gateway_count : 0
  key_pair        = "${var.username}-rsa"
  security_groups = ["default"]
  network { name = "provider_net_shared_3" }
  metadata = { description = "Automation Gateway" }
}

resource "openstack_compute_instance_v2" "automation_hub" {
  name            = "${var.username}_aap_${var.aap_version}_automation_hub_${count.index + 1}"
  image_name      = local.os_versions[var.automation_hub_os_version].openstack_release
  flavor_name     = "g.memory.medium"
  count           = var.compute_backend == "openstack" ? var.automation_hub_count : 0
  key_pair        = "${var.username}-rsa"
  security_groups = ["default"]
  network { name = "provider_net_shared_3" }
  metadata = { description = "Automation Hub" }
}

resource "openstack_compute_instance_v2" "database" {
  name            = "${var.username}_aap_${var.aap_version}_database_${count.index + 1}"
  image_name      = local.os_versions[var.database_os_version].openstack_release
  flavor_name     = "g.memory.medium"
  count           = var.compute_backend == "openstack" ? var.database_count : 0
  key_pair        = "${var.username}-rsa"
  security_groups = ["default"]
  network { name = "provider_net_shared_3" }
  metadata = { description = "Database" }
}

resource "openstack_compute_instance_v2" "execution_node" {
  name            = "${var.username}_aap_${var.aap_version}_execution_node_${count.index + 1}"
  image_name      = local.os_versions[var.execution_node_os_version].openstack_release
  flavor_name     = "m1.medium"
  count           = var.compute_backend == "openstack" ? var.execution_node_count : 0
  key_pair        = "${var.username}-rsa"
  security_groups = ["default"]
  network { name = "provider_net_shared_3" }
  metadata = { description = "Execution Node" }
}

resource "openstack_compute_instance_v2" "managed_rhel10" {
  name            = "${var.username}_aap_${var.aap_version}_managed_rhel10_${count.index + 1}"
  image_name      = local.os_versions.rhel10.openstack_release
  flavor_name     = "m1.medium"
  count           = var.compute_backend == "openstack" ? var.managed_node_count : 0
  key_pair        = "${var.username}-rsa"
  security_groups = ["default"]
  network { name = "provider_net_shared_3" }
  metadata = { description = "Managed System (RHEL 10)" }
}

resource "openstack_compute_instance_v2" "managed_rhel9" {
  name            = "${var.username}_aap_${var.aap_version}_managed_${count.index + 1}"
  image_name      = local.os_versions.rhel9.openstack_release
  flavor_name     = "m1.medium"
  count           = var.compute_backend == "openstack" ? var.managed_node_count : 0
  key_pair        = "${var.username}-rsa"
  security_groups = ["default"]
  network { name = "provider_net_shared_3" }
  metadata = { description = "Managed System" }
}

resource "openstack_compute_instance_v2" "managed_rhel8" {
  name            = "${var.username}_aap_${var.aap_version}_managed_rhel8_${count.index + 1}"
  image_name      = local.os_versions.rhel8.openstack_release
  flavor_name     = "m1.medium"
  count           = var.compute_backend == "openstack" ? var.managed_node_count : 0
  key_pair        = "${var.username}-rsa"
  security_groups = ["default"]
  network { name = "provider_net_shared_3" }
  metadata = { description = "Managed System (RHEL 8)" }
}
