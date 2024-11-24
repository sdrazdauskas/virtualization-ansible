#!/bin/sh

# Define usernames and VM names
DB_USER="sadr0144"
WEBSERVER_USER="sadr0144"
CLIENT_USER="sadr0144"
DB_VM_NAME="database-server"
WEBSERVER_VM_NAME="web-server"
CLIENT_VM_NAME="client-server"

CENDPOINT=https://grid5.mif.vu.lt/cloud3/RPC2

ANSIBLE_HOSTS_FILE="hosts"

# Install required components
echo "Installing required components..."
sudo apt-get update
sudo apt-get -y install gnupg wget apt-transport-https
sudo apt install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y

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
  echo "Please enter the password for user $CUSER:"
  stty -echo
  read CPASS
  stty echo
  echo

  # Instantiate VM with the specified template
  CVMREZ=$(onetemplate instantiate "ubuntu-24.04" --name "$VM_NAME" --user $CUSER --password $CPASS --endpoint $CENDPOINT)
  # Check if something went wrong, in case it did it automatically prints why
  if [ -z "$CVMREZ" ]; then 
    continue
  fi

  echo $CVMREZ
    CVMID=$(echo $CVMREZ |cut -d ' ' -f 3) 

    # Check if CVMID is a number using regular expression
    if ! echo "$CVMID" | grep -qE '^[0-9]+$'; then
    echo "Failed to create a VM machine"
    exit 1
    fi

    echo $CVMID
    break
  done

  # Wait for VM to run and retry connection until it works
  echo "Waiting for VM to RUN..."
  while true; do
    $(onevm show $CVMID --user $CUSER --password $CPASS --endpoint $CENDPOINT >$CVMID.txt)
    CSSH_PRIP=$(cat $CVMID.txt | grep PRIVATE\_IP| cut -d '=' -f 2 | tr -d '"')
    if [ -n "$CSSH_PRIP" ]; then
      break
    fi
    echo "Retrying connection..."
    sleep 5
  done

  CSSH_CON="ssh $CUSER@$CSSH_PRIP"

  # Remove the connection from known hosts
  ssh-keygen -R $CSSH_PRIP

  # Retry ssh-copy-id until it works, forcing the addition of the key and skipping host key checking
  while true; do
    ssh-copy-id -o StrictHostKeyChecking=no -f $CUSER@$CSSH_PRIP && break
    echo "Retrying ssh-copy-id..."
    sleep 5
  done

  # Append VM name and private IP to Ansible hosts file
  echo "[$VM_NAME]" | sudo tee -a $ANSIBLE_HOSTS_FILE
  echo "$CSSH_PRIP" | sudo tee -a $ANSIBLE_HOSTS_FILE
  echo
}

# Call the function with the username and VM name parameters
configure_vm $DB_USER $DB_VM_NAME
configure_vm $WEBSERVER_USER $WEBSERVER_VM_NAME
configure_vm $CLIENT_USER $CLIENT_VM_NAME