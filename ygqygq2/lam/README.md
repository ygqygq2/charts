# lam - ldap-account-manager

[lam](https://www.ldap-account-manager.org/lamcms/releases)LDAP Account Manager (LAM) is a webfrontend for managing entries (e.g. users, groups, DHCP settings) stored in an LDAP directory.

## Introduction

This chart bootstraps lam deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.6+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install my-release lam
```

The command deploys lam cluster on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

### Uninstall

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

## Configuration

The following table lists the configurable parameters of the lam chart and their default values.

| Parameter                  | Description                         | Default                                |
| -----------------------    | ----------------------------------- | -------------------------------------- |
| `statefulset.enabled`      | Use statefulset to start            | `false`                                |
| `global`                   | Global setting                      | see in values.yaml                     |
| `deploymentStrategy`       | Deployment rollingUpdate setting    | `{}`                                   |
| `replicaCount`             | Replicas number                     | `1`                                    |
| `service`                  | Service type, protocol, port        | `ClusterIP` `TCP` 80                   |
| `env`                      | Container env setting               | `[]`                                   |
| `startCommand`             | Start command                       | `[]`                                   |
| `config`                   | Additional configmap to use         | see in `values.yaml`                   |
| `secret`                   | Additional secret to use            | see in `values.yaml`                   |
| `image`                    | `lam` image, tag.                   | `ldapaccountmanager/lam` `6.9`         |
| `ingress`                  | Ingress for the lam.                | `false`                                |
| `persistentVolume.enabled` | Create a volume to store data       | `false`                                |
| `persistentVolume.storageClass` | Type of persistent volume claim| `nil`                                  |
| `persistentVolume.accessModes`  | Persistent volume access modes | `[ReadWriteOnce]`                      |
| `persistentVolume.size`         | Persistent volume access modes | `50Mi`                                 |
| `persistentVolume.existingClaim`| Persistent volume existingClaim name| `{}`                              |
| `persistentVolume.mountPaths`   | Persistent directory path      | see in `values.yaml`                   |
| `persistentVolume.annotations`  | Persistent volume annotations  | `{}`                                   |
| `healthCheck.enabled`      | Liveness and readiness probes       | `true`, detail see in `values.yaml`    |
| `resources`                | CPU/Memory resource requests/limits | `{}`                                   |
| `lifecycle`                | Pod lifecycle                       | `{}`                                   |
| `deployment.additionalVolumes`| Deployment additionalVolumes     | `[]`                                   |
| `additionalContainers`     | Sidecar containers                  | `{}`                                   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```
$ helm install my-release \
  --set statefulset.enabled=true \
    lam
```

The above command sets the `statefulset.enabled` to `true`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```
$ helm install my-release -f values.yaml lam
```

>**Tip**: You can use the default [values.yaml](#values.yaml)

