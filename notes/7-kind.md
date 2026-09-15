# Kind kubernetes

Start using

```
./scripts/kind-up.sh
```

It mounts the kfd and dri devices into the control plane node. Also maps hostport 8000 into containerport 30434. it can be used by nodeport service


Install AMD device plugin through 

```
k apply -f kind/amd-device-plugin.yaml
```

It exposes the AMD GPU to the pods through the `amd.com/gpu` resource. So we dont need to pass through the kfd and dri devices into the pods. The device plugin will take care of it.
