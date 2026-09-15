# Kind kubernetes

Start using

```
./scripts/kind-up.sh
```

It mounts the kfd and dri devices into the control plane node. Also maps hostport 8000 into containerport 30434. it can be used by nodeport service


It also Installs AMD device plugin through 

```
k apply -f kind/amd-device-plugin.yaml
```

It exposes the AMD GPU to the pods through the `amd.com/gpu` resource. So we dont need to pass through the kfd and dri devices into the pods. The device plugin will take care of it.

the kind definition also mounts huggingface and triton caches

A vllm deployment is created based on the same compose file. Had to add `enableServiceLinks: false` to avoid k8s service environment variables being injected into the container. It was conflicting with vllm's own environment variables. The deployment is created in the `vllm` namespace.


```
k apply -k k8s/vllm
```

container image is quite big at 75GB. so it takes a while to start
