---
type: feature
title: Thin Arbiter Volumes
---
```yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: gpv-3
spec:
  storageClassName:>
    glusterfs-csi-thin-arbiter
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 5Gi
```

```
kubectl create -f pvc-gpv-3.yaml
```

Power of high availability with only two data centers.
