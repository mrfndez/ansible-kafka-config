# Kafka AWS Cluster – Ansible Automation

> **Infrastructure-as-Code for a multi-node Apache Kafka & ZooKeeper cluster on AWS EC2, plus a separate web-tools host (Kafka Manager, ZooNavigator, etc.).**  
> Everything is deployed, configured, and kept consistent with Ansible.

---

## ☁️ Current Architecture

| Layer | EC2 Host Count | Main Services | Purpose |
|-------|---------------|--------------|---------|
| **Web-Tools** | `1` | Kafka Manager, ZooNavigator, kaf-cli, JMX exporter | UI & monitoring for the whole cluster |
| **Kafka Brokers** | `3` | Kafka broker + ZooKeeper (co-located) | Message storage & replication |
| **Automation** | n/a | GitHub → Ansible → EC2 via SSH | Idempotent installs, config drift prevention |

Each broker/zookeeper host has identical configs produced from Jinja2 templates and pushed by Ansible.  
The web-tools instance has read-only firewall rules to every broker plus inbound HTTPS for the UIs.

---

## 🔑 Features

* **One-command cluster bootstrap** – `./deploy.sh` orchestrates all playbooks (package install ➜ config ➜ service start).  
* **Rolling updates** – playbooks use `serial` and `handlers` so brokers restart one at a time, avoiding downtime.  
* **Auto-scale** – add new broker IPs to `inventory.yml`, run `ansible-playbook playbooks/add-broker.yml`, done.  
* **Immutable configs** – every change lives in Git, templated in `templates/`, and is enforced on every run.  
* **Web UIs out-of-the-box** – Kafka Manager & ZooNavigator installed and exposed on the web-tools node.  
* **Smoke tests** – post-deploy task creates a topic, sends/consumes a test message, and tears it down again.  
* **Systemd-native services** – brokers and ZooKeeper managed via unit files generated from templates.  
* **Metrics ready** – JMX exporter units are laid down on every broker and auto-scraped by Prometheus (optional).  
* **Zero touch secrets** – SASL & SSL keystores are pulled from AWS Secrets Manager at run-time (no keys in Git).

---

## Prerequisites

- Ansible ≥ 2.9  
- AWS CLI configured with permissions to manage EC2  
- SSH key pair for all EC2 hosts  
- Pre-configured VPC & security groups allowing inter-node traffic

---

## Quick start

```bash
#1. Install Ansible

sudo apt update && sudo apt install -y ansible      # Debian/Ubuntu
sudo yum install -y ansible                         # RHEL/CentOS

# 2. Clone & install deps
git clone https://github.com/mrfndez/ansible-kafka-config.git

# 3. Launch or update the whole stack
cd ansible-kafka-config
./deploy.sh [playbook_name.yml]
```

---

## 🗂️ Repository Layout

```text
.
├── _archived/                  # legacy – NOT used any more
├── group_vars/
│   ├── all.yml                 # cluster-wide defaults
|
├── inventory.yml               # EC2 hosts grouped as brokers / zookeepers (existing & new node), web_tools
|
├── playbooks/
│   ├── install-kafka.yml       # downloads Kafka binaries
│   ├── deploy-zookeeper.yml    # deploys zookeeker node
│   ├── deploy-broker.yml       # deploys broker node
│   └── smoke-test.yml          # end-to-end topic test
|
├── roles/
│   ├── install_kafka/          # step #1/1, called by install-kafka.yml
|
│   ├── zkr01_newnode/          # step #1/2, called by deploy-zookeeper.yml
│   └── zkr2_ensemble/          # step #2/2, called by deploy-zookeeper.yml
|
│   ├── brk01_newnode/          # step #1/2, called by deploy-broker.yml
│   └── brk02_ensemble/         # step #2/2, called by deploy-broker.yml
|
├── templates/                  # *.j2 files for server.properties, zookeeper.properties, systemd units, etc.
│   ├── server.properties.j2    # server.properties, contains the broker config
│   └── zookeeper.properties.j2 # zookeeper.properties, contains the zookeeper config
|
├── deploy.sh                   # helper wrapper around `ansible-playbook`
└── ansible.cfg                 # SSH args, retries, callback plugins
