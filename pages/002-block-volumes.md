---
type: feature
title: Block Volumes
---

```yaml
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: gpv-2
spec:
  storageClassName: glustervirtblock-csi
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

```bash
kubectl apply -f pvc-gpv-2.yaml
```

Light weight volumes for RWO use case

