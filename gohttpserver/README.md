# gohttpserver - Multiple tracker, Multiple storage

[gohttpserver](https://github.com/codeskyblue/gohttpserver)是什么

## Introduction

This chart bootstraps gohttpserver deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.6+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release local/gohttpserver
```

The command deploys gohttpserver cluster on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

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
| `service`                  | Service type, protocol, port        | `ClusterIP` `TCP` 8000                 |
| `auth.type`                | type of gohttpserver auth           | `http`                                 |
| `auth.userName`            | user name of gohttpserver auth      | `admin`                                |
| `auth.passWord`            | password of gohttpserver auth       | `admin`                                |
| `auth.upload`              | enable upload support               | `true`                                 |
| `auth.delete`              | enable delete support               | `true`                                 |
| `image`                    | `gohttpserver` image, tag.          | `codeskyblue/gohttpserver` `latest`    |
| `ingress`                  | Ingress for the gohttpserver.       | `false`                                |
| `persistentVolume.enabled` | Create a volume to store data       | `false`                                |
| `persistence.storageClass` | Type of persistent volume claim     | `nil`                                  |
| `persistence.accessModes`  | Persistent volume access modes      | `[ReadWriteMany]`                      |
| `persistence.existingClaim`| Persistent volume existingClaim name| `[]`                                   |
| `persistence.annotations`  | Persistent volume annotations       | `{}`                                   |
| `resources`                | CPU/Memory resource requests/limits | Memory: `128Mi`, CPU: `100m`           |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

## Persistence

The [gohttpserver image](https://hub.docker.com/r/mllu/gohttpserver/tags/) stores the data and configurations at the `/app/public` path of the container.

