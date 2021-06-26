#!/bin/bash

ansible-playbook playbooks/static_ip.yaml -i tmp/inventory --ask-vault-pass

