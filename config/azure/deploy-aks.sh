#!/bin/bash
# Docker image tag passed as the first argument
DOCKER_IMAGE_TAG=$1

echo "Configuring kubectl for AKS cluster: ${{ secrets.AKS_CLUSTER_NAME }} in resource group: ${{ secrets.AKS_RESOURCE_GROUP }}"
# Get AKS credentials and merge into kubeconfig
az aks get-credentials --resource-group ${{ secrets.AKS_RESOURCE_GROUP }} --name ${{ secrets.AKS_CLUSTER_NAME }} --overwrite-kubeconfig

echo "Applying Kubernetes manifests to AKS using image: $DOCKER_IMAGE_TAG"

# Similar to EKS, substitute the image tag in manifests
TEMP_MANIFEST_DIR=$(mktemp -d)
cp config/azure/aks-app-manifests/* "$TEMP_MANIFEST_DIR"/

# Use sed to update the image in the deployment manifest
sed -i "s|__DOCKER_IMAGE_PLACEHOLDER__|$DOCKER_IMAGE_TAG|g" "$TEMP_MANIFEST_DIR"/deployment.yaml

kubectl apply -f "$TEMP_MANIFEST_DIR"/deployment.yaml
kubectl apply -f "$TEMP_MANIFEST_DIR"/service.yaml

# Clean up temporary directory
rm -rf "$TEMP_MANIFEST_DIR"

echo "AKS deployment initiated."
