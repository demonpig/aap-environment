# General variables
variable "username" {
  type    = string
  default = "changeme"
}

variable "aap_version" {
  type    = string
  default = "latest"
}

variable "compute_backend" {
  description = "Compute provider. Use separate Terraform state for each backend."
  type        = string
  default     = "libvirt"
  validation {
    condition     = contains(["libvirt", "openstack"], var.compute_backend)
    error_message = "Compute backend must be either libvirt or openstack."
  }
}

variable "libvirt_uri" {
  description = "Libvirt connection URI, e.g. qemu:///system or qemu:///session."
  type        = string
  default     = "qemu:///system"
}

variable "libvirt_image_dir" {
  description = "Directory containing the manually downloaded RHEL KVM images."
  type        = string
  default     = "~/Documents/iso"
}

variable "libvirt_pool" {
  description = "Existing libvirt storage pool for writable disks and cloud-init ISOs."
  type        = string
  default     = "default"
}

variable "libvirt_network" {
  description = "Existing libvirt network to attach to."
  type        = string
  default     = "default"
}

variable "libvirt_ssh_public_key" {
  description = "Path to the SSH public key installed in libvirt guests."
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "libvirt_ssh_user" {
  description = "Login account configured by cloud-init in RHEL KVM images."
  type        = string
  default     = "cloud-user"
}

variable "libvirt_aap_vcpu" {
  type    = number
  default = 4
}

variable "libvirt_aap_memory_mb" {
  type    = number
  default = 16384
}

variable "libvirt_managed_vcpu" {
  type    = number
  default = 2
}

variable "libvirt_managed_memory_mb" {
  type    = number
  default = 4096
}

variable "libvirt_disk_size_gib" {
  description = "Capacity of each writable libvirt VM disk in GiB."
  type        = number
  default     = 75
}

# Standard OS-version selectors; provider-specific identifiers are mapped in terraform-main.tf.
# Valid values are rhel8, rhel9, or rhel10.
variable "controller_os_version" {
  type    = string
  default = "rhel10"
  validation {
    condition     = contains(["rhel8", "rhel9", "rhel10"], var.controller_os_version)
    error_message = "Select rhel8, rhel9, or rhel10."
  }
}

variable "eda_os_version" {
  type    = string
  default = "rhel10"
  validation {
    condition     = contains(["rhel8", "rhel9", "rhel10"], var.eda_os_version)
    error_message = "Select rhel8, rhel9, or rhel10."
  }
}

variable "gateway_os_version" {
  type    = string
  default = "rhel10"
  validation {
    condition     = contains(["rhel8", "rhel9", "rhel10"], var.gateway_os_version)
    error_message = "Select rhel8, rhel9, or rhel10."
  }
}

variable "automation_hub_os_version" {
  type    = string
  default = "rhel10"
  validation {
    condition     = contains(["rhel8", "rhel9", "rhel10"], var.automation_hub_os_version)
    error_message = "Select rhel8, rhel9, or rhel10."
  }
}

variable "database_os_version" {
  type    = string
  default = "rhel10"
  validation {
    condition     = contains(["rhel8", "rhel9", "rhel10"], var.database_os_version)
    error_message = "Select rhel8, rhel9, or rhel10."
  }
}

variable "execution_node_os_version" {
  type    = string
  default = "rhel10"
  validation {
    condition     = contains(["rhel8", "rhel9", "rhel10"], var.execution_node_os_version)
    error_message = "Select rhel8, rhel9, or rhel10."
  }
}

variable "controller_count" {
  type    = number
  default = 2
}
variable "eda_count" {
  type    = number
  default = 0
}
variable "gateway_count" {
  type    = number
  default = 0
}
variable "automation_hub_count" {
  type    = number
  default = 0
}
variable "database_count" {
  type    = number
  default = 0
}
variable "execution_node_count" {
  type    = number
  default = 0
}
variable "managed_node_count" {
  type    = number
  default = 0
}
