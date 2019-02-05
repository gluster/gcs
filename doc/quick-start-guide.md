---
title: Quick Start Guide
layout: doc
order: 1
---

Gluster Container Storage aka GlusterCS, aims to offer a better
storage management experience with a leaner Gluster stack underneath
with focus on helping users to stay away from their storage related
worries especially when working on a hybrid cloud environment.

Install `glustercsctl` tool in one of the Kubernetes Master nodes
using `pip3 install glustercsctl`.

Prepare the configuration file as required to deploy GlusterCS.

```yaml
# File: mycluster.yaml
---
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

Where,

```
namespace    - Cluster namespace, useful when managing multiple
               clusters(Default is "gcs")
cluster-size - Number of nodes in Gluster cluster. Currently only 3
               nodes are supported.
nodes        - Details of nodes where Gluster server pods needs to be
               deployed.
address      - Address of node as listed in kubectl get nodes(Use
               `kubectl get nodes` to get the address)
devices      - Raw devices which are required to auto provision
               Gluster bricks during Volume create
```

Run the following command to deploy the GlusterCS cluster on an already
running kubernetes cluster.

```
glustercsctl deploy mycluster.yaml
```

To test whether the deployment was successfull or not, you can run
`kubectl get pods -n <namespace>` command on the master node. For
example,

```
kubectl get pods -n gcs
```

All the pods should be in Running state.

To create a File Volume and a pod to use the volume,

```yaml
# File: myapp.yaml
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

Create the Persistent volume claim and application pod by running the
following command

```
kubectl create -f myapp.yaml
```

Validate the File Volume creation by running `kubectl get pvc` command

```
NAME               STATUS    VOLUME                 CAPACITY   ACCESS MODES   STORAGECLASS   AGE
glusterfs-csi-pv   Bound     pvc-953d21f5a51311e8   5Gi        RWX            glusterfs-csi  3s
```

Verify app is in running state by running `kubectl get pods` command.

```
NAME        READY   STATUS        RESTARTS   AGE
myapp       1/1     Running       0          7m34s
```
