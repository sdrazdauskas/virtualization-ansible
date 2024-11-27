#!/bin/sh

# Define usernames and VM names
DB_USER="sadr0144"
WEBSERVER_USER="sadr0144"
CLIENT_USER="sadr0144"
DB_VM_NAME="database_server"
WEBSERVER_VM_NAME="web_server"
CLIENT_VM_NAME="client_server"

CENDPOINT=https://grid5.mif.vu.lt/cloud3/RPC2
RETRY_SLEEP=10
ANSIBLE_HOSTS_FILE="ansible/inventory/hosts"
VAULT_FILE="misc/vault.yml"
mkdir -p "$(dirname "$ANSIBLE_HOSTS_FILE")" # Create the directory if needed
mkdir -p "$(dirname "$VAULT_FILE")" # Create the vault directory if needed

# Install required components
echo "Installing required components..."
sudo apt-get update
sudo apt-get -y install gnupg wget apt-transport-https
sudo apt install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible-core

# Create the keyrings directory if it doesn't exist
sudo mkdir -p /etc/apt/keyrings

echo "Adding OpenNebula GPG key..."
wget -q -O- https://downloads.opennebula.io/repo/repo2.key | sudo gpg --dearmor --yes --output /etc/apt/keyrings/opennebula.gpg
echo "Adding OpenNebula repository..."
echo "deb [signed-by=/etc/apt/keyrings/opennebula.gpg] https://downloads.opennebula.io/repo/6.10/Ubuntu/24.04/ stable opennebula" | sudo tee /etc/apt/sources.list.d/opennebula.list

echo "Updating package list and installing OpenNebula tools..."
sudo apt-get update
sudo apt-get install -y opennebula-tools

echo "Starting SSH agent..."
eval "$(ssh-agent -s)"

# Check for existing SSH keys
if ls ~/.ssh/id_*.pub 1> /dev/null 2>&1; then
  echo "SSH key found. Using existing SSH key."
else
  echo "SSH key not found. Generating SSH key..."
  echo "Please enter a password for your new SSH key (leave empty for no password):"
  ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa
fi

echo "Please enter password for your SSH key:"
ssh-add

# Function to instantiate VM and configure SSH
configure_vm() {
  local CUSER=$1
  local VM_NAME=$2

  while true; do
    # Prompt for VU MIF cloud infrastructure password
    echo "Please enter VU MIF cloud password for $CUSER:"
    stty -echo
    read CPASS
    stty echo
    echo

    # Instantiate VM with the specified template
    CVMREZ=$(onetemplate instantiate "ubuntu-24.04" --name "$VM_NAME" --user $CUSER --password $CPASS --endpoint $CENDPOINT --raw "TCP_PORT_FORWARDING=[PORT=22,PORT=80,PORT=443]")
    # Check if something went wrong, it automatically prints why
    if [ -z "$CVMREZ" ]; then 
      continue
    fi

    echo $CVMREZ
    CVMID=$(echo $CVMREZ | cut -d ' ' -f 3) 
    # Check if CVMID is a number using regular expression
    if ! echo "$CVMID" | grep -qE '^[0-9]+$'; then
      echo "Failed to create a VM machine"
      exit 1
    fi
    break
  done

  # Wait for VM to run and retry connection until it works
  echo "Waiting for VM to RUN..."
  while true; do
    $(onevm show $CVMID --user $CUSER --password $CPASS --endpoint $CENDPOINT >$CVMID.txt)
    CSSH_PRIP=$(cat $CVMID.txt | grep PRIVATE\_IP | cut -d '=' -f 2 | tr -d '"')
    if [ -n "$CSSH_PRIP" ]; then
      break
    fi
    echo "Retrying connection..."
    sleep $RETRY_SLEEP
  done

  CSSH_CON="ssh $CUSER@$CSSH_PRIP"

  # Remove the connection from known hosts
  ssh-keygen -R $CSSH_PRIP

  # Extract the password from connection info
  SSH_PASSWORD=$(grep 'ROOT_PASSWORD' $CVMID.txt | cut -d '=' -f 2 | tr -d '"' | tr -d ',')
  echo $SSH_PASSWORD
  while true; do
    sshpass -p "$SSH_PASSWORD" ssh-copy-id -o StrictHostKeyChecking=no -f $CUSER@$CSSH_PRIP
    if [ $? -eq 0 ]; then
      echo "${VM_NAME}_pass: $SSH_PASSWORD" | sudo tee -a $VAULT_FILE > /dev/null
      break
    else
      echo "Connection error. Retrying..."
      sleep $RETRY_SLEEP
    fi
  done

  # Append VM name and private IP to Ansible hosts file
  echo "[$VM_NAME]" | sudo tee -a $ANSIBLE_HOSTS_FILE
  echo "$CSSH_PRIP" | sudo tee -a $ANSIBLE_HOSTS_FILE
  echo ""           | sudo tee -a $ANSIBLE_HOSTS_FILE
  echo
}

# Initialize the vault file
echo "---" | sudo tee $VAULT_FILE

# Call the function with the username and VM name parameters
configure_vm $DB_USER $DB_VM_NAME
configure_vm $WEBSERVER_USER $WEBSERVER_VM_NAME
configure_vm $CLIENT_USER $CLIENT_VM_NAME

sudo ansible-vault encrypt $VAULT_FILE
sudo chmod 644 $VAULT_FILE
ansible-playbook -i ansible/inventory/hosts ansible/main.yml --ask-vault-pass