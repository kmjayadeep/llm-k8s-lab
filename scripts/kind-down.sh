#!/usr/bin/env bash
set -euo pipefail

cluster=kind-gpu
node=${cluster}-control-plane

if docker inspect "$node" >/dev/null 2>&1; then
  docker stop "$node"
else
  echo "Kind cluster '$cluster' does not exist."
fi
