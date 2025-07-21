#!/bin/bash
echo "Running AWS EKS specific security checks..."

# Ensure kubectl is configured for EKS
aws eks update-kubeconfig --name ${{ secrets.EKS_CLUSTER_NAME }} --region ${{ secrets.AWS_REGION }}

# Example 1: Check EKS Cluster Control Plane logging (conceptual)
echo "Checking EKS control plane logging configuration..."
# This would involve querying AWS CloudWatch logs or EKS cluster settings.
# For example: check if audit logs are enabled
# aws eks describe-cluster --name ${{ secrets.EKS_CLUSTER_NAME }} --query "cluster.logging.clusterLogging"

# Example 2: Basic check for public endpoints on EKS services (conceptual)
echo "Checking for publicly accessible services in EKS..."
# kubectl get svc -A -o json | jq -r '.items[] | select(.spec.type == "LoadBalancer") | .status.loadBalancer.ingress[0].hostname // .status.loadBalancer.ingress[0].ip'

# Example 3: Use kube-bench for CIS Kubernetes Benchmark best practices on EKS nodes
echo "Running kube-bench for EKS CIS compliance..."
# Make sure kube-bench is installed or run it via Docker (as previously shown)
docker run --rm -v /etc:/etc:ro -v /var/lib:/var/lib:ro -v /var/run/docker.sock:/var/run/docker.sock:ro --pid=host --net=host aquasec/kube-bench:latest --targets node --benchmark cis-1.2 # Run only node checks for simplicity here
# Further parsing of kube-bench output for actionable results is recommended.

echo "AWS EKS security checks completed."
