# alertmanager2es 

[alertmanager2es](https://github.com/ygqygq2/alertmanager2es) receives HTTP webhook notifications from AlertManager and inserts them into an Elasticsearch index for searching and analysis. It runs as a daemon.

## Introduction

This chart bootstraps alertmanager2es deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.6+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install my-release alertmanager2es
```

The command deploys alertmanager2es cluster on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

### Uninstall

To uninstall/delete the `my-release` deployment:

```bash
$ helm uninstall my-release
```

## Configuration

The following table lists the configurable parameters of the alertmanager2es chart and their default values.

| Parameter                  | Description                         | Default                                |
| -----------------------    | ----------------------------------- | -------------------------------------- |
| `statefulset.enabled`      | Use statefulset to start            | `false`                                |
| `global`                   | Global setting                      | see in values.yaml                     |
| `deploymentStrategy`       | Deployment rollingUpdate setting    | `{}`                                   |
| `replicaCount`             | Replicas number                     | `1`                                    |
| `service`                  | Service type, protocol, port        | `ClusterIP` `TCP` `9097`               |
| `env`                      | Container env setting               | `[]`                                   |
| `startCommand`             | Start command                       | `[]`                                   |
| `config`                   | Additional configmap to use         | see in `values.yaml`                   |
| `secret`                   | Additional secret to use            | see in `values.yaml`                   |
| `image`                    | `alertmanager2es` image, tag.       | `ygqygq2/alertmanager2es` `latest`     |
| `ingress`                  | Ingress for the alertmanager2es.    | `false`                                |
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
| `additionalContainers`     | Sidecar containers                  | `{}`                                   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```
$ helm install my-release \
  --set replicaCount=2 \
    alertmanager2es
```

The above command sets the `replicaCount` to `2`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```
$ helm install my-release -f values.yaml alertmanager2es
```

>**Tip**: You can use the default [values.yaml](#values.yaml)

