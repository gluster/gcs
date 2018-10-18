# GCS Deployment scripts

This repository contains playbooks to deploy a GCS cluster on Kubernetes. It also contains a Vagrantfile to setup a local GCS cluster using vagrant-libvirt.

> _IMP: Clone this repository with submodules_

## Available playbooks

### deploy-k8s.yml

This playbook deploys a kubernetes cluster on the configured nodes, and creates a copy of the kube-config to allow kubectl from the Ansible host.
Kubernetes is configured to use Flannel as the network plugin.

> TODO:  
> - Describe the minimum required ansible inventory format. Till then ./kubespray/inventory/sample/hosts.ini


### deploy-gcs.yml

This playbook deploys GCS on a Kubernetes cluster. All of GCS, except for the StorageClass is deployed into its own namespace. The playbook deploys the following,

- etcd-operator
- etcd-cluster with 3 nodes
- glusterd2-cluster with a pod on each kube node and configured to use the deployed etcd-cluster
- glusterd2-client service providing a single rest access point to GD2
- csi-driver (provisioner, nodeplugin, attacher) configured to use glusterd2-client service to reach GD2

> NOTE: The glusterd2-cluster deployment is unsecure currently, with ReST API auth disabled and without any TLS. This leaves the cluster open to direct access by other applications on the Kubernetes cluster.

Uses the inventory defined for deploy-k8s.yml.

At the moment this is a playbook, but it really should become a role.

> TODO:  
> - Enable secure deployment with ReST AUTH and TLS.
> - Convert to role
> - Add more configurability

### vagrant-playbook.yml

This playbook combines all the above to provision the local cluster brought up by Vagrant

## Helper scripts

### prepare.sh

This script prepares the local environment to run the deployment.

## How to use

### Requirements

- ansible
- python-virtualenv

#### Optional

- vagrant, vagrant-libvirt - Only required if you want to bring up the vagrant powered local cluster
- kubectl - Only required if you plan to manage the kube cluster from the ansible host

### External kube cluster

To use the deploy-gcs.yml playbook on an external setup kubernetes cluster, requires a custom inventory file.
An example of this custom inventory is in `examples/inventory-gcs-only.example`

Please read up the [ansible inventory](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html) documentation to learn about the ansible inventory file format.

The custom inventory file needs the following,

- One or more kubernetes master hosts must be defined, and must be set up with password-less ssh.
- One or more gcs hosts must be defined as well, but need not have password-less ssh.
- The hostnames used to the gcs hosts must be the ones used by kubernetes as the node names. If unsure, get the correct names using `kubectl get nodes`.
- The gcs hosts must define the disks to be used by GCS, as a `gcs_disks` hostvar.
- A `kube-master` group must be defined, with the master hosts as members.
- A `gcs-node` group must be defined, with the gcs hosts as members.

With the inventory file defined, run the deploy-gcs playbook as follows,

```
(gcs-venv) $ ansible-playbook --become deploy-gcs.yml
```

### Local cluster using Vagrant

The provided Vagrantfile brings up a 3-node kubernetes cluster, with 3 1000GB
virtual disks attached to each node.

> Note that the virtual disks are created in the default storage pool of libvirt,
> though they are all sparse images.  The default storage pool is set to
> /var/lib/libvirt/images, so if used the cluster is used heavily for GCS
> testing, it is possible to run out of space on your root partition.

- Run the `prepare.sh` script to perform preliminary checks and prepare the virtualenv.

```
$ ./prepare.sh
```

- Activate the virtualenv
```
$ source gcs-venv/bin/activate
(gcs-venv) $
```

- Bring up the cluster. This will take a long time.

```
(gcs-venv) $ vagrant up
```

Once begin using the cluster once it's up by either,
- SSHing into one of the Kube nodes and running the `kubectl` commands in there

```
(gcs-venv) $ vagrant ssh kube1
```

#### Resetting the cluster

