# FastDF-Nginx - Multiple tracker, Multiple storage

[FastDFS](https://github.com/happyfish100/fastdfs) is an open source high performance distributed file system (DFS). It's major functions include: file storing, file syncing and file accessing, and design for high capacity and load balance.

## Introduction

This chart bootstraps tracker and storage stateful-application on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager. Largely inspired by this [tutorial](https://kubernetes.io/docs/tutorials/stateful-application/run-replicated-stateful-application/), further work was made to 'production-ize' the example.

## Prerequisites

- Kubernetes 1.6+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install my-release local/fastdfs-nginx
```

The command deploys FastDFS-Nginx cluster on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

### Uninstall

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

## Configuration

The following table lists the configurable parameters of the FastDFS-Nginx chart and their default values.

| Parameter                  | Description                         | Default                                |
| -----------------------    | ----------------------------------- | -------------------------------------- |
| `fastdfs.storage`          | storage replicas number and pvc size| See `values.yaml`                      |
| `fastdfs.tracker`          | tracker replicas number, pvc size and nginx config file.| See `values.yaml`  |
| `service.type`             | Service type.                       | `ClusterIP`                            |
| `image`                    | `fastdfs-nginx` image, tag.         | `ygqygq2/fastdfs-nginx` `V6.07`        |
| `trackerPorts`             | tracker and nginx ports.            | See `values.yaml`                      | 
| `storagePorts`             | storage and nginx ports.            | See `values.yaml`                      |
| `ingress`                  | Ingress for the fastdfs tracker nginx.| `false`                              |
| `persistentVolume.enabled` | Create a volume to store data       | true                                   |
| `persistence.storageClass` | Type of persistent volume claim     | `nil`                                  |
| `persistence.accessModes`  | Persistent volume access modes      | `[ReadWriteOnce]`                      |
| `persistence.annotations`  | Persistent volume annotations       | `{}`                                   |
| `resources`                | CPU/Memory resource requests/limits | Memory: `128Mi`, CPU: `100m`           |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

## Persistence

The [FastDFS image](https://github.com/ygqygq2/fastdfs-nginx) stores the data and configurations at the `/var/fdfs` path of the container.

By default persistence is enabled, and a PersistentVolumeClaim is created and mounted in that directory. As a result, a persistent volume will need to be defined:

```
# https://kubernetes.io/docs/user-guide/persistent-volumes/#azure-disk
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: fast
provisioner: kubernetes.io/azure-disk
parameters:
  skuName: Premium_LRS
  location: westus
```

In order to disable this functionality you can change the values.yaml to disable persistence and use an emptyDir instead.
