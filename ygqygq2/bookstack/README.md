# bookstack - 一款针对IT团队开发的简单好用的文档管理系统。

[BookStack](https://www.bookstack.cn) 基于MinDoc，使用Beego开发的在线文档管理系统，功能类似Gitbook和看云。

## Introduction

This chart bootstraps bookstack deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.6+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install my-release bookstack
```

The command deploys bookstack cluster on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

>tip:
>The default user is: admin
>The default password is: admin888

### Uninstall

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

## Configuration

The following table lists the configurable parameters of the bookstack chart and their default values.

| Parameter                  | Description                         | Default                                |
| -----------------------    | ----------------------------------- | -------------------------------------- |
| `statefulset.enabled`      | Use statefulset to start            | `false`                                |
| `deploymentStrategy`       | Deployment rollingUpdate setting    | `{}`                                   |
| `replicaCount`             | Replicas number                     | `1`                                    |
| `service`                  | Service type, protocol, port        | `ClusterIP` `TCP` 8181                 |
| `env`                      | Container env setting               | `[]`                                   |
| `startCommand`             | Start command                       | `[]`                                   |
| `config`                   | Additional configmap to use         | see in `values.yaml`                   |
| `secret`                   | Additional secret to use            | see in `values.yaml`                   |
| `image`                    | `bookstack` image, tag.                | `ygqygq2/bookstack` `latest`              |
| `ingress`                  | Ingress for the bookstack.             | `false`                                |
| `mongodb`                  | Yapi database to store data.        | see in `values.yaml`                   |
| `persistentVolume.enabled` | Create a volume to store data       | `false`                                |
| `persistentVolume.storageClass` | Type of persistent volume claim| `nil`                                  |
| `persistentVolume.accessModes`  | Persistent volume access modes | `[ReadWriteOnce]`                      |
| `persistentVolume.size`         | Persistent volume access modes | `2Gi`                                  |
| `persistentVolume.existingClaim`| Persistent volume existingClaim name| `{}`                              |
| `persistentVolume.mountPaths`   | Persistent directory path      | see in `values.yaml`                   |
| `persistentVolume.annotations`  | Persistent volume annotations  | `{}`                                   |
| `healthCheck.enabled`      | Liveness and readiness probes       | `true`, detail see in `values.yaml`    |
| `resources`                | CPU/Memory resource requests/limits | `{}`                                   |
| `deployment`               | Deployment annotations initContainers| `{}`                                  |
| `extraContainers`          | Sidecar containers                  | `{}`                                   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

## Persistence

The [bookstack image](https://cloud.docker.com/repository/docker/ygqygq2/bookstack) stores the data and configurations at the `/bookstack/uploads` `/bookstack/database` path of the container.

