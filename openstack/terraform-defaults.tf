# General Variables

variable "username" {
    type = string
    default = "changeme"
}

variable "os_release" {
    type = string
    default = "RHEL-9.0.0-x86_64-released"
}

# This is to allow a managed node to be something different
variable "os_release_managed" {
    type = string
    default = "RHEL-9.0.0-x86_64-released"
}

variable "os_release_windows" {
    type = string
    default = "WINDOWS-SERVER-2022-x86_64-20230501"
}

# Ansible Automation Platform Variables

variable "aap_version" {
    type = string
    default = "latest"
}

variable "controller_count" {
    type = number
    default = 1
}

variable "eda_count" {
    type = number
    default = 0
}

variable "database_count" {
    type = number
    default = 0
}

variable "execution_node_count" {
    type = number
    default = 0
}

variable "automation_hub_count" {
    type = number
    default = 0
}

variable "sso_count" {
    type = number
    default = 0
}

variable "managed_node_count" {
    type = number
    default = 1
}

variable "windows_count" {
    type = number
    default = 0
}
