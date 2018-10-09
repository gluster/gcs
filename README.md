As of now, one can already use Gluster as storage for containers by making use of different projects available in github repositories associated with Gluster (especially GlusterD1) & Heketi through [gluster-kubernetes](https://github.com/gluster/gluster-kubernetes) . The goal of the GCS initiative is to provide a new stack ( especially with [GD2](https://github.com/gluster/glusterd2), [gluster-csi-driver](https://github.com/gluster/gluster-csi-driver) ) focused on easier integration, much more opinionated bases install, a better upgrade experience to deploy Gluster for container storage. We are primarily focused on integration with Kubernetes (k8s) through this initiative.

## Quickstart - Try it out

The [deploy/ directory](deploy/) contains instructions for installing GCS,
either in a Vagrant-based test environment, or on your own cluster.

## Key projects for GCS

### Glusterd2 (GD2)

Repo: https://github.com/gluster/glusterd2

The challenge we have with current management layer of Gluster (glusterd) is that it is not designed for a service oriented architecture. Heketi overcame this limitation and made Gluster consumable in k8s by providing all the necessary hooks needed for supporting Persistent Volume Claims.

Glusterd2 provides a service oriented architecture for volume & cluster management. Gd2 also intends to provide many of the Heketi functionalities needed by Kubernetes natively. Hence we are working on merging Heketi with gd2 and you can follow more of this action in the issues associated with the gd2 github repository.

### anthill / operator
Repo: https://github.com/gluster/anthill

This project aims to add an operator for Gluster in Kubernetes., Since it is relatively new, there are areas where you can contribute to make the operator experience better (please refer to the list of issues). This project intends to make the whole Gluster experience in k8s much smoother by automatic management of operator tasks like installation, rolling upgrades etc.

### gluster-csi-driver
Repo: http://github.com/gluster/gluster-csi-driver

This project will provide CSI (Container Storage Interface) compliant drivers for GlusterFS & gluster-block in k8s. 

### gluster-kubernetes
Repo: https://github.com/gluster/gluster-kubernetes

This project is intended to provide all the required installation and management steps for getting gluster up and running in k8s.

### GlusterFS
Repo: https://github.com/gluster/glusterfs

GlusterFS is the main and the core repository of Gluster. To support storage in container world, we don’t need all the features of Gluster. Hence, we would be focusing on a stack which would be absolutely required in k8s. This would allow us to plan and execute tests well, and also provide users with a setup which works without too many options to tweak.

Notice that glusterfs default volumes would continue to work as of now, but the translator stack which is used in GCS will be much leaner and geared to work optimally in k8s. 

### Monitoring
Repo: https://github.com/gluster/gluster-prometheus

As k8s ecosystem provides its own native monitoring mechanisms, we intend to have this project be the placeholder for required monitoring plugins. The scope of this project is currently WIP and we welcome your inputs to shape the project.

More details on this can be found at: https://lists.gluster.org/pipermail/gluster-users/2018-July/034435.html


### Gluster-Containers

Repo: https://github.com/gluster/gluster-containers

This repository provides container specs / Dockerfiles that can be used with a container runtime like cri-o & docker.

### gluster-block
Repo: https://github.com/gluster/gluster-block

This project intends to expose files in a gluster volume as block devices. Gluster-block enables supporting ReadWriteOnce (RWO) PVCs and the corresponding workloads in Kubernetes using gluster as the underlying storage technology.

Gluster-block is intended to be consumed by stateful RWO applications like databases and k8s infrastructure services like logging, metrics etc. gluster-block is more preferred than file based Persistent Volumes in K8s for stateful/transactional workloads as it provides better performance & consistency guarantees.

----

Note that this is not an exhaustive or final list of projects involved with GCS. We will continue to update the project list depending on the new requirements and priorities that we discover in this journey.

We welcome you to join this journey by looking up the repositories and contributing to them. As always, we are happy to hear your thoughts about this initiative and please stay tuned as we provide periodic updates about GCS here!

