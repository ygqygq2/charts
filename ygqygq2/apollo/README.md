# apollo - helm chart 模板

[apollo](https://)是什么

## Introduction

This chart bootstraps apollo deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.6+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release apollo
```

The command deploys apollo cluster on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

### Uninstall

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

## Configuration

The following table lists the configurable parameters of the apollo chart and their default values.

| Parameter                  | Description                         | Default                                |
| -----------------------    | ----------------------------------- | -------------------------------------- |
| `global`                   | Global setting                      | see in values.yaml                     |
| `adminservice.statefulset.enabled`      | Use statefulset to start            | `false`                                |
| `adminservice.deploymentStrategy`       | Deployment rollingUpdate setting    | `{}`                                   |
| `adminservice.replicaCount`             | Replicas number                     | `1`                                    |
| `adminservice.service`                  | Service type, protocol, port        | `ClusterIP` `TCP` 8080                 |
| `adminservice.env`                      | Container env setting               | `[]`                                   |
| `adminservice.startCommand`             | Start command                       | `[]`                                   |
| `adminservice.config`                   | Additional configmap to use         | see in `values.yaml`                   |
| `adminservice.secret`                   | Additional secret to use            | see in `values.yaml`                   |
| `adminservice.image`                    | `apollo` image, tag.             | `bitnami/nginx` `latest`               |
| `adminservice.ingress`                  | Ingress for the apollo.          | `false`                                |
| `adminservice.persistentVolume.enabled` | Create a volume to store data       | `false`                                |
| `adminservice.persistentVolume.storageClass` | Type of persistent volume claim| `nil`                                  |
| `adminservice.persistentVolume.accessModes`  | Persistent volume access modes | `[ReadWriteOnce]`                      |
| `adminservice.persistentVolume.size`         | Persistent volume access modes | `1Gi`                                  |
| `adminservice.persistentVolume.existingClaim`| Persistent volume existingClaim name| `{}`                              |
| `adminservice.persistentVolume.mountPaths`   | Persistent directory path      | see in `values.yaml`                   |
| `adminservice.persistentVolume.annotations`  | Persistent volume annotations  | `{}`                                   |
| `adminservice.healthCheck.enabled`      | Liveness and readiness probes       | `true`, detail see in `values.yaml`    |
| `adminservice.resources`                | CPU/Memory resource requests/limits | `{}`                                   |
| `adminservice.lifecycle`                | Pod lifecycle                       | `{}`                                   |
| `adminservice.deployment.additionalVolumes`| Deployment additionalVolumes     | `[]`                                   |
| `adminservice.additionalContainers`     | Sidecar containers                  | `{}`                                   |
| `configservice.statefulset.enabled`      | Use statefulset to start            | `false`                                |
| `configservice.deploymentStrategy`       | Deployment rollingUpdate setting    | `{}`                                   |
| `configservice.replicaCount`             | Replicas number                     | `1`                                    |
| `configservice.service`                  | Service type, protocol, port        | `ClusterIP` `TCP` 8080                 |
| `configservice.env`                      | Container env setting               | `[]`                                   |
| `configservice.startCommand`             | Start command                       | `[]`                                   |
| `configservice.config`                   | Additional configmap to use         | see in `values.yaml`                   |
| `configservice.secret`                   | Additional secret to use            | see in `values.yaml`                   |
| `configservice.image`                    | `apollo` image, tag.             | `bitnami/nginx` `latest`               |
| `configservice.ingress`                  | Ingress for the apollo.          | `false`                                |
| `configservice.persistentVolume.enabled` | Create a volume to store data       | `false`                                |
| `configservice.persistentVolume.storageClass` | Type of persistent volume claim| `nil`                                  |
| `configservice.persistentVolume.accessModes`  | Persistent volume access modes | `[ReadWriteOnce]`                      |
| `configservice.persistentVolume.size`         | Persistent volume access modes | `1Gi`                                  |
| `configservice.persistentVolume.existingClaim`| Persistent volume existingClaim name| `{}`                              |
| `configservice.persistentVolume.mountPaths`   | Persistent directory path      | see in `values.yaml`                   |
| `configservice.persistentVolume.annotations`  | Persistent volume annotations  | `{}`                                   |
| `configservice.healthCheck.enabled`      | Liveness and readiness probes       | `true`, detail see in `values.yaml`    |
| `configservice.resources`                | CPU/Memory resource requests/limits | `{}`                                   |
| `configservice.lifecycle`                | Pod lifecycle                       | `{}`                                   |
| `configservice.deployment.additionalVolumes`| Deployment additionalVolumes     | `[]`                                   |
| `configservice.additionalContainers`     | Sidecar containers                  | `{}`                                   |
| `portal.statefulset.enabled`      | Use statefulset to start            | `false`                                |
| `portal.deploymentStrategy`       | Deployment rollingUpdate setting    | `{}`                                   |
| `portal.replicaCount`             | Replicas number                     | `1`                                    |
| `portal.service`                  | Service type, protocol, port        | `ClusterIP` `TCP` 8080                 |
| `portal.env`                      | Container env setting               | `[]`                                   |
| `portal.startCommand`             | Start command                       | `[]`                                   |
| `portal.config`                   | Additional configmap to use         | see in `values.yaml`                   |
| `portal.secret`                   | Additional secret to use            | see in `values.yaml`                   |
| `portal.image`                    | `apollo` image, tag.             | `bitnami/nginx` `latest`               |
| `portal.ingress`                  | Ingress for the apollo.          | `false`                                |
| `portal.persistentVolume.enabled` | Create a volume to store data       | `false`                                |
| `portal.persistentVolume.storageClass` | Type of persistent volume claim| `nil`                                  |
| `portal.persistentVolume.accessModes`  | Persistent volume access modes | `[ReadWriteOnce]`                      |
| `portal.persistentVolume.size`         | Persistent volume access modes | `1Gi`                                  |
| `portal.persistentVolume.existingClaim`| Persistent volume existingClaim name| `{}`                              |
| `portal.persistentVolume.mountPaths`   | Persistent directory path      | see in `values.yaml`                   |
| `portal.persistentVolume.annotations`  | Persistent volume annotations  | `{}`                                   |
| `portal.healthCheck.enabled`      | Liveness and readiness probes       | `true`, detail see in `values.yaml`    |
| `portal.resources`                | CPU/Memory resource requests/limits | `{}`                                   |
| `portal.lifecycle`                | Pod lifecycle                       | `{}`                                   |
| `portal.deployment.additionalVolumes`| Deployment additionalVolumes     | `[]`                                   |
| `portal.additionalContainers`     | Sidecar containers                  | `{}`                                   |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```
$ helm install --name my-release \
  --set adminservice.replicaCount=2 \
    apollo
```

The above command sets the `replicaCount` to `2`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```
$ helm install --name my-release -f values.yaml apollo
```

>**Tip**: You can use the default [values.yaml](#values.yaml)

