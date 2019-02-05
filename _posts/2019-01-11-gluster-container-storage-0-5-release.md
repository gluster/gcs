---
layout: post
title: "Gluster Container Storage 0.5 release"
author: "Atin Mukherjee"
---

Today, we are announcing the availability of GCS (Gluster Container
Storage) 0.5.

Highlights and updates since v0.4:

* GCS environment updated to kube 1.13
* CSI deployment moved to 1.0
* Integrated Anthill deployment
* Kube & etcd metrics added to prometheus
* Tuning of etcd to increase stability
* GD2 bug fixes from scale testing effort.

Included components:

* [Glusterd2](https://github.com/gluster/glusterd2)
* [Gluster CSI driver](https://github.com/gluster/gluster-csi-driver)
* [Gluster-prometheus](https://github.com/gluster/gluster-prometheus)
* [Anthill](https://github.com/gluster/anthill/)
* [Gluster-Mixins](https://github.com/gluster/gluster-mixins/)

For more details on the specific content of this release please refer
[here](https://waffle.io/gluster/gcs?label=GCS%2F0.5)(search for
‘Done’ lane)

If you are interested in contributing, please see
[here](https://github.com/gluster/gcs) or contact the gluster-devel
mailing list. We’re always interested in any bugs that you find, pull
requests for new features and your feedback.

Regards,  
Team GCS
