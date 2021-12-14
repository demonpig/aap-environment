#!/bin/sh

# vagrant_libvirt is best used with a container.
vagrant_libvirt(){
  local env_tmpfile=$(mktemp)
  env | grep TOWER_  >> $env_tmpfile
  env | grep DEFAULT_IMAGE >> $env_tmpfile

  podman run -it --rm \
    -e LIBVIRT_DEFAULT_URI \
    --env-file $env_tmpfile \
    -v /var/run/libvirt/:/var/run/libvirt/ \
    -v ~/.vagrant.d/boxes:/vagrant/boxes \
    -v ~/.vagrant.d/data:/vagrant/data \
    -v ~/.vagrant.d/data:/vagrant/tmp \
    -v $(realpath "${PWD}"):${PWD} \
    -w $(realpath "${PWD}") \
    --network host \
    --entrypoint /bin/bash \
    --security-opt label=disable \
    docker.io/vagrantlibvirt/vagrant-libvirt:latest \
      vagrant $@

  rm -f $env_tmpfile
}

function setup_python(){
  local pyenv="$(dirname $0)"/.env
  python3 -m venv $pyenv
  source $pyenv/bin/activate
  pip install --upgrade pip
  pip install -r requirements.txt
  ansible-galaxy install -r "$(dirname $0)"/ansible/requirements.yml
}

if [[ "$1" == "setup" ]]; then
  setup_python
fi