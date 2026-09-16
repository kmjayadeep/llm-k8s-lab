#!/usr/bin/env bash
set -euo pipefail

CERT_MANAGER_VERSION=${CERT_MANAGER_VERSION:-v1.20.3}
KSERVE_VERSION=${KSERVE_VERSION:-v0.20.0}

# KServe's admission webhooks use cert-manager. Keeping both dependencies in
# Helm makes this installation repeatable and easy to upgrade.
helm upgrade --install cert-manager \
  oci://quay.io/jetstack/charts/cert-manager \
  --version "$CERT_MANAGER_VERSION" \
  --namespace cert-manager \
  --create-namespace \
  --set crds.enabled=true \
  --wait \
  --timeout 10m

helm upgrade --install kserve-crd \
  oci://ghcr.io/kserve/charts/kserve-crd \
  --version "$KSERVE_VERSION" \
  --namespace kserve \
  --create-namespace \
  --wait \
  --timeout 10m

# Standard mode creates regular Deployments and Services. Ingress creation is
# disabled because this local Kind lab accesses models with kubectl port-forward
# and therefore does not need Knative, Istio, or a Gateway API controller.
helm upgrade --install kserve \
  oci://ghcr.io/kserve/charts/kserve-resources \
  --version "$KSERVE_VERSION" \
  --namespace kserve \
  --set kserve.controller.deploymentMode=Standard \
  --set kserve.controller.gateway.disableIngressCreation=true \
  --set kserve.controller.gateway.disableIstioVirtualHost=true \
  --wait \
  --timeout 10m

# Runtime definitions are shipped separately as of KServe 0.20. They map model
# formats (sklearn, XGBoost, Hugging Face, etc.) to model-server containers.
helm upgrade --install kserve-runtime-configs \
  oci://ghcr.io/kserve/charts/kserve-runtime-configs \
  --version "$KSERVE_VERSION" \
  --namespace kserve \
  --set kserve.servingruntime.enabled=true \
  --wait \
  --timeout 10m

kubectl wait --namespace kserve \
  --for=condition=Available deployment/kserve-controller-manager \
  --timeout=5m

printf '\nKServe %s is ready in Standard mode.\n' "$KSERVE_VERSION"
