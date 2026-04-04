#!/bin/bash
set -e

echo "Standardizing local Kubernetes environment with K3d..."

# Check if k3d is installed
if ! command -v k3d &> /dev/null; then
    echo "k3d not found. Installing..."
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | TAG=v5.6.0 bash
fi

# Create cluster if it doesn't exist
if ! k3d cluster get dev-cluster &> /dev/null; then
    k3d cluster create dev-cluster \
        --api-port 6550 \
        -p "8081:80@loadbalancer" \
        -p "8443:443@loadbalancer" \
        --agents 1
else
    echo "Cluster 'dev-cluster' already exists."
fi

# Merge kubeconfig
#k3d kubeconfig merge dev-cluster --switch-context
k3d kubeconfig merge dev-cluster --kubeconfig-switch-context
echo "Cluster is ready! Context switched to k3d-dev-cluster."
