# Kafka Ansible Management

This repository contains Ansible playbooks for managing Kafka configurations across multiple hosts.


## Basic Usage

1. Deploy Broker configurations:
ansible-playbook playbooks/broker-configs.yml

2. Check Kafka status:
ansible-playbook playbooks/check-kafka-status.yml

3. Download and install Kafka binaries:
ansible-playbook playbooks/download-kafka.yml


## File Structure
- `inventory.yml`: Contains the list of Kafka hosts
- `templates/`: Contains Jinja2 templates for broker-specific configs
- `playbooks/`: Contains the Ansible playbooks
- `ansible.cfg`: Ansible configuration file
