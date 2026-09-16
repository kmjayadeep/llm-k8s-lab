# Kserve

Kserve is used to abstract the deployment of llm models in k8s

```
./scripts/kind-up.sh
./scripts/kserve-isntall.sh
```

It 
- Installs cert-manager
- Deploymentmode standard (no knative)
- disble isio virtualhost and ingress
- installs runtime configs (for mapping model formats to model-server containers)

Deploy inference example

```
k apply -k k8s/kserve-inference
```
Test it with

```
./scripts/test-kserve-inference.sh
```

## LLM

Deploy llm model

```
k apply -k k8s/kserve-llm
```

It deploys `Qwen/Qwen2.5-0.5B-Instruct` with a config similar to our docker-compose file.

Also adds a nodeport service which maps to localhost:8000 so we can use existing ui for test scripts or even litellm
