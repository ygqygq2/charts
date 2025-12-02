<!--- app-name: alibaba-sentinel -->

# Alibaba Sentinel

[Alibaba Sentinel](https://sentinelguard.io/) 是面向分布式、多语言异构化服务架构的流量治理组件，主要以流量为切入点，从流量路由、流量控制、流量整形、熔断降级、系统自适应过载保护、热点流量防护等多个维度来帮助开发者保障微服务的稳定性。

## TL;DR

```bash
$ helm repo add ygqygq2 https://ygqygq2.github.io/charts/
$ helm install my-release ygqygq2/alibaba-sentinel
```

## Introduction

此 Chart 用于在 [Kubernetes](https://kubernetes.io) 集群上使用 [Helm](https://helm.sh) 包管理器部署 Alibaba Sentinel Dashboard。

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add ygqygq2 https://ygqygq2.github.io/charts/
$ helm install my-release ygqygq2/alibaba-sentinel
```

These commands deploy Alibaba Sentinel Dashboard on the Kubernetes cluster in the default configuration.

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
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |


### Common parameters

| Name                | Description                                                                           | Value           |
| ------------------- | ------------------------------------------------------------------------------------- | --------------- |
| `nameOverride`      | String to partially override fullname template (will maintain the release name)       | `""`            |
| `fullnameOverride`  | String to fully override fullname template                                            | `""`            |
| `namespaceOverride` | String to fully override common.names.namespace                                       | `""`            |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set)                  | `""`            |
| `clusterDomain`     | Kubernetes Cluster Domain                                                             | `cluster.local` |
| `extraDeploy`       | Extra objects to deploy (value evaluated as a template)                               | `[]`            |
| `commonLabels`      | Add labels to all the deployed resources                                              | `{}`            |
| `commonAnnotations` | Add annotations to all the deployed resources                                         | `{}`            |


### Alibaba Sentinel parameters

| Name                 | Description                                                                                           | Value                                      |
| -------------------- | ----------------------------------------------------------------------------------------------------- | ------------------------------------------ |
| `image.registry`     | Alibaba Sentinel image registry                                                                       | `ghcr.io`                                  |
| `image.repository`   | Alibaba Sentinel image repository                                                                     | `docker-autodevops/alibaba-sentinel`       |
| `image.tag`          | Alibaba Sentinel image tag (immutable tags are recommended)                                           | `1.8.9`                                    |
| `image.digest`       | Image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag       | `""`                                       |
| `image.pullPolicy`   | Alibaba Sentinel image pull policy                                                                    | `IfNotPresent`                             |
| `image.pullSecrets`  | Specify docker-registry secret names as an array                                                      | `[]`                                       |
| `hostAliases`        | Deployment pod host aliases                                                                           | `[]`                                       |
| `command`            | Override default container command (useful when using custom images)                                  | `[]`                                       |
| `args`               | Override default container args (useful when using custom images)                                     | `[]`                                       |
| `extraEnvVars`       | Extra environment variables to be set on Alibaba Sentinel containers                                  | `[]`                                       |
| `extraEnvVarsCM`     | Name of existing ConfigMap containing extra environment variables                                     | `""`                                       |
| `extraEnvVarsSecret` | Name of existing Secret containing extra environment variables                                        | `""`                                       |


### Alibaba Sentinel deployment parameters

| Name                                    | Description                                                                               | Value   |
| --------------------------------------- | ----------------------------------------------------------------------------------------- | ------- |
| `replicaCount`                          | Number of Alibaba Sentinel replicas to deploy                                             | `1`     |
| `statefulset.enabled`                   | Use StatefulSet instead of Deployment                                                     | `false` |
| `podLabels`                             | Additional labels for Alibaba Sentinel pods                                               | `{}`    |
| `podAnnotations`                        | Annotations for Alibaba Sentinel pods                                                     | `{}`    |
| `podAffinityPreset`                     | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`    |
| `podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`  |
| `nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`    |
| `nodeAffinityPreset.key`                | Node label key to match. Ignored if `affinity` is set.                                    | `""`    |
| `nodeAffinityPreset.values`             | Node label values to match. Ignored if `affinity` is set.                                 | `[]`    |
| `affinity`                              | Affinity for pod assignment                                                               | `{}`    |
| `hostNetwork`                           | Specify if host network should be enabled for pod                                         | `false` |
| `hostIPC`                               | Specify if host IPC should be enabled for pod                                             | `false` |
| `nodeSelector`                          | Node labels for pod assignment. Evaluated as a template.                                  | `{}`    |
| `tolerations`                           | Tolerations for pod assignment. Evaluated as a template.                                  | `[]`    |
| `priorityClassName`                     | Priority class name                                                                       | `""`    |
| `podSecurityContext.enabled`            | Enabled Alibaba Sentinel pods' Security Context                                           | `false` |
| `podSecurityContext.fsGroup`            | Set Alibaba Sentinel pod's Security Context fsGroup                                       | `1001`  |
| `podSecurityContext.sysctls`            | sysctl settings of the Alibaba Sentinel pods                                              | `[]`    |
| `containerSecurityContext.enabled`      | Enabled Alibaba Sentinel containers' Security Context                                     | `false` |
| `containerSecurityContext.runAsUser`    | Set Alibaba Sentinel container's Security Context runAsUser                               | `1001`  |
| `containerSecurityContext.runAsNonRoot` | Set Alibaba Sentinel container's Security Context runAsNonRoot                            | `true`  |
| `resources.limits`                      | The resources limits for the Alibaba Sentinel container                                   | `{}`    |
| `resources.requests`                    | The requested resources for the Alibaba Sentinel container                                | `{}`    |
| `customLivenessProbe`                   | Override default liveness probe                                                           | `{}`    |
| `customReadinessProbe`                  | Override default readiness probe                                                          | `{}`    |
| `customStartupProbe`                    | Override default startup probe                                                            | `{}`    |
| `healthCheck`                           | 简化的健康检测，支持 tcp、http，具体查看 `values.yaml`                                    |         |
| `autoscaling.vpa.enabled`               | Enable VPA                                                                                | `false` |
| `autoscaling.hpa.enabled`               | Enable HPA                                                                                | `false` |
| `autoscaling.hpa.minReplicas`           | Minimum number of replicas to scale back                                                  | `""`    |
| `autoscaling.hpa.maxReplicas`           | Maximum number of replicas to scale out                                                   | `""`    |
| `autoscaling.hpa.targetCPU`             | Target CPU utilization percentage                                                         | `""`    |
| `autoscaling.hpa.targetMemory`          | Target Memory utilization percentage                                                      | `""`    |
| `extraVolumes`                          | Array to add extra volumes                                                                | `[]`    |
| `extraVolumeMounts`                     | Array to add extra mount                                                                  | `[]`    |
| `serviceAccount.create`                 | Enable creation of ServiceAccount for pod                                                 | `false` |
| `serviceAccount.name`                   | The name of the ServiceAccount to use.                                                    | `""`    |
| `serviceAccount.annotations`            | Annotations for service account. Evaluated as a template.                                 | `{}`    |
| `serviceAccount.automountServiceAccountToken` | Auto-mount the service account token in the pod                                     | `false` |
| `sidecars`                              | Sidecar parameters                                                                        | `[]`    |
| `sidecarSingleProcessNamespace`         | Enable sharing the process namespace with sidecars                                        | `false` |
| `initContainers`                        | Extra init containers                                                                     | `[]`    |
| `pdb.create`                            | Created a PodDisruptionBudget                                                             | `false` |
| `pdb.minAvailable`                      | Min number of pods that must still be available after the eviction                        | `1`     |
| `pdb.maxUnavailable`                    | Max number of pods that can be unavailable after the eviction                             | `0`     |


### Traffic Exposure parameters

| Name                            | Description                                                                                                                      | Value                    |
| ------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                  | Service type                                                                                                                     | `ClusterIP`              |
| `service.ports`                 | Service ports                                                                                                                    | see values.yaml          |
| `service.loadBalancerIP`        | LoadBalancer service IP address                                                                                                  | `""`                     |
| `service.sessionAffinity`       | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                             | `None`                   |
| `service.sessionAffinityConfig` | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `service.annotations`           | Service annotations                                                                                                              | `{}`                     |
| `service.externalTrafficPolicy` | Enable client source IP preservation                                                                                             | `Cluster`                |
| `ingress.enabled`               | Set to true to enable ingress record generation                                                                                  | `false`                  |
| `ingress.pathType`              | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`            | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.ingressClassName`      | IngressClass that will be used to implement the Ingress                                                                          | `""`                     |
| `ingress.hostname`              | Default host for the ingress resource                                                                                            | `chart-example.local`    |
| `ingress.path`                  | The Path to Alibaba Sentinel. You may need to set this to '/*' in order to use this with ALB ingress controllers.                | `/`                      |
| `ingress.annotations`           | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                   | Enable TLS configuration                                                                                                         | `false`                  |
| `ingress.extraHosts`            | The list of additional hostnames to be covered with this ingress record.                                                         | `[]`                     |
| `ingress.extraPaths`            | Any additional arbitrary paths that may need to be added to the ingress under the main host.                                     | `[]`                     |
| `ingress.extraTls`              | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`               | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                     |


### Persistence parameters

| Name                        | Description                                                   | Value               |
| --------------------------- | ------------------------------------------------------------- | ------------------- |
| `persistence.enabled`       | Enable persistence using Persistent Volume Claims             | `false`             |
| `persistence.existingClaim` | Name of an existing PVC to use                                | `""`                |
| `persistence.mountPaths`    | Mount paths for the persistent volume                         | see values.yaml     |
| `persistence.storageClass`  | Storage class of backing PVC                                  | `""`                |
| `persistence.accessModes`   | Persistent Volume Access Modes                                | `["ReadWriteOnce"]` |
| `persistence.size`          | Size of data volume                                           | `8Gi`               |


### Metrics parameters

| Name                                       | Description                                                                                                                               | Value                    |
| ------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `metrics.enabled`                          | Start a Prometheus exporter sidecar container                                                                                             | `false`                  |
| `metrics.port`                             | Container Status Port scraped by Prometheus Exporter                                                                                      | `""`                     |
| `metrics.image.registry`                   | Prometheus exporter image registry                                                                                                        | `docker.io`              |
| `metrics.image.repository`                 | Prometheus exporter image repository                                                                                                      | `bitnami/nginx-exporter` |
| `metrics.image.tag`                        | Prometheus exporter image tag (immutable tags are recommended)                                                                            | `latest`                 |
| `metrics.image.pullPolicy`                 | Prometheus exporter image pull policy                                                                                                     | `IfNotPresent`           |
| `metrics.image.pullSecrets`                | Specify docker-registry secret names as an array                                                                                          | `[]`                     |
| `metrics.podAnnotations`                   | Additional annotations for Prometheus exporter pod(s)                                                                                     | `{}`                     |
| `metrics.securityContext.enabled`          | Enabled Exporter containers' Security Context                                                                                             | `false`                  |
| `metrics.securityContext.runAsUser`        | Set Exporter container's Security Context runAsUser                                                                                       | `1001`                   |
| `metrics.service.port`                     | Prometheus exporter service port                                                                                                          | `9113`                   |
| `metrics.service.annotations`              | Annotations for the Prometheus exporter service                                                                                           | `{}`                     |
| `metrics.resources.limits`                 | The resources limits for the Prometheus exporter container                                                                                | `{}`                     |
| `metrics.resources.requests`               | The requested resources for the Prometheus exporter container                                                                             | `{}`                     |
| `metrics.serviceMonitor.enabled`           | Creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)                                               | `false`                  |
| `metrics.serviceMonitor.namespace`         | Namespace in which Prometheus is running                                                                                                  | `""`                     |
| `metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped.                                                                                              | `30s`                    |
| `metrics.serviceMonitor.scrapeTimeout`     | Timeout after which the scrape is ended                                                                                                   | `""`                     |
| `metrics.prometheusRule.enabled`           | if `true`, creates a Prometheus Operator PrometheusRule (also requires `metrics.enabled` to be `true` and `metrics.prometheusRule.rules`) | `false`                  |
| `metrics.prometheusRule.namespace`         | Namespace for the PrometheusRule Resource (defaults to the Release Namespace)                                                             | `""`                     |
| `metrics.prometheusRule.additionalLabels`  | Additional labels that can be used so PrometheusRule will be discovered by Prometheus                                                     | `{}`                     |
| `metrics.prometheusRule.rules`             | Prometheus Rule definitions                                                                                                               | `[]`                     |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install my-release \
  --set replicaCount=2 \
    ygqygq2/alibaba-sentinel
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml ygqygq2/alibaba-sentinel
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### Adding extra environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: error
```

Alternatively, define a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Use Sidecars and Init Containers

If additional containers are needed in the same pod (such as additional metrics or logging exporters), they can be defined using the `sidecars` config parameter. Similarly, extra init containers can be added using the `initContainers` parameter.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinity) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

Persistent Volume Claims (PVCs) are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.

See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

### Ingress

This chart provides support for ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/master/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/master/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable ingress integration, please set `ingress.enabled` to `true`.

#### Hosts

Most likely you will only want to have one hostname that maps to this alibaba-sentinel installation. If that's your case, the property `ingress.hostname` will set it. However, it is possible to have more than one host. To facilitate this, the `ingress.extraHosts` object can be specified as an array. You can also use `ingress.extraTLS` to add the TLS configuration for extra hosts.

For each host indicated at `ingress.extraHosts`, please indicate a `name`, `path`, and any `annotations` that you may want the ingress controller to know about.
