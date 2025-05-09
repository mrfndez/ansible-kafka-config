# Kafka Ansible Management

This repository contains Ansible playbooks for managing Kafka configurations across multiple hosts.

## Basic Usage

1. Deploy Kafka configurations:
ansible-playbook playbooks/deploy-kafka-config.yml


2. Check Kafka status:
ansible-playbook playbooks/check-kafka-status.yml


3. Deploy broker-specific configurations:
ansible-playbook playbooks/deploy-broker-specific-config.yml


## File Structure
- `inventory.yml`: Contains the list of Kafka hosts
- `files/`: Contains configuration files to deploy
- `templates/`: Contains Jinja2 templates for broker-specific configs
- `playbooks/`: Contains the Ansible playbooks

## Maintenance
Update the configuration files in the `files/` directory when changes are needed.
