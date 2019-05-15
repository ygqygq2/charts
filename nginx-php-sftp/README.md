# nginx-php-sftp - 有sftp功能的nginx

[nginx-php-sftp](https://github.com/ygqygq2/charts/tree/master/nginx-php-sftp)是什么

## Introduction

This chart bootstraps nginx-php-sftp deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.6+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release ./nginx-php-sftp
```

The command deploys nginx-php-sftp cluster on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

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
| `image`                    | `nginx-php-sftp` image, tag.            | `reg.nginx-php-sftp.com/pub/dockerImageName` `dockerTag`|
| `ingress`                  | Ingress for the nginx-php-sftp.         | `false`                                |
| `persistentVolume.enabled` | Create a volume to store data       | `false`                                |
| `persistentVolume.storageClass` | Type of persistent volume claim     | `nil`                                  |
| `persistentVolume.accessModes`  | Persistent volume access modes      | `[ReadWriteMany]`                      |
| `persistentVolume.existingClaim`| Persistent volume existingClaim name| `{}`                                   |
| `persistentVolume.annotations`  | Persistent volume annotations       | `{}`                                   |
| `healthCheck.enabled`      | liveness and readiness probes       | `false`                                |
| `resources`                | CPU/Memory resource requests/limits | `{}`                                   |
| `deployment`               | deployment annotations initContainers| `{}`                                  |
| `extraContainers`          | sidecar containers                  | `{}`                                   |
| `metrics`                  | nginx metrics                       | see more in `values.yaml`              |
| `sftp`                     | sftp to upload files                | see more in `values.yaml`              |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

## Persistence

The [nginx-php-sftp image](https://github.com/ygqygq2/sftp) stores the data and configurations at the `/home/dev/upload` path of the container.

