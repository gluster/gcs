---
title: Block Volumes
layout: doc
order: 4
---

Verify gluster virtual block storage class

```
[root@localhost]# kubectl get storageclass
NAME                             PROVISIONER                    AGE
glustervirtblock-csi             org.gluster.glustervirtblock   6s
```

Persistent Volumes Claims can be created using the storage class
created above.

```yaml
# File: pvc.yaml
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: glusterblock-csi-pv
spec:
  storageClassName: glustervirtblock-csi
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

Run `kubectl create` command to submit the claim,

```
kubectl create -f pvc.yaml
```

Validate the Block Volume creation by running `kubectl get
pvc` command

```
NAME                  STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS           AGE
glusterblock-csi-pv   Bound    pvc-1048edfb-1f06-11e9-8b7a-525400491c42   1Gi        RWO            glustervirtblock-csi   8s
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
    app: myapp
spec:
  containers:
  - name: myapp
    image: redis
    imagePullPolicy: IfNotPresent
    volumeMounts:
    - mountPath: "/data"
      name: glusterblockcsivol
  volumes:
  - name: glusterblockcsivol
    persistentVolumeClaim:
      claimName: glusterblock-csi-pv
```

Create the application pod by running `kubectl create -f app.yaml`
command.

Verify app is in running state by running `kubectl get pods` command.

```
NAME        READY   STATUS    RESTARTS   AGE
myapp       1/1     Running   0          38s
```

Pod can be deleted by running the following command

```
kubectl delete pod myapp
```

Persistent volume can be deleted by running the following command

```
kubectl delete pvc glusterblock-csi-pv
```

