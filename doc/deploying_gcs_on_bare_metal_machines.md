### Deploying kubernetes + GCS on bare metal machines

#### Cluster:

Total number of nodes: 3 {Node1, Node2, Node3}

#### Node configurations:

OS: Fedora 29<br/>
RAM: 128 GB<br/>
CPUs: 24<br/>

### Deploying Kubernetes on bare metal machines:

##### Cluster details:

Total number of nodes : 3 {Node1: kube1, Node2: kube2, Node3: kube3}<br/>
Master nodes : 1 {kube1}<br/>
Kube nodes: 3<br/>

#### Steps to install Kubernetes:

1. Install ansible on master node:<br/>
   `$ yum install ansible`

2. To ensure ansible is able to ssh into the nodes, add public key of master node{kube1} as authorized
   key in  other kube nodes<br/>
   `$  cat ~/.ssh/id_rsa.pub | ssh root@kube2 'cat >> ~/.ssh/authorized_keys'`

3. Stop firewalld on all machines<br/>
   `$ systemctl stop firewalld`

4. We will install kubernetes via the deploy-k8s script in the GCS repository. Clone GCS repository in master
   node(kube1):<br/>
  `$ git clone --recurse-submodules git@github.com:gluster/gcs.git`

5. To install kubernetes we need create an inventory file mentioning the kubernetes nodes.<br/>

   Template for GCS inventory file can be found under deploy directory in gcs repository:<br/>
   `https://github.com/gluster/gcs/blob/master/deploy/examples/inventory-gcs-kubespray.example`

   We will be deploying GCS after deploying kubernetes so we will have to provide GCS
   nodes in the inventory file. Also, we will mention the devices that we want to use to create volumes.
   Since we are using only 3 nodes we will provide devices for all the 3 nodes and mention
   all the nodes in the gcs nodes.
    ```
    kube1 ansible_host=<node-ip> gcs_disks='["<device1>", "<device2>"]'
    kube2 ansible_host=<node-ip> gcs_disks='["<device1>", "<device2>"]'
    kube3 ansible_host=<node-ip> gcs_disks='["<device1>", "<device2>"]'

    ## Hosts that will run etcd for the Kubernetes cluster
    [etcd]
    kube1
    kube2
    kube3

    ## Hosts that will be kubernetes master nodes
    [kube-master]
    kube1

    ## Hosts that will be kubernetes nodes
    [kube-node]
    kube1
    kube2
    kube3

    ## The full kubernetes cluster
    [k8s-cluster:children]
    kube-master
    kube-node

    ## Hosts that will be used for GCS.
    ## Systems grouped here need to define 'gcs_disks' as hostvars, which are the disks that will be used by GCS to 
    provision storage.
    [gcs-node]
    kube1
    kube2
    kube3
    ```


6. To deploy kubernetes we need to excecute deploy-k8s.yml file using ansible and provide inventory file created in Step 5.<br/>
   The deploy-k8s.yml file is present under deploy directory in gcs repository. <br />
   `$ ansible-playbook -i <path to inventory file>/<name of inventory file>  <path to`
     `deploy-k8s.yml file>/deploy-k8s.yml`

7. Check whether all the nodes are in ready state.<br />
   `$ kubectl get nodes`<br />

    The status of all the nodes should be in READY state.

> Note: In case deploy kubernetes fails then please check the troubleshooting section.

### Deploying GCS on kubernetes cluster:

#### Steps to install GCS:

1. To deploy GCS on kubernetes cluster we will execute the deploy-gcs.yml file using ansible from master node(kube 1). The deploy-gcs.yml file is present under deploy directory.<br />
   `$ ansible-playbook -i <path to inventory file>/<name of inventory file>  <path to deploy-gcs.yml file>/deploy-gcs.yml`.

### Testing the deployment

To test whether the deployment was successfull or not, you can run the following command on the master node.<br />
`$ kubectl get pods -n gcs`<br />

All the pods should be in `Running` state.

### Steps to create volume from kubernetes.

follow
[glusterfs](https://github.com/gluster/gluster-csi-driver/blob/master/README.md#create-a-glusterfs-storage-class-rwx)
to create and bind RWX PVC

follow
[gluster-virtblock](https://github.com/gluster/gluster-csi-driver/blob/master/README.md#create-a-gluster-virtual-block-storage-class)
to create and bind RWO PVC

### Scale Testing results:

We deployed GCS by following the steps mentioned above. We created 1000 volumes in batch of 250, and deleted 1000 volumes in the batch of 10. The scale testing results can be found in this [speadsheet](https://docs.google.com/spreadsheets/d/1nqySz3R2uR7MUPWWxzJMVWETMob-Mkwh67HmP6QHPDQ/edit?usp=sharing).

### Remove GCS setup

To remove gcs setup, run:<br />
`$ kubectl delete namespace gcs`

> Note : wait for the command to complete.

### Remove kubernetes cluster

To remove the kubernetes setup, run:<br />
`$ ansible-playbook -i <path to inventory file>/<name of inventory file>  <path to deploy directory>/deploy/kubespray/reset.yml`

### Troubleshooting

* If deploying kubernetes fails with error: `Failure: "No package docker-ce available.` <br />
  Then one must manually install docker-ce on the system.
  ##### In Centos:

  ```
  $ yum install docker
  $ systemctl status docker (to check whether docker is runnning or not)
  ```

  ##### In Fedora

  ```
  $ sudo dnf -y install dnf-plugins-core
  $ sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
  $ sudo dnf config-manager --set-enabled docker-ce-edge
  $ sudo dnf config-manager --set-enabled docker-ce-test
  $ sudo dnf install docker-ce
  $ sudo systemctl enable docker
  $ sudo systemctl start docker
  ```
