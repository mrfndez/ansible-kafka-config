#!/bin/bash
# Wrapper for Ansible deployment

set -e

usage() {
  echo "Usage: $0 <playbook-file.yml> [extra ansible args]"
  echo "Example: $0 deploy_zk_newnode.yml --limit zk_newnode"
  exit 1
}

if [ -z "$1" ]; then
  usage
fi

PLAYBOOK_FILE="$1"
shift

# change to the directory where the script is located (portable)
cd "$(dirname "$0")" || exit 1

# default branch is 'master'. Override by setting GIT_BRANCH env var.
GIT_BRANCH="${GIT_BRANCH:-master}"

# set variables
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
LOG_FILE="deploy_${PLAYBOOK_FILE%.yml}_$TIMESTAMP.log"

# pull changes from repo
echo "Pulling latest updates from GitHub (branch: $GIT_BRANCH)..."
git pull origin "$GIT_BRANCH"

# check playbook file exists
if [ ! -f "playbooks/$PLAYBOOK_FILE" ]; then
  echo "ERROR: playbooks/$PLAYBOOK_FILE does not exist."
  exit 1
fi

# check inventory exists
if [ ! -f "inventory.yml" ]; then
  echo "ERROR: inventory.yml not found."
  exit 1
fi

# start deployment
echo "=== Ansible Deployment Started: $TIMESTAMP ==="
echo "Running Ansible playbook: $PLAYBOOK_FILE"
ansible-playbook -i inventory.yml "playbooks/$PLAYBOOK_FILE" "$@" -v | tee "$LOG_FILE"

echo "=== Deployment Completed: $(date '+%Y-%m-%d %H:%M:%S') ==="
echo "Log saved to $LOG_FILE"
