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

function download_aap_release(){
  local version="$1"
  local archivedir="$(dirname $0)/archives/${version}"
  mkdir -p $archivedir
  cd $archivedir
  for i in {0..5}; do
    # Giving it 10 tries to download the archives
    # https://releases.ansible.com/ansible-tower/setup/ansible-tower-setup-3.8.4-1.tar.gz
    if [[ $i -eq 0 ]]; then
      curl -sk -f -LO https://releases.ansible.com/ansible-tower/setup/ansible-tower-setup-${version}.tar.gz || continue
      echo "ansible-tower-setup-${version}.tar.gz" > .archive_version
    else
      curl -sk -f -LO https://releases.ansible.com/ansible-tower/setup/ansible-tower-setup-${version}-${i}.tar.gz || continue
      echo "ansible-tower-setup-${version}-${i}.tar.gz" > .archive_version
    fi
    break
  done

  if [[ -f .archive_version ]]; then
    tar xf "$(cat .archive_version)"
    rm -f "$(cat .archive_version)"
  else
    >&2 echo "Ansible Tower or AAP verison ${version} does not exist"
  fi
}

function get_ips(){
  vagrant_libvirt provision --provision-with get_ip
}

if [[ "$1" == "setup" ]]; then
  setup_python
fi

if [[ "$1" == "download" ]]; then
  download_aap_release "$2"
fi

if [[ "$1" == "get-ip" ]]; then
  get_ips
fi