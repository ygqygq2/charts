# mod-chart - JAVA微服务模板

[mod-chart](https://)是什么

## Introduction

This chart bootstraps mod-chart deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.6+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release mycharts/mod-chart
```

The command deploys mod-chart cluster on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

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
| `service`                  | Service type, protocol, port        | `ClusterIP` `TCP` 8080, 5005           |
| `env`                      | container env setting               | `[]`                                   |
| `config`                   | configmap to use                    | `[]`                                   |
| `secret`                   | secret to use                       | `[]`                                   |
| `image`                    | `mod-chart` image, tag.            | `reg.utcook.com/pub/dockerImageName` `dockerTag`|
| `ingress`                  | Ingress for the mod-chart.         | `false`                                |
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

The [mod-chart image](https://) stores the data and configurations at the `/data` path of the container.

