#!/usr/bin/env bash
set -euo pipefail

cluster=kind-gpu

kind delete cluster --name "$cluster" || true
