#!/bin/bash

ansible-playbook playbooks/static_ip.yaml -i tmp/inventory --ask-vault-pass

ansible-playbook playbooks/update_install.yaml

ansible-playbook playbooks/plex_server_setup.yaml

ansible-playbook playbooks/plex_usb_setup.yaml --ask-vault-pass

ansible-playbook playbooks/plex_samba_setup.yaml --ask-vault-pass