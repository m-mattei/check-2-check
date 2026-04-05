#!/bin/bash
set -e

echo "Building Flutter web..."
flutter build web --no-pub --no-tree-shake-icons

echo "Building Docker image..."
docker build -t check-2-check-web:latest .

echo "Applying to Kubernetes..."
kubectl rollout restart deployment/web -n check-2-check

echo "Waiting for rollout..."
kubectl rollout status deployment/web -n check-2-check

echo "Done! Web app deployed."
