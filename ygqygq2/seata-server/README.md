# seata-server

[seata-server](https://nginx.org) (pronounced "engine-x") is an open source reverse proxy server for HTTP, HTTPS, SMTP, POP3, and IMAP protocols, as well as a load balancer, HTTP cache, and a web server (origin server).

## TL;DR

```bash
$ helm repo add ygqygq2 https://ygqygq2.github.io/charts/
$ helm install my-release ygqygq2/seata-server
```

## Introduction

seata-server 参考 Bitnami 作为一个通用模板，可用于新 chart 的快速制作，仅需将 app-name 名字替换下即可。

This chart bootstraps a [seata-server Open Source](https://github.com/bitnami/bitnami-docker-nginx) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add ygqygq2 https://ygqygq2.github.io/charts/
$ helm install my-release ygqygq2/seata-server
```

These commands deploy seata-server Open Source on the Kubernetes cluster in the default configuration.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |

### Common parameters

| Name                | Description                                                                           | Value           |
| ------------------- | ------------------------------------------------------------------------------------- | --------------- |
| `nameOverride`      | String to partially override nginx.fullname template (will maintain the release name) | `""`            |
| `fullnameOverride`  | String to fully override nginx.fullname template                                      | `""`            |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set)                  | `""`            |
| `clusterDomain`     | Kubernetes Cluster Domain                                                             | `cluster.local` |
| `extraDeploy`       | Extra objects to deploy (value evaluated as a template)                               | `[]`            |
| `commonLabels`      | Add labels to all the deployed resources                                              | `{}`            |
| `commonAnnotations` | Add annotations to all the deployed resources                                         | `{}`            |

### seata-server parameters

| Name                 | Description                                                          | Value                 |
| -------------------- | -------------------------------------------------------------------- | --------------------- |
| `image.registry`     | seata-server image registry                                                  | `docker.io`           |
| `image.repository`   | seata-server image repository                                                | `bitnami/nginx`       |
| `image.tag`          | seata-server image tag (immutable tags are recommended)                      | `1.21.5-debian-10-r3` |
| `image.pullPolicy`   | seata-server image pull policy                                               | `IfNotPresent`        |
| `image.pullSecrets`  | Specify docker-registry secret names as an array                     | `[]`                  |
| `image.debug`        | Set to true if you would like to see extra information on logs       | `false`               |
| `hostAliases`        | Deployment pod host aliases                                          | `[]`                  |
| `command`            | Override default container command (useful when using custom images) | `[]`                  |
| `args`               | Override default container args (useful when using custom images)    | `[]`                  |
| `extraEnvVars`       | Extra environment variables to be set on seata-server containers             | `[]`                  |
| `extraEnvVarsCM`     | ConfigMap with extra environment variables                           | `""`                  |
| `extraEnvVarsSecret` | Secret with extra environment variables                              | `""`                  |

### seata-server deployment parameters

| Name                                    | Description                                                                               | Value   |
| --------------------------------------- | ----------------------------------------------------------------------------------------- | ------- |
| `replicaCount`                          | Number of seata-server replicas to deploy                                                         | `1`     |
| `podLabels`                             | Additional labels for seata-server pods                                                           | `{}`    |
| `podAnnotations`                        | Annotations for seata-server pods                                                                 | `{}`    |
| `podAffinityPreset`                     | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`    |
| `podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`  |
| `nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`    |
| `nodeAffinityPreset.key`                | Node label key to match Ignored if `affinity` is set.                                     | `""`    |
| `nodeAffinityPreset.values`             | Node label values to match. Ignored if `affinity` is set.                                 | `[]`    |
| `affinity`                              | Affinity for pod assignment                                                               | `{}`    |
| `nodeSelector`                          | Node labels for pod assignment. Evaluated as a template.                                  | `{}`    |
| `tolerations`                           | Tolerations for pod assignment. Evaluated as a template.                                  | `{}`    |
| `priorityClassName`                     | Priority class name                                                                       | `""`    |
| `podSecurityContext.enabled`            | Enabled seata-server pods' Security Context                                                       | `false` |
| `podSecurityContext.fsGroup`            | Set seata-server pod's Security Context fsGroup                                                   | `1001`  |
| `podSecurityContext.sysctls`            | sysctl settings of the seata-server pods                                                          | `[]`    |
| `containerSecurityContext.enabled`      | Enabled seata-server containers' Security Context                                                 | `false` |
| `containerSecurityContext.runAsUser`    | Set seata-server container's Security Context runAsUser                                           | `1001`  |
| `containerSecurityContext.runAsNonRoot` | Set seata-server container's Security Context runAsNonRoot                                        | `true`  |
| `containerPorts.http`                   | Sets http port inside seata-server container                                                      | `8080`  |
| `containerPorts.https`                  | Sets https port inside seata-server container                                                     | `""`    |
| `resources.limits`                      | The resources limits for the seata-server container                                               | `{}`    |
| `resources.requests`                    | The requested resources for the seata-server container                                            | `{}`    |
| `customLivenessProbe`                   | Override default liveness probe                                                           | `{}`    |
| `customReadinessProbe`                  | Override default readiness probe                                                          | `{}`    |
| `healthCheck`                           | 简化的健康检测，支持 tcp、http，具体查看 `values.yaml`                                    |         |
| `lifecycleHooks`                        | for the haproxy container(s) to automate configuration before or after startup            | `{}`    |
| `autoscaling.enabled`                   | Enable autoscaling for seata-server deployment                                                    | `false` |
| `autoscaling.minReplicas`               | Minimum number of replicas to scale back                                                  | `""`    |
| `autoscaling.maxReplicas`               | Maximum number of replicas to scale out                                                   | `""`    |
| `autoscaling.targetCPU`                 | Target CPU utilization percentage                                                         | `""`    |
| `autoscaling.targetMemory`              | Target Memory utilization percentage                                                      | `""`    |
| `extraVolumes`                          | Array to add extra volumes                                                                | `[]`    |
| `extraVolumeMounts`                     | Array to add extra mount                                                                  | `[]`    |
| `serviceAccount.create`                 | Enable creation of ServiceAccount for nginx pod                                           | `false` |
| `serviceAccount.name`                   | The name of the ServiceAccount to use.                                                    | `""`    |
| `serviceAccount.annotations`            | Annotations for service account. Evaluated as a template.                                 | `{}`    |
| `serviceAccount.autoMount`              | Auto-mount the service account token in the pod                                           | `false` |
| `sidecars`                              | Sidecar parameters                                                                        | `[]`    |
| `sidecarSingleProcessNamespace`         | Enable sharing the process namespace with sidecars                                        | `false` |
| `initContainers`                        | Extra init containers                                                                     | `[]`    |
| `pdb.create`                            | Created a PodDisruptionBudget                                                             | `false` |
| `pdb.minAvailable`                      | Min number of pods that must still be available after the eviction                        | `1`     |
| `pdb.maxUnavailable`                    | Max number of pods that can be unavailable after the eviction                             | `0`     |

### Traffic Exposure parameters

| Name                            | Description                                                                                                                      | Value                    |
| ------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                  | Service type                                                                                                                     | `LoadBalancer`           |
| `service.port`                  | Service HTTP port                                                                                                                | `80`                     |
| `service.httpsPort`             | Service HTTPS port                                                                                                               | `443`                    |
| `service.nodePorts`             | Specify the nodePort(s) value(s) for the LoadBalancer and NodePort service types.                                                | `{}`                     |
| `service.targetPort`            | Target port reference value for the Loadbalancer service types can be specified explicitly.                                      | `{}`                     |
| `service.loadBalancerIP`        | LoadBalancer service IP address                                                                                                  | `""`                     |
| `service.annotations`           | Service annotations                                                                                                              | `{}`                     |
| `service.externalTrafficPolicy` | Enable client source IP preservation                                                                                             | `Cluster`                |
| `ingress.enabled`               | Set to true to enable ingress record generation                                                                                  | `false`                  |
| `ingress.pathType`              | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`            | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`              | Default host for the ingress resource                                                                                            | `nginx.local`            |
| `ingress.path`                  | The Path to Nginx. You may need to set this to '/\*' in order to use this with ALB ingress controllers.                          | `/`                      |
| `ingress.annotations`           | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                   | Create TLS Secret                                                                                                                | `false`                  |
| `ingress.extraHosts`            | The list of additional hostnames to be covered with this ingress record.                                                         | `[]`                     |
| `ingress.extraPaths`            | Any additional arbitrary paths that may need to be added to the ingress under the main host.                                     | `[]`                     |
| `ingress.extraTls`              | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`               | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                     |
| `healthIngress.enabled`         | Set to true to enable health ingress record generation                                                                           | `false`                  |
| `healthIngress.pathType`        | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `healthIngress.hostname`        | When the health ingress is enabled, a host pointing to this will be created                                                      | `example.local`          |
| `healthIngress.annotations`     | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `healthIngress.tls`             | Enable TLS configuration for the hostname defined at `healthIngress.hostname` parameter                                          | `false`                  |
| `healthIngress.extraHosts`      | The list of additional hostnames to be covered with this health ingress record                                                   | `[]`                     |
| `healthIngress.extraTls`        | TLS configuration for additional hostnames to be covered                                                                         | `[]`                     |
| `healthIngress.secrets`         | TLS Secret configuration                                                                                                         | `[]`                     |

### Metrics parameters

| Name                                       | Description                                                                                                                               | Value                    |
| ------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `metrics.enabled`                          | Start a Prometheus exporter sidecar container                                                                                             | `false`                  |
| `metrics.port`                             | seata-server Container Status Port scraped by Prometheus Exporter                                                                                 | `""`                     |
| `metrics.image.registry`                   | seata-server Prometheus exporter image registry                                                                                                   | `docker.io`              |
| `metrics.image.repository`                 | seata-server Prometheus exporter image repository                                                                                                 | `bitnami/nginx-exporter` |
| `metrics.image.tag`                        | seata-server Prometheus exporter image tag (immutable tags are recommended)                                                                       | `0.10.0-debian-10-r8`    |
| `metrics.image.pullPolicy`                 | seata-server Prometheus exporter image pull policy                                                                                                | `IfNotPresent`           |
| `metrics.image.pullSecrets`                | Specify docker-registry secret names as an array                                                                                          | `[]`                     |
| `metrics.podAnnotations`                   | Additional annotations for seata-server Prometheus exporter pod(s)                                                                                | `{}`                     |
| `metrics.securityContext.enabled`          | Enabled seata-server Exporter containers' Security Context                                                                                        | `false`                  |
| `metrics.securityContext.runAsUser`        | Set seata-server Exporter container's Security Context runAsUser                                                                                  | `1001`                   |
| `metrics.service.port`                     | seata-server Prometheus exporter service port                                                                                                     | `9113`                   |
| `metrics.service.annotations`              | Annotations for the Prometheus exporter service                                                                                           | `{}`                     |
| `metrics.resources.limits`                 | The resources limits for the seata-server Prometheus exporter container                                                                           | `{}`                     |
| `metrics.resources.requests`               | The requested resources for the seata-server Prometheus exporter container                                                                        | `{}`                     |
| `metrics.serviceMonitor.enabled`           | Creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)                                               | `false`                  |
| `metrics.serviceMonitor.namespace`         | Namespace in which Prometheus is running                                                                                                  | `""`                     |
| `metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped.                                                                                              | `""`                     |
| `metrics.serviceMonitor.scrapeTimeout`     | Timeout after which the scrape is ended                                                                                                   | `""`                     |
| `metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                                                                       | `{}`                     |
| `metrics.serviceMonitor.additionalLabels`  | Additional labels that can be used so PodMonitor will be discovered by Prometheus                                                         | `{}`                     |
| `metrics.serviceMonitor.relabelings`       | RelabelConfigs to apply to samples before scraping                                                                                        | `[]`                     |
| `metrics.serviceMonitor.metricRelabelings` | MetricRelabelConfigs to apply to samples before ingestion                                                                                 | `[]`                     |
| `metrics.prometheusRule.enabled`           | if `true`, creates a Prometheus Operator PrometheusRule (also requires `metrics.enabled` to be `true` and `metrics.prometheusRule.rules`) | `false`                  |
| `metrics.prometheusRule.namespace`         | Namespace for the PrometheusRule Resource (defaults to the Release Namespace)                                                             | `""`                     |
| `metrics.prometheusRule.additionalLabels`  | Additional labels that can be used so PrometheusRule will be discovered by Prometheus                                                     | `{}`                     |
| `metrics.prometheusRule.rules`             | Prometheus Rule definitions                                                                                                               | `[]`                     |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install my-release \
  --set imagePullPolicy=Always \
    ygqygq2/seata-server
```

The above command sets the `imagePullPolicy` to `Always`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml ygqygq2/seata-server
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Use a different seata-server version

To modify the application version used in this chart, specify a different version of the image using the `image.tag` parameter and/or a different repository using the `image.repository` parameter. Refer to the [chart documentation for more information on these parameters and how to use them with images from a private registry](https://docs.bitnami.com/kubernetes/infrastructure/nginx/configuration/change-image-version/).

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinity) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

### Deploying extra resources

There are cases where you may want to deploy extra objects, such a ConfigMap containing your app's configuration or some extra deployment with a micro service used by your app. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

### Ingress

This chart provides support for ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/master/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/master/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable ingress integration, please set `ingress.enabled` to `true`.

#### Hosts

Most likely you will only want to have one hostname that maps to this seata-server installation. If that's your case, the property `ingress.hostname` will set it. However, it is possible to have more than one host. To facilitate this, the `ingress.extraHosts` object can be specified as an array. You can also use `ingress.extraTLS` to add the TLS configuration for extra hosts.

For each host indicated at `ingress.extraHosts`, please indicate a `name`, `path`, and any `annotations` that you may want the ingress controller to know about.

For annotations, please see [this document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md). Not all annotations are supported by all ingress controllers, but this document does a good job of indicating which annotation is supported by many popular ingress controllers.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami’s Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).
