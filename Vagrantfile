# -*- mode: ruby -*-
# vi: set ft=ruby :

# Environment Variables
# The Vagrant environment is designed to be configured through environment variables. This should allow the admin or
# developer to recreate an environment easily.
#
# DEFAULT_IMAGE
# Type: string
# This defines the default image that Vagrant should pull down from app.vagrantup.com
default_image = ENV.has_key?('DEFAULT_IMAGE') ? ENV.fetch('DEFAULT_IMAGE') : 'generic/rhel8'

# TOWER_CONTROLLER_COUNT
# Type: integer
# Number of AAP Controller VMs to build. The IP for the controller VMs will be 192.168.56.1{1-9}.
controller_count = ENV.has_key?('TOWER_CONTROLLER_COUNT') ? ENV.fetch('TOWER_CONTROLLER_COUNT').to_i : 1

# TOWER_EXTERNAL_DATABASE
# Type: boolean
# Flag for vagrant to spin up a separate vm to host the AAP postgresql database. If either this flag is set or
# TOWER_CONTROLLER_COUNT is greater than 1, than a database VM will be spun up.
database_use_external = ENV.has_key?('TOWER_EXTERNAL_DATABASE') ? ENV.fetch('TOWER_EXTERNAL_DATABASE').downcase : false

# TOWER_DATABASE_COUNT
# Type: integer
# Number of AAP database VMs to build. The IP for the database VMs will be 192.168.56.2{1-9}.
database_count = ENV.has_key?('TOWER_DATABASE_COUNT') ? ENV.fetch('TOWER_DATABASE_COUNT').to_i : 1

# TOWER_AUTOMATIONHUB_COUNT
# Type: integer
# Number of AAP Automation Hub VMs to build. The IP for the automationhub VMs will be 192.168.56.3{1-9}.
automationhub_count = ENV.has_key?('TOWER_AUTOMATIONHUB_COUNT') ? ENV.fetch('TOWER_AUTOMATIONHUB_COUNT').to_i : 1

# TOWER_EXECUTION_NODE_COUNT
# Type: integer
# Number of AAP Execution Node VMs to build. The IP for the automationhub VMs will be 192.168.56.4{1-9}.
execution_count = ENV.has_key?('TOWER_EXECUTION_NODE_COUNT') ? ENV.fetch('TOWER_EXECUTION_NODE_COUNT').to_i : 1

# Local Variables
time = Time.new
build_version = time.strftime('%Y%m')

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
  ## Ansible Tower Environment
  (1..controller_count).each do |i|
    config.vm.define "controller#{i}" do |controller|
      controller.vm.hostname = "controller#{i}-wkst-#{build_version}.local"
      controller.vm.network "private_network", ip: "192.168.56.1#{i}"
      controller.vm.provider "virtualbox" do |vm|
        vm.memory = "8192"
      end
      controller.vm.provider "libvirt" do |vm|
        vm.memory = "8192"
      end
    end
  end

  if database_use_external || controller_count > 1
    (1..database_count).each do |i|
      config.vm.define "database#{i}" do |database|
        database.vm.hostname = "database#{i}-wkst-#{build_version}.local"
        database.vm.network "private_network", ip: "192.168.56.2#{i}"
        database.vm.provider "virtualbox" do |vm|
          vm.memory = "4096"
        end
        database.vm.provider "libvirt" do |vm|
          vm.memory = "4096"
        end
      end
    end
  end

  (1..automationhub_count).each do |i|
    config.vm.define "automationhub#{i}" do |automationhub|
      automationhub.vm.hostname = "automationhub#{i}-wkst-#{build_version}.local"
      automationhub.vm.network "private_network", ip: "192.168.56.3#{i}"
      automationhub.vm.provider "virtualbox" do |vm|
        vm.memory = "8192"
      end
      automationhub.vm.provider "libvirt" do |vm|
        vm.memory = "8192"
      end
    end
  end

  (1..execution_count).each do |i|
    config.vm.define "execution#{i}" do |execution|
      execution.vm.hostname = "execution#{i}-wkst-#{build_version}.local"
      execution.vm.network "private_network", ip: "192.168.56.4#{i}"
      execution.vm.provider "virtualbox" do |vm|
        vm.memory = "8192"
      end
      execution.vm.provider "libvirt" do |vm|
        vm.memory = "8192"
      end
    end
  end
  ## END Ansible Tower Environment
  
  # Controlled Servers
  config.vm.define "srvrhel8", autostart: false do |systm|
    systm.vm.box = "generic/rhel8"
    systm.vm.hostname = "srvrhel8.local"
    systm.vm.network "private_network", ip: "192.168.56.100"
    systm.vm.provider "virtualbox" do |vm|
      vm.memory = "1024"
      vm.cpus = 1
    end
    systm.vm.provider "libvirt" do |vm|
      vm.memory = "1024"
      vm.cpus = 1
    end
  end

  config.vm.define "srvcentos8", autostart: false do |systm|
    systm.vm.box = "centos/stream8"
    systm.vm.hostname = "srvrhel8.local"
    systm.vm.network "private_network", ip: "192.168.56.101"
    systm.vm.provider "virtualbox" do |vm|
      vm.memory = "1024"
      vm.cpus = 1
    end
    systm.vm.provider "libvirt" do |vm|
      vm.memory = "1024"
      vm.cpus = 1
    end
  end
end
