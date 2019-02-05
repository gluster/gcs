---
title: Installation
layout: doc
order: 2
---

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

> All the pods should be in Running state.

To remove GlusterCS setup, run `kubectl delete namespace <namespace>`.
For example,

```
kubectl delete namespace gcs
```

More details about installing Kubernetes and GlusterCS is documented
[here](https://github.com/gluster/gcs/blob/master/doc/deploying_gcs_on_bare_metal_machines.md)
