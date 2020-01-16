# utcook - 支持istio的通用模板

[utcook](https://github.com/ygqygq2/charts/tree/master/utcook)是什么

## Introduction

This chart bootstraps utcook deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.6+
- PV provisioner support in the underlying infrastructure
- Helm v2.13.0+
- Istio v1.0.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release utcook  # helm v2
$ helm install my-release utcook  # helm v3
```

The command deploys utcook cluster on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

### Uninstall

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete [--purge] my-release  # helm v2
$ helm delete my-release  # helm v3
```

## Configuration

The following table lists the configurable parameters of the utcook chart and their default values.

| Parameter                  | Description                         | Default                                |
| -----------------------    | ----------------------------------- | -------------------------------------- |
| `statefulset.enabled`      | use statefulset to start            | `false`                                |
| `global`                   | global setting                      | see in values.yaml                     |
| `deploymentStrategy`       | deployment rollingUpdate setting    | `{}`                                   |
| `replicaCount`             | replicas number                     | `1`                                    |
| `service`                  | Service type, protocol, port        | `ClusterIP` `TCP` 8080                 |
| `env`                      | container env setting               | `[]`                                   |
| `startCommand`             | Start command                       | `[]`                                   |
| `config`                   | Additional configmap to use         | see in `values.yaml`                   |
| `secret`                   | Additional secret to use            | see in `values.yaml`                   |
| `image`                    | `utcook` image, tag.                | `bitnami/nginx` `latest`               |
| `ingress`                  | Ingress for the utcook.             | `false`                                |
| `autoscaling`              | Autoscaling using HorizontalPodAutoscaler| see in `values.yaml`              |
| `persistentVolume.enabled` | Create a volume to store data       | `false`                                |
| `persistentVolume.storageClass` | Type of persistent volume claim| `nil`                                  |
| `persistentVolume.accessModes`  | Persistent volume access modes | `[ReadWriteOnce]`                      |
| `persistentVolume.size`         | Persistent volume access modes | `1Gi`                                  |
| `persistentVolume.existingClaim`| Persistent volume existingClaim name| `{}`                              |
| `persistentVolume.mountPaths`   | Persistent directory path      | see in `values.yaml`                   |
| `persistentVolume.annotations`  | Persistent volume annotations  | `{}`                                   |
| `healthCheck.enabled`      | Liveness and readiness probes       | `true`, detail see in `values.yaml`    |
| `resources`                | CPU/Memory resource requests/limits | `{}`                                   |
| `lifecycle`                | Pod lifecycle                       | `{}`                                   |
| `deployment.additionalVolumes`| deployment annotations initContainers| `{}`                               |
| `additionalContainers`     | sidecar containers                  | `{}`                                   |
| `istio`                    | canary deployment and istio support.| see in values.yaml                     |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

