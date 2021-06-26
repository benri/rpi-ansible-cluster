#!/bin/bash

ansible-playbook playbooks/static_ip.yaml -i tmp/inventory --ask-vault-pass

ansible-playbook playbooks/update_install.yaml

ansible-playbook playbooks/plex_server_setup.yaml

ansible-playbook playbooks/plex_usb_samba.yaml --ask-vault-pass