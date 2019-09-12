# ceph-exporter - Multiple tracker, Multiple storage

[ceph-exporter](https://github.com/digitalocean/ceph_exporter/)是什么

## Introduction

This chart bootstraps ceph-exporter deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.6+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install --name my-release local/ceph-exporter
```

The command deploys ceph-exporter cluster on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

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
| `service`                  | Service type, protocol, port        | `ClusterIP` `TCP` 9128                 |
| `image`                    | `ceph-exporter` image, tag.             | `digitalocean/ceph_exporter` `latest`|
| `ingress`                  | Ingress for the ceph-exporter.          | `false`                            |
| `resources`                | CPU/Memory resource requests/limits | Memory: `128Mi`, CPU: `100m`           |
| `serviceMonitor.enabled`   | ceph exporter metrics               | `false`
| `serviceMonitor.exporterPort`| ceph exporter port                | 9128
| `serviceMonitor.endpoints` | ceph exporter server ip             | `[]`
| `serviceMonitor.scheme`   | ceph exporter scheme http            | `http`
| `serviceMonitor.serviceSelectorLabelKey`| ceph exporter service selector label key| `app`                 |
| `serviceMonitor.prometheusRules`| prometheusRules                | `{}`                                   |
| `serviceMonitor.additionalServiceMonitorLabels`| one of prometheus operator label| `release: prometheus-operator`|
| `serviceMonitor.additionalRulesLabels`| one of prometheus operator label| `release: prometheus-operator`  |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,


