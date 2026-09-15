#!/usr/bin/env bash
set -euo pipefail

cluster=kind-gpu
context=kind-$cluster
node=${cluster}-control-plane

current=$(kubectl config current-context 2>/dev/null || true)
trap '[[ -z "$current" ]] || kubectl config use-context "$current" >/dev/null' EXIT

# These host directories are mounted into the Kind node so model and kernel
# caches survive cluster recreation.
mkdir -p "$HOME/.cache/huggingface" "$HOME/.cache/vllm/triton"

if docker inspect "$node" >/dev/null 2>&1; then
  if [[ $(docker inspect -f '{{.State.Running}}' "$node") != true ]]; then
    docker start "$node" >/dev/null
  fi
else
  kind create cluster --config kind/kind-gpu.yaml
fi

kubectl --context "$context" wait --for=condition=Ready "node/$node" --timeout=5m

kubectl --context "$context" apply -f kind/amd-device-plugin.yaml
kubectl --context "$context" rollout status \
  daemonset/amdgpu-device-plugin-daemonset \
  --namespace kube-system \
  --timeout=5m
