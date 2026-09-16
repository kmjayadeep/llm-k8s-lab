#!/usr/bin/env bash
set -euo pipefail

namespace=${NAMESPACE:-kserve-test}
model=${MODEL_NAME:-sklearn-iris}
local_port=${PORT:-8080}
service=${model}-predictor

kubectl wait --namespace "$namespace" \
  --for=condition=Ready "inferenceservice/$model" \
  --timeout=10m

kubectl --namespace "$namespace" port-forward "service/$service" "$local_port:80" >/tmp/kserve-port-forward.log 2>&1 &
port_forward_pid=$!
trap 'kill "$port_forward_pid" 2>/dev/null || true' EXIT

for _ in {1..30}; do
  if curl --silent --fail "http://127.0.0.1:$local_port/v1/models/$model" >/dev/null; then
    break
  fi
  sleep 1
done

curl --fail-with-body \
  --header 'Content-Type: application/json' \
  --data '{"instances":[[6.8,2.8,4.8,1.4],[6.0,3.4,4.5,1.6]]}' \
  "http://127.0.0.1:$local_port/v1/models/$model:predict"
printf '\n'
