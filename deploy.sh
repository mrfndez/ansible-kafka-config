#!/bin/bash
# simple wrapper for Ansible deployment

if [ -z "$1" ]; then
  echo "Usage: $0 <playbook-file.yml> [extra ansible args]"
  # ./deploy.sh broker-configs.yml --limit brokers
  # ./deploy.sh broker-configs.yml --limit zookeepers
  exit 1
fi

PLAYBOOK_FILE="$1"
shift  # Remove the first argument so "$@" contains only extra args

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# start deployment
echo "=== Ansible Deployment Started: $TIMESTAMP ==="

cd ~/kafka-admin/ansible || exit 1

# pull latest from Git and log it
echo "Pulling latest updates from GitHub..."
git pull origin master

# run Ansible playbook
echo "Running Ansible playbook: $PLAYBOOK_FILE"
ansible-playbook -i inventory.yml "playbooks/$PLAYBOOK_FILE" "$@" -v

echo "=== Deployment Completed: $(date '+%Y-%m-%d %H:%M:%S') ==="

