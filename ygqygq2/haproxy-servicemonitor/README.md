# haproxy-servicemonitor - Prometheus Operator with haproxy exporter servicemonitor

[haproxy-servicemonitor](https://)是Prometheus Operator监控haproxy exporter的charts

## Introduction

This chart bootstraps prometheus servicemonitor on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.6+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm install my-release ./haproxy-servicemonitor
```

The command deploys ceph-exporter cluster on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

### Uninstall

To uninstall/delete the `my-release` deployment:

```bash
$ helm uninstall my-release
```

## Configuration

The following table lists the configurable parameters of the chart and their default values.

| Parameter                  | Description                         | Default                                |
| -----------------------    | ----------------------------------- | -------------------------------------- |
| `namespaceSelector`        | service monitor deploy namespace    | `monitoring`                           |
| `endpoints`                | node exporter addresses             | `[]`                                   |
| `metricsPortName`          | metrics port name                   | `metrics`                              |
| `metricsPort  `            | exporter metrics port               | `9101`                                 |
| `scheme`                   | metrics web scheme                  | `http`                                 |
| `prometheusRule`           | prometheusRule                      | see in `values.yaml`                   |                              
| `additionalServiceMonitorLabels`| one of prometheus operator label| `release: prometheus-operator`        |
| `additionalRulesLabels`    | one of prometheus operator label    | `release: prometheus-operator`         |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. 


