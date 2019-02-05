---
title: Thin Arbiter Volumes
layout: doc
order: 5
---

Thin Arbiter is a new type of quorum node where granularity of what is
good and what is bad data is less compared to the traditional arbiter
brick. In this type of volume, quorum is taken into account at a brick
level rather than per file basis. If there is even one file that is
marked bad (i.e. needs healing) on a data brick, that brick is
considered bad for all files as a whole. So, even different file, if
the write fails on the other data brick but succeeds on this 'bad'
brick we will return failure for the write.

More details about this feature is documented
[here](https://docs.gluster.org/en/latest/Administrator%20Guide/Thin-Arbiter-Volumes/)

Storage class needs to be created with the required parameters,


```yaml
# File: thin-arbiter-storageclass.yaml
---
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: glusterfs-csi-thin-arbiter
provisioner: org.gluster.glusterfs
parameters:
  arbiterType: "thin"
  arbiterPath: "192.168.10.90:24007/mnt/arbiter-path"
```

Create the Thin arbiter storage class by running the following command,

```
kubectl create -f thin-arbiter-storageclass.yaml
```

Persistent Volumes can be created by using the storage class created above.

```yaml
# File: thin-arbiter-pvc.yaml
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: glusterfs-csi-thin-pv
spec:
  storageClassName: glusterfs-csi-thin-arbiter
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 5Gi
```

Submit the claim by running `kube create -f thin-arbiter-pvc.yaml`
command.

Verify PVC is in Bound state using `kubectl get pvc` command,

```
NAME                     STATUS        VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS            AGE
glusterfs-csi-thin-pv    Bound         pvc-86b3b70b-1fa0-11e9-9232-525400ea010d   5Gi        RWX            glusterfs-csi-arbiter   13m
```

Application pod can be created to use the persistent volume created
using the previous step.

```yaml
# File: thin-arbiter-pod.yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: ta-redis
  labels:
    name: redis
spec:
  containers:
    - name: redis
      image: redis
      imagePullPolicy: IfNotPresent
      volumeMounts:
        - mountPath: "/data"
          name: glusterfscsivol
  volumes:
    - name: glusterfscsivol
      persistentVolumeClaim:
        claimName: glusterfs-csi-thin-pv
```

Create the application pod running `kubectl create -f
thin-arbiter-pod.yaml`

Verify app is in running state by running `kubectl get pods` command.

```
NAME        READY   STATUS        RESTARTS   AGE
ta-redis    1/1     Running       0          6m54s
```
