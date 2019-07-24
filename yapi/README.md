# yapi - YApi 是一个可本地部署的、打通前后端及QA的、可视化的接口管理平台

[yapi](https://hellosean1025.github.io/yapi/)是什么

## Introduction

This chart bootstraps yapi deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.6+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release mycharts/yapi
```

The command deploys yapi cluster on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

### Uninstall

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

## Configuration

The following table lists the configurable parameters of the FastDFS-Nginx chart and their default values.

| Parameter                  | Description                         | Default                                |
| -----------------------    | ----------------------------------- | -------------------------------------- |
| `statefulset.enabled`      | use statefulset to start            | `false`                                |
| `deploymentStrategy`       | deployment rollingUpdate setting    | `{}`                                   |
| `replicaCount`             | replicas number                     | `1`                                    |
| `service`                  | Service type, protocol, port        | `ClusterIP` `TCP` 3000                 |
| `env`                      | container env setting               | `[]`                                   |
| `config`                   | configmap to use                    | see in `values.yaml`                   |
| `secret`                   | secret to use                       | `[]`                                   |
| `image`                    | `yapi` image, tag.                  | `ygqygq2/yapi` `v1.7.2`                |
| `ingress`                  | Ingress for the yapi.               | `false`                                |
| `mongodb`                  | Yapi database to store data.        | see in `values.yaml`                   |
| `persistentVolume.enabled` | Create a volume to store data       | `false`                                |
| `persistence.storageClass` | Type of persistent volume claim     | `nil`                                  |
| `persistence.accessModes`  | Persistent volume access modes      | `[ReadWriteOnce]`                      |
| `persistence.existingClaim`| Persistent volume existingClaim name| `{}`                                   |
| `persistence.annotations`  | Persistent volume annotations       | `{}`                                   |
| `healthCheck.enabled`      | liveness and readiness probes       | `false`                                |
| `resources`                | CPU/Memory resource requests/limits | `{}`                                   |
| `deployment`               | deployment annotations initContainers| `{}`                                  |
| `extraContainers`          | sidecar containers                  | `{}`                                   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

## Persistence

The [yapi image](https://cloud.docker.com/repository/docker/ygqygq2/yapi) stores the data and configurations at the `/home/vendors` path of the container.

