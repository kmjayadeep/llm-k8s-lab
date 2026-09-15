#!/usr/bin/env bash
set -euo pipefail

cluster=kind-gpu
context=kind-$cluster

current=$(kubectl config current-context 2>/dev/null || true)
trap '[[ -z "$current" ]] || kubectl config use-context "$current" >/dev/null' EXIT

kind get clusters | grep -qx "$cluster" || \
  kind create cluster --config "kind/kind-gpu.yaml"

kubectx "$context"

kubectl apply -f kind/amd-device-plugin.yaml
