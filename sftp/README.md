# sftp - Securely share your files

[sftp](https://github.com/atmoz/sftp)docker

## Introduction

This chart bootstraps sftp deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.6+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release ./
```

The command deploys sftp cluster on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

### Uninstall

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

## Configuration

The following table lists the configurable parameters of the FastDFS-Nginx chart and their default values.

| Parameter                  | Description                         | Default                                |
| -----------------------    | ----------------------------------- | -------------------------------------- |
| `replicaCount`             | replicas number                     | `1`                                    |
| `sshConfFile`              | sftp ssh config file                | look it in values.yaml                 |
| `usersConfFile`            | sftp users config file              | look it in values.yaml                 |
| `scriptFile`               | docker start to run this script     | look it in values.yaml                 |
| `service`                  | Service type, protocol, port        | `ClusterIP` `TCP` 22                   |
| `image`                    | `sftp` image, tag.          | `ygqygq2/sftp` `latest`    |
| `persistentVolume.enabled` | Create a volume to store data       | `false`                                |
| `persistentVolume.storageClass` | Type of persistent volume claim     | `nil`                                  |
| `persistentVolume.accessModes`  | Persistent volume access modes      | `[ReadWriteMany]`                      |
| `persistentVolume.existingClaim`| Persistent volume existingClaim name| `[]`                                   |
| `persistentVolume.annotations`  | Persistent volume annotations       | `{}`                                   |
| `resources`                | CPU/Memory resource requests/limits | Memory: `128Mi`, CPU: `100m`           |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

## Persistence

The [sftp image](https://github.com/ygqygq2/sftp) stores the data and configurations at the `/home` path of the container.

