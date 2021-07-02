#!/bin/bash

# Install required ansible modules
ansible-galaxy collection install ansible.posix
ansible-galaxy collection install community.general

ansible-playbook playbooks/static_ip.yaml -i tmp/inventory --ask-vault-pass
ansible-playbook playbooks/update_install.yaml

# plex
ansible-playbook playbooks/plex_server_setup.yaml
ansible-playbook playbooks/plex_usb_setup.yaml --ask-vault-pass
ansible-playbook playbooks/plex_samba_setup.yaml --ask-vault-pass

# microk8s
ansible-playbook playbooks/install_microk8s.yaml