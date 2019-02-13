---
type: feature
title: Ease of Use
---

```yaml
namespace: gcs
cluster-size: 3
nodes:
  - address: kube1
    devices: ["/dev/vdc"]

  - address: kube2
    devices: ["/dev/vdc"]

  - address: kube3
    devices: ["/dev/vdc"]
```

```
kubectl gluster deploy ./mycluster.yml
```

Easy to install on an already running kubernetes cluster.
