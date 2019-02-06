---
title: File Volumes
layout: doc
order: 3
---

Verify the File Volumes storage class by running `kubectl get
storageclass` command.

```
NAME                      PROVISIONER             AGE
glusterfs-csi (default)   org.gluster.glusterfs   105s
```

To create a File Volume, claim for a Persistent Volume by creating a
claim as below.

```yaml
# File: pvc.yaml
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: glusterfs-csi-pv
spec:
  storageClassName: glusterfs-csi
  accessModes:
  - ReadWriteMany
  resources:
    requests:
      storage: 5Gi
```

Run `kubectl create` command to submit the claim,

```
kubectl create -f pvc.yaml
persistentvolumeclaim/glusterfs-csi-pv created
```

Validate the File Volume creation by running `kubectl get pvc` command

```
NAME               STATUS    VOLUME                 CAPACITY   ACCESS MODES   STORAGECLASS   AGE
glusterfs-csi-pv   Bound     pvc-953d21f5a51311e8   5Gi        RWX            glusterfs-csi  3s
```

Application pod can be created to use the persistent volume created
using the previous step.

```yaml
# File: app.yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: myapp
  labels:
    name: myapp
spec:
  containers:
  - name: myapp
    image: redis
    imagePullPolicy: IfNotPresent
    volumeMounts:
    - mountPath: "/data"
      name: glustercsivol
  volumes:
  - name: glustercsivol
    persistentVolumeClaim:
      claimName: glusterfs-csi-pv
```

Create the application pod by running `kubectl create -f app.yaml`
command.

Verify app is in running state by running `kubectl get pods` command.

```
NAME        READY   STATUS        RESTARTS   AGE
myapp       1/1     Running       0          7m34s
```
