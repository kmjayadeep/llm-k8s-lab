#!/usr/bin/env bash
set -euo pipefail

cluster=kind-gpu

cat <<EOF
Deleting '$cluster'. Images stored in the Kind node will be lost.
The Hugging Face and Triton caches under ~/.cache will be preserved.
EOF
kind delete cluster --name "$cluster"
