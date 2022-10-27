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
# Defaults
#   - 1 RHEL 8 Automation Controller
#   - 1 RHEL 8 Execution Environment
#   - 1 RHEL 8 Automation Hub

resource "openstack_compute_instance_v2" "controller" {
  name = "${var.username}_aap_${var.aap_version}_controller"
  image_name = "RHEL-8.6.0-x86_64-released"
  flavor_name = "g.memory.medium"
  key_pair = "${var.username}-rsa"
  security_groups = ["default"]
  
  network {
      name = "provider_net_shared"
  }

  metadata = {
    descirption = "Automation Controller"
  }
}

resource "openstack_compute_instance_v2" "automation_hub" {
  name = "${var.username}_aap_${var.aap_version}_automation_hub"
  image_name = "RHEL-8.6.0-x86_64-released"
  flavor_name = "g.memory.medium"
  key_pair = "${var.username}-rsa"
  security_groups = ["default"]
  
  network {
      name = "provider_net_shared"
  }

  metadata = {
    description = "Automation Hub"
  }
}

resource "openstack_compute_instance_v2" "execution_environment" {
  name = "${var.username}_aap_${var.aap_version}_execution_environment"
  image_name = "RHEL-8.6.0-x86_64-released"
  flavor_name = "m1.medium"
  key_pair = "${var.username}-rsa"
  security_groups = ["default"]
  
  network {
      name = "provider_net_shared"
  }

  metadata = {
    description = "Execution Environment"
  }
}