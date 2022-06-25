# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile Variables
# The Vagrant environment is designed to be configured through environment variables. This should allow the admin or
# developer to recreate an environment easily.
#
# DEFAULT_IMAGE
# Type: string
# This defines the default image that Vagrant should pull down from app.vagrantup.com
default_image = ENV.has_key?('DEFAULT_IMAGE') ? ENV.fetch('DEFAULT_IMAGE') : 'generic/rhel8'

# TOWER_CONTROLLER_COUNT
# Type: integer
# Number of AAP Controller VMs to build.
controller_count = ENV.has_key?('TOWER_CONTROLLER_COUNT') ? ENV.fetch('TOWER_CONTROLLER_COUNT').to_i : 1

# TOWER_DATABASE_COUNT
# Type: integer
# Number of AAP database VMs to build.
database_count = ENV.has_key?('TOWER_DATABASE_COUNT') ? ENV.fetch('TOWER_DATABASE_COUNT').to_i : 0

# TOWER_AUTOMATIONHUB_COUNT
# Type: integer
# Number of AAP Automation Hub VMs to build.
automationhub_count = ENV.has_key?('TOWER_AUTOMATIONHUB_COUNT') ? ENV.fetch('TOWER_AUTOMATIONHUB_COUNT').to_i : 0

# TOWER_EXECUTION_NODE_COUNT
# Type: integer
# Number of AAP Execution Node VMs to build.
execution_count = ENV.has_key?('TOWER_EXECUTION_NODE_COUNT') ? ENV.fetch('TOWER_EXECUTION_NODE_COUNT').to_i : 0

# Local Variables
time = Time.new
build_version = time.strftime('%Y%m') + "-" + [*('a'..'z'),*('0'..'9')].shuffle[0,8].join

Vagrant.configure("2") do |config|
  # Default Values
  config.vm.box = default_image
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.provider "virtualbox" do |vm|
    vm.gui = false
    vm.memory = "2048"
    vm.cpus = 2
  end
  config.vm.provider "libvirt" do |vm|
    vm.memory = "2048"
    vm.cpus = 2
  end

  # Virtual Machines
  (1..controller_count).each do |i|
    config.vm.define "controller#{i}.local" do |controller|
      controller.vm.hostname = "controller#{i}-#{build_version}.local"
      controller.vm.provider "libvirt" do |vm|
        vm.memory = "8192"
      end
    end
  end

  if database_count >= 1
    (1..database_count).each do |i|
      config.vm.define "database#{i}.local" do |database|
        database.vm.hostname = "database#{i}-#{build_version}.local"
        database.vm.provider "libvirt" do |vm|
          vm.memory = "4096"
        end
      end
    end
  end

  if automationhub_count >= 1
    (1..automationhub_count).each do |i|
      config.vm.define "automationhub#{i}.local" do |automationhub|
        automationhub.vm.hostname = "automationhub#{i}-#{build_version}.local"
        automationhub.vm.provider "libvirt" do |vm|
          vm.memory = "8192"
        end
      end
    end
  end

  if execution_count >= 1
    (1..execution_count).each do |i|
      config.vm.define "execution#{i}.local" do |execution|
        execution.vm.hostname = "execution#{i}-#{build_version}.local"
      end
    end
  end
end
