#!/bin/bash

# Exit immediately if any command fails
set -e

# Variables
KUBECTL_VERSION="1.31.0"
KUBECTL_RELEASE_DATE="2024-09-12"
ARCH="amd64"
PLATFORM="$(uname -s)_$ARCH"

# Function to print info
print_info() {
  echo -e "\033[1;32m$1\033[0m"
}


curl https://raw.githubusercontent.com/daws-81s/expense-docker/refs/heads/main/install-docker.sh | sudo bash

# Install kubectl
print_info "Downloading and installing kubectl..."
curl -O "https://s3.us-west-2.amazonaws.com/amazon-eks/$KUBECTL_VERSION/$KUBECTL_RELEASE_DATE/bin/linux/$ARCH/kubectl"
chmod +x ./kubectl
sudo mv kubectl /usr/local/bin/kubectl

# Verify kubectl installation
print_info "Verifying kubectl installation..."
# kubectl version --client --short

# Install eksctl
print_info "Downloading and installing eksctl..."
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"

# (Optional) Verify checksum
print_info "Verifying eksctl checksum..."
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check || {
  echo "Warning: Checksum verification failed. Proceeding anyway."
}

# Extract and install eksctl
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
sudo mv /tmp/eksctl /usr/local/bin

# Verify eksctl installation
print_info "Verifying eksctl installation..."
# eksctl version

# Configure AWS CLI
print_info "Configuring AWS CLI. Please provide credentials when prompted."
sudo aws configure

print_info "Installation and configuration complete!"


git clone https://github.com/pmadhureddy/k8-eksctl.git

git clone https://github.com/pmadhureddy/k8-resources.git

cd k8-eksctl

eksctl create cluster --config-file=eks.yml
