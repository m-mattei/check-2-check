#!/bin/bash

set -e

SCRIPT_DIR="/Users/michaelmattei/projects/check2check-stack/check-2-check"
TAG="${1:-latest}"

echo "=== Building Flutter web app ==="
cd "$SCRIPT_DIR"
flutter build web --no-tree-shake-icons

echo "=== Building Docker image ==="
docker build -t check-2-check-web:$TAG .

echo "=== Loading image to kind cluster ==="
if command -v kind &> /dev/null; then
  kind load docker-image check-2-check-web:$TAG
else
  echo "kind not found, skipping kind load (assuming Docker Desktop K8s or external registry)"
fi

echo "=== Applying Kubernetes manifests ==="
kubectl apply -f "$SCRIPT_DIR/k8s/web.yaml"

echo "=== Rolling out deployment ==="
kubectl rollout restart deployment/web

echo "=== Waiting for deployment ==="
kubectl rollout status deployment/web --timeout=300s

echo "=== Done! Web app deployed ==="
kubectl get pods -l app=web

echo "=== Running Post-deploy Doc Update Agent ==="
bash "$SCRIPT_DIR/post-deploy-docs.sh"
