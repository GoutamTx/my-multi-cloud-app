#!/bin/bash
# Docker image tag passed as the first argument
DOCKER_IMAGE_TAG=$1

echo "Configuring kubectl for EKS cluster: ${{ secrets.EKS_CLUSTER_NAME }}"
# Update kubeconfig to connect to EKS
aws eks update-kubeconfig --name ${{ secrets.EKS_CLUSTER_NAME }} --region ${{ secrets.AWS_REGION }}

echo "Applying Kubernetes manifests to EKS using image: $DOCKER_IMAGE_TAG"

# Important: We need to substitute the image tag in our Kubernetes manifests.
# Use 'sed' to replace a placeholder like '__DOCKER_IMAGE_PLACEHOLDER__'
# with the actual DOCKER_IMAGE_TAG.
# Create a temporary directory for modified manifests to avoid changing the source.
TEMP_MANIFEST_DIR=$(mktemp -d)
cp config/aws/eks-app-manifests/* "$TEMP_MANIFEST_DIR"/

# Use sed to update the image in the deployment manifest
sed -i "s|__DOCKER_IMAGE_PLACEHOLDER__|$DOCKER_IMAGE_TAG|g" "$TEMP_MANIFEST_DIR"/deployment.yaml

kubectl apply -f "$TEMP_MANIFEST_DIR"/deployment.yaml
kubectl apply -f "$TEMP_MANIFEST_DIR"/service.yaml

# Clean up temporary directory
rm -rf "$TEMP_MANIFEST_DIR"

echo "EKS deployment initiated."