If the Vagrant vms are restarted (say because of host reboot), the kubernetes cluster cannot come back up. In such a case, reset the cluster and re-deploy kube and GCS.

```
(gcs-venv) $ ansible-playbook --become vagrant-reset.yml
.
.
.
(gcs-venv) $ ansible-playbook --skip-tags predeploy --become vagrant-playbook.yml
.
.
.
```

This will create a brand new cluster. If this fails, destroy the vagrant environment and restart fresh.

```
(gcs-venv) $ vagrant destroy -f
.
.
.
(gcs-venv) $ vagrant up
```

### Deploying an app with GCS backed volume

An example config is provided for creating a PersistentVolumeClaim against GCS and using the claim in an app, in [examples/app-using-gcs-volume.yml](examples/app-using-gcs-volume.yml)

ssh to the master node:
```
(gcs-venv) $ vagrant ssh kube1
```

Create a config file and deploy the application along with PVC as below:
```
vagrant@kube1 ~]$ kubectl create -f app-using-gcs-volume.yml
```

### Deploying an app with GCS backed cloned volume

An example config is provided for creating a snapshot of a volume and creating a PersistentVolumeClaim against GCS from the snapshot and using the claim in an app, in [examples/app-using-gcs-volume-clone.yml](examples/app-using-gcs-volume.yml)

Create a config file and deploy the application as below:

```
vagrant@kube1 ~]$ kubectl create -f app-using-gcs-volume-clone.yml
```

### Accessing glustercli from glusterd2 pods

- List glusterd2 pods

```
kubectl get po -ngcs --selector=app.kubernetes.io/name=glusterd2
NAME              READY   STATUS    RESTARTS   AGE
gluster-kube1-0   1/1     Running   0          16h
gluster-kube2-0   1/1     Running   0          16h
gluster-kube3-0   1/1     Running   0          16h
```

- Step inside any one of the glusterd2 pod

```
[vagrant@kube1 ~]$ kubectl exec -it gluster-kube1-0 /bin/bash -ngcs
[root@gluster-kube1-0 /]#
```

- Accessing glustercli inside pod

```
[root@gluster-kube1-0 /]# glustercli peer  list
+--------------------------------------+---------+-----------------------------+-----------------------------+--------+-----+
|                  ID                  |  NAME   |      CLIENT ADDRESSES       |       PEER ADDRESSES        | ONLINE | PID |
+--------------------------------------+---------+-----------------------------+-----------------------------+--------+-----+
| 33346529-d8df-45ff-aeaf-3befed986435 | gluster-kube1-0 | gluster-kube1-0.glusterd2.gcs:24007 | gluster-kube1-0.glusterd2.gcs:24008 | yes    |  21 |
| 4527724d-e5de-4b58-a6e8-8f15490fa6b5 | gluster-kube3-0 | gluster-kube3-0.glusterd2.gcs:24007 | gluster-kube3-0.glusterd2.gcs:24008 | yes    |  21 |
| d35ef7e1-1846-4826-8447-2d1f92de0881 | gluster-kube2-0 | gluster-kube2-0.glusterd2.gcs:24007 | gluster-kube2-0.glusterd2.gcs:24008 | yes    |  21 |
+--------------------------------------+---------+-----------------------------+-----------------------------+--------+-----+
```

### Accessing Prometheus UI and Grafana Dashboard to view the metrics

To access the Prometheus UI, load up the web browser from the host machine and go to ```http://localhost:9090/graph``` to view the prometheus UI. The available metrics can be viewed and selected from the dropdown tab and press Execute to show the values.

To access the Grafana Dashboard: 

1) Load up the web browser from the host machine and go to ```http://localhost:9000``` to view the Grafana UI. 

2) Enter Username and password as ```admin```. 

3) Select New Dashboard ( No need to add a datasource because prometheus datasource is added by default in the deployment ) --> Graph --> Panel Title --> Edit.

4) Select Prometheus as the data source in the data source drop down menu.

5) You can now use the expression tab to lookup metrics via autocompletion.

