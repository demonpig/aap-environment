# General Variables

variable "username" {
    type = string
    default = "changeme"
}

variable "os_release" {
    type = string
    default = "RHEL-8.6.0-x86_64-released"
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