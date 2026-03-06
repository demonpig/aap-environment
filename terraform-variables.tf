# General Variables

variable "username" {
    type = string
    default = "changeme"
}

variable "aap_version" {
    type = string
    default = "latest"
}

# Ansible Automation Platform Variables

variable "controller_count" {
    type = number
    default = 1
}

variable "controller_os_release" {
    type = string
    default = ""
}

variable "eda_count" {
    type = number
    default = 0
}

variable "eda_os_release" {
    type = string
    default = ""
}

variable "gateway_count" {
    type = number
    default = 0
}

variable "gateway_os_release" {
    type = string
    default = ""
}

variable "automation_hub_count" {
    type = number
    default = 0
}

variable "automation_hub_os_release" {
    type = string
    default = ""
}

variable "database_count" {
    type = number
    default = 0
}

variable "database_os_release" {
    type = string
    default = ""
}

variable "execution_node_count" {
    type = number
    default = 0
}

variable "execution_node_os_release" {
    type = string
    default = ""
}

variable "managed_node_count" {
    type = number
    default = 0
}
