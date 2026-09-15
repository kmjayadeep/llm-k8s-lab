#!/usr/bin/env bash
set -euo pipefail

port=8000
model="qwen"

curl -fsS "http://127.0.0.1:${port}/v1/chat/completions" \
  -H 'Content-Type: application/json' \
  -d "$(jq -n \
    --arg model "$model" \
    --arg prompt "${PROMPT:-In one short sentence, explain what vLLM does.}" \
    '{model: $model, stream: true, messages: [{role: "user", content: $prompt}], max_tokens: 64, temperature: 0}')"
