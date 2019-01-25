---
type: feature
title: File Volumes
---

```yaml
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: gpv-1
spec:
  storageClassName: glusterfs-csi
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
```

```bash
kubectl apply -f pvc-gpv-1.yaml
```

Individual Gluster volumes for each request.
