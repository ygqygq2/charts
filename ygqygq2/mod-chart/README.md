<!--- app-name: mod-chart -->

# mod-chart

[mod-chart](https://nginx.org) (pronounced "engine-x") is an open source reverse proxy server for HTTP, HTTPS, SMTP, POP3, and IMAP protocols, as well as a load balancer, HTTP cache, and a web server (origin server).

## TL;DR

```bash
$ helm repo add ygqygq2 https://ygqygq2.github.io/charts/
$ helm install my-release ygqygq2/mod-chart
```

## Introduction

mod-chart 参考 Bitnami 作为一个通用模板，可用于新 chart 的快速制作，仅需将 app-name 名字替换下即可。

This chart bootstraps a [mod-chart Open Source](https://github.com/bitnami/bitnami-docker-nginx) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add ygqygq2 https://ygqygq2.github.io/charts/
$ helm install my-release ygqygq2/mod-chart
```

These commands deploy mod-chart Open Source on the Kubernetes cluster in the default configuration.

> **Tip**: List all releases using `helm list`

## Usage Examples

### Using Gateway API (Recommended)

Gateway API is the next-generation Kubernetes ingress standard with more features than traditional Ingress.

#### Prerequisites

1. **Install Gateway API CRDs** (Standard version):

```bash
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.4.1/standard-install.yaml
```

2. **Install a Gateway Implementation** (choose one):

- **Envoy Gateway** (Official reference implementation):

```bash
helm repo add envoy-gateway https://gateway.envoyproxy.io
helm install eg envoy-gateway/gateway-helm \
  --namespace envoy-gateway-system \
  --create-namespace
```

- **Or Istio, Cilium, Kong, Traefik, etc.**

3. **Create a Gateway Resource**:

For HTTP only:

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: my-gateway
  namespace: default
spec:
  gatewayClassName: eg # Match your Gateway implementation
  listeners:
    - name: http
      protocol: HTTP
      port: 80
```

For HTTP + HTTPS:

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: my-gateway
  namespace: default
spec:
  gatewayClassName: eg
  listeners:
    - name: http
      protocol: HTTP
      port: 80
    - name: https
      protocol: HTTPS
      port: 443
      tls:
        mode: Terminate
        certificateRefs:
          - kind: Secret
            name: my-tls-cert # TLS certificate secret
```

Apply the Gateway:

```bash
kubectl apply -f gateway.yaml
```

#### Example 1: Simple HTTP Routing

```yaml
gateway:
  enabled: true
  gatewayClassName: my-gateway
  namespace: default
  http:
    enabled: true
    hostnames:
      - myapp.example.com
    rules:
      - matches:
          - path:
              type: PathPrefix
              value: /
        backendRefs:
          - name: "" # Auto-filled with service name
            port: 80
```

Deploy:

```bash
helm install myapp ygqygq2/mod-chart -f values.yaml
```

#### Example 2: HTTPS with TLS Certificate (Most Common)

**Step 1**: Create TLS certificate secret (choose one method):

**Method A - Using cert-manager (Automatic - Recommended)**:

cert-manager v1.5+ 原生支持 Gateway API，可以像 Ingress 一样通过 annotation 自动管理证书。

前提：已安装 cert-manager 和配置好 ClusterIssuer（如 `letsencrypt-prod`）。

**Method B - Using existing certificate (Manual)**:

```bash
# Create secret from your certificate files
kubectl create secret tls myapp-tls-cert \
  --cert=path/to/tls.crt \
  --key=path/to/tls.key \
  -n default
```

**Step 2**: Create Gateway with cert-manager annotation (自动创建证书):

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: my-gateway
  namespace: default
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod # 自动管理证书
spec:
  gatewayClassName: eg
  listeners:
    - name: http
      protocol: HTTP
      port: 80
    - name: https
      protocol: HTTPS
      port: 443
      hostname: myapp.example.com # 必须指定域名
      tls:
        mode: Terminate
        certificateRefs:
          - kind: Secret
            name: myapp-tls-cert # cert-manager 会自动创建这个 Secret
```

cert-manager 会自动：

- 为 Gateway 的 HTTPS listener 创建 Certificate 资源
- 申请 Let's Encrypt 证书
- 创建 `myapp-tls-cert` Secret
- 自动续期证书

**Step 3**: Deploy with HTTPRoute that uses HTTPS:

```yaml
gateway:
  enabled: true
  gatewayClassName: my-gateway
  namespace: default
  http:
    enabled: true
    hostnames:
      - myapp.example.com
    rules:
      - matches:
          - path:
              type: PathPrefix
              value: /
        backendRefs:
          - name: ""
            port: 80
```

Deploy:

```bash
kubectl apply -f gateway.yaml
helm install myapp ygqygq2/mod-chart -f values.yaml
```

Access via HTTPS:

```bash
curl https://myapp.example.com
```

**Note**: The HTTPRoute automatically works for both HTTP (port 80) and HTTPS (port 443) listeners in the Gateway.

#### Example 3: HTTPS with HTTP to HTTPS Redirect (Production Best Practice)

Automatically redirect all HTTP traffic to HTTPS:

```yaml
gateway:
  enabled: true
  gatewayClassName: my-gateway
  namespace: default
  http:
    enabled: true
    hostnames:
      - myapp.example.com
    rules:
      # Rule 1: Redirect HTTP to HTTPS
      - matches:
          - path:
              type: PathPrefix
              value: /
        filters:
          - type: RequestRedirect
            requestRedirect:
              scheme: https
              port: 443
              statusCode: 301 # Permanent redirect
```

Create a second HTTPRoute for HTTPS traffic (or use a separate chart release):

```bash
# Create a separate values file for HTTPS route
cat > values-https.yaml <<EOF
gateway:
  enabled: true
  gatewayClassName: my-gateway
  namespace: default
  http:
    enabled: true
    hostnames:
      - myapp.example.com
    rules:
      - matches:
          - path:
              type: PathPrefix
              value: /
        backendRefs:
          - name: myapp  # Reference the main service
            port: 80
EOF

# Install HTTP redirect route
helm install myapp-redirect ygqygq2/mod-chart -f values.yaml

# Install HTTPS route
helm install myapp ygqygq2/mod-chart -f values-https.yaml
```

**Or use a combined configuration**:

```yaml
gateway:
  enabled: true
  gatewayClassName: my-gateway
  namespace: default
  http:
    enabled: true
    hostnames:
      - myapp.example.com
    rules:
      # Serve both HTTP and HTTPS (Gateway handles redirect if configured)
      - matches:
          - path:
              type: PathPrefix
              value: /
        backendRefs:
          - name: ""
            port: 80
```

Then configure redirect at Gateway level using Gateway implementation-specific annotations.

#### Example 4: Canary Deployment (Traffic Splitting)

Route 90% traffic to stable version, 10% to canary:

```yaml
gateway:
  enabled: true
  gatewayClassName: my-gateway
  http:
    enabled: true
    hostnames:
      - myapp.example.com
    rules:
      - matches:
          - path:
              type: PathPrefix
              value: /
        backendRefs:
          - name: "" # Stable version
            port: 80
            weight: 90
          - name: myapp-canary # Canary version
            port: 80
            weight: 10
```

#### Example 3: HTTP to HTTPS Redirect

```yaml
gateway:
  enabled: true
  gatewayClassName: my-gateway
  http:
    enabled: true
    hostnames:
      - myapp.example.com
    rules:
      - matches:
          - path:
              type: PathPrefix
              value: /
        filters:
          - type: RequestRedirect
            requestRedirect:
              scheme: https
              port: 443
              statusCode: 301
```

#### Example 5: Header-Based Routing

Route API v1 and v2 to different backends:

```yaml
gateway:
  enabled: true
  gatewayClassName: my-gateway
  http:
    enabled: true
    hostnames:
      - api.example.com
    rules:
      # API v1
      - matches:
          - path:
              type: PathPrefix
              value: /api
            headers:
              - type: Exact
                name: X-API-Version
                value: "1.0"
        backendRefs:
          - name: api-v1
            port: 80
      # API v2
      - matches:
          - path:
              type: PathPrefix
              value: /api
            headers:
              - type: Exact
                name: X-API-Version
                value: "2.0"
        backendRefs:
          - name: api-v2
            port: 80
```

#### Example 6: gRPC Service

#### Example 6: gRPC Service

```yaml
gateway:
  enabled: true
  gatewayClassName: my-gateway
  grpc:
    enabled: true
    hostnames:
      - grpc.example.com
    rules:
      - matches:
          - method:
              type: Exact
              service: com.example.UserService
              method: GetUser
        backendRefs:
          - name: ""
            port: 50051
```

### Using Traditional Ingress (Legacy)

#### Example 1: Simple HTTP with NGINX Ingress

```yaml
ingress:
  enabled: true
  ingressClassName: nginx
  hostname: myapp.example.com
  path: /
  pathType: Prefix
```

Deploy:

```bash
helm install myapp ygqygq2/mod-chart -f values.yaml
```

#### Example 2: HTTPS with cert-manager (Most Common)

前提：已安装 cert-manager 和配置好 ClusterIssuer（如 `letsencrypt-prod`）。

Deploy with cert-manager annotations:

```yaml
ingress:
  enabled: true
  ingressClassName: nginx
  hostname: myapp.example.com
  path: /
  pathType: Prefix
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
  tls: true
```

Deploy:

```bash
helm install myapp ygqygq2/mod-chart -f values.yaml
```

cert-manager will automatically create the TLS certificate and the ingress will serve HTTPS traffic.

#### Example 3: HTTPS with existing certificate

**Step 1**: Create TLS secret:

```bash
kubectl create secret tls myapp-tls-cert \
  --cert=path/to/tls.crt \
  --key=path/to/tls.key \
  -n default
```

**Step 2**: Deploy with TLS secret:

```yaml
ingress:
  enabled: true
  ingressClassName: nginx
  hostname: myapp.example.com
  path: /
  pathType: Prefix
  tls: true
  secrets:
    - name: myapp-tls-cert
      certificate: "" # Already created above
      key: ""
```

Deploy:

```bash
helm install myapp ygqygq2/mod-chart -f values.yaml
```

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
| `nameOverride`      | String to partially override nginx.fullname template (will maintain the release name) | `""`            |
| `fullnameOverride`  | String to fully override nginx.fullname template                                      | `""`            |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set)                  | `""`            |
| `clusterDomain`     | Kubernetes Cluster Domain                                                             | `cluster.local` |
| `extraDeploy`       | Extra objects to deploy (value evaluated as a template)                               | `[]`            |
| `commonLabels`      | Add labels to all the deployed resources                                              | `{}`            |
| `commonAnnotations` | Add annotations to all the deployed resources                                         | `{}`            |

### mod-chart parameters

| Name                 | Description                                                                                     | Value           |
| -------------------- | ----------------------------------------------------------------------------------------------- | --------------- |
| `image.registry`     | mod-chart image registry                                                                        | `docker.io`     |
| `image.repository`   | mod-chart image repository                                                                      | `bitnami/nginx` |
| `image.tag`          | mod-chart image tag (immutable tags are recommended)                                            | `latest`        |
| `image.digest`       | Image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`            |
| `image.pullPolicy`   | mod-chart image pull policy                                                                     | `IfNotPresent`  |
| `image.pullSecrets`  | Specify docker-registry secret names as an array                                                | `[]`            |
| `image.debug`        | Set to true if you would like to see extra information on logs                                  | `false`         |
| `hostAliases`        | Deployment pod host aliases                                                                     | `[]`            |
| `command`            | Override default container command (useful when using custom images)                            | `[]`            |
| `args`               | Override default container args (useful when using custom images)                               | `[]`            |
| `extraEnvVars`       | Extra environment variables to be set on mod-chart containers                                   | `[]`            |
| `extraEnvVarsCM`     | Name of existing ConfigMap containing extra environment variables                               | `""`            |
| `extraEnvVarsSecret` | Name of existing Secret containing extra environment variables                                  | `""`            |

### mod-chart deployment parameters

| Name                                    | Description                                                                               | Value   |
| --------------------------------------- | ----------------------------------------------------------------------------------------- | ------- |
| `replicaCount`                          | Number of mod-chart replicas to deploy                                                    | `1`     |
| `podLabels`                             | Additional labels for mod-chart pods                                                      | `{}`    |
| `podAnnotations`                        | Annotations for mod-chart pods                                                            | `{}`    |
| `podAffinityPreset`                     | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`    |
| `podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`  |
| `nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`    |
| `nodeAffinityPreset.key`                | Node label key to match. Ignored if `affinity` is set.                                    | `""`    |
| `nodeAffinityPreset.values`             | Node label values to match. Ignored if `affinity` is set.                                 | `[]`    |
| `affinity`                              | Affinity for pod assignment                                                               | `{}`    |
| `hostNetwork`                           | Specify if host network should be enabled for NGINX pod                                   | `false` |
| `hostIPC`                               | Specify if host IPC should be enabled for NGINX pod                                       | `false` |
| `nodeSelector`                          | Node labels for pod assignment. Evaluated as a template.                                  | `{}`    |
| `tolerations`                           | Tolerations for pod assignment. Evaluated as a template.                                  | `{}`    |
| `priorityClassName`                     | Priority class name                                                                       | `""`    |
| `podSecurityContext.enabled`            | Enabled mod-chart pods' Security Context                                                  | `false` |
| `podSecurityContext.fsGroup`            | Set mod-chart pod's Security Context fsGroup                                              | `1001`  |
| `podSecurityContext.sysctls`            | sysctl settings of the mod-chart pods                                                     | `[]`    |
| `containerSecurityContext.enabled`      | Enabled mod-chart containers' Security Context                                            | `false` |
| `containerSecurityContext.runAsUser`    | Set mod-chart container's Security Context runAsUser                                      | `1001`  |
| `containerSecurityContext.runAsNonRoot` | Set mod-chart container's Security Context runAsNonRoot                                   | `true`  |
| `containerPorts.http`                   | Sets http port inside mod-chart container                                                 | `8080`  |
| `containerPorts.https`                  | Sets https port inside mod-chart container                                                | `""`    |
| `resources.limits`                      | The resources limits for the mod-chart container                                          | `{}`    |
| `resources.requests`                    | The requested resources for the mod-chart container                                       | `{}`    |
| `customLivenessProbe`                   | Override default liveness probe                                                           | `{}`    |
| `customReadinessProbe`                  | Override default readiness probe                                                          | `{}`    |
| `healthCheck`                           | 简化的健康检测，支持 tcp、http，具体查看 `values.yaml`                                    |         |
| `autoscaling.enabled`                   | Enable autoscaling for mod-chart deployment                                               | `false` |
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

| Name                            | Description                                                          | Value           |
| ------------------------------- | -------------------------------------------------------------------- | --------------- |
| `service.type`                  | Service type                                                         | `LoadBalancer`  |
| `service.ports`                 | Service ports                                                        | see values.yaml |
| `service.loadBalancerIP`        | LoadBalancer service IP address                                      | `""`            |
| `service.sessionAffinity`       | Session Affinity for Kubernetes service, can be "None" or "ClientIP" | `None`          |
| `service.sessionAffinityConfig` | Additional settings for the sessionAffinity                          | `{}`            |
| `service.annotations`           | Service annotations                                                  | `{}`            |
| `service.externalTrafficPolicy` | Enable client source IP preservation                                 | `Cluster`       |

### Gateway API parameters (Recommended)

Gateway API is the next-generation Kubernetes ingress management standard, providing more powerful features than traditional Ingress.

**Prerequisites:**

1. Install Gateway API CRDs (v1.4.1+): `kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.4.1/standard-install.yaml`
2. Install a Gateway implementation (e.g., Envoy Gateway, Istio, etc.)
3. Create a Gateway resource in your cluster

**Quick Start Example:**

```yaml
# 1. Create Gateway resource first
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: my-gateway
  namespace: default
spec:
  gatewayClassName: eg # Your Gateway implementation
  listeners:
    - name: http
      protocol: HTTP
      port: 80
    - name: https
      protocol: HTTPS
      port: 443
      tls:
        mode: Terminate
        certificateRefs:
          - name: my-tls-secret

# 2. Deploy this chart with Gateway enabled
gateway:
  enabled: true
  gatewayClassName: my-gateway # Reference the Gateway created above
  namespace: default
  http:
    enabled: true
    hostnames:
      - example.com
    rules:
      - matches:
          - path:
              type: PathPrefix
              value: /
        backendRefs:
          - name: "" # Auto-filled with current service
            port: 80
```

| Name                       | Description                                               | Value   |
| -------------------------- | --------------------------------------------------------- | ------- |
| `gateway.enabled`          | Enable Gateway API support                                | `false` |
| `gateway.gatewayClassName` | Name of Gateway resource to attach (required if enabled)  | `""`    |
| `gateway.namespace`        | Namespace of Gateway resource (if different from release) | `""`    |
| `gateway.sectionName`      | Specific listener name in Gateway (optional)              | `""`    |
| `gateway.http.enabled`     | Enable HTTPRoute for HTTP/HTTPS traffic                   | `false` |
| `gateway.http.annotations` | Annotations for HTTPRoute resource                        | `{}`    |
| `gateway.http.hostnames`   | List of hostnames for HTTPRoute                           | `[]`    |
| `gateway.http.rules`       | HTTPRoute rules (path matching, filters, backends)        | `[...]` |
| `gateway.grpc.enabled`     | Enable GRPCRoute for gRPC traffic                         | `false` |
| `gateway.grpc.annotations` | Annotations for GRPCRoute resource                        | `{}`    |
| `gateway.grpc.hostnames`   | List of hostnames for GRPCRoute                           | `[]`    |
| `gateway.grpc.rules`       | GRPCRoute rules (method matching, filters, backends)      | `[...]` |
| `gateway.tcp.enabled`      | Enable TCPRoute for raw TCP traffic                       | `false` |
| `gateway.tcp.annotations`  | Annotations for TCPRoute resource                         | `{}`    |
| `gateway.tcp.rules`        | TCPRoute rules (backend services)                         | `[...]` |
| `gateway.tls.enabled`      | Enable TLSRoute for TLS passthrough                       | `false` |
| `gateway.tls.annotations`  | Annotations for TLSRoute resource                         | `{}`    |
| `gateway.tls.hostnames`    | List of SNI hostnames for TLSRoute                        | `[]`    |
| `gateway.tls.rules`        | TLSRoute rules (backend services)                         | `[...]` |

### Ingress parameters (Legacy)

Traditional Ingress support (consider migrating to Gateway API for better features).

| `ingress.enabled` | Set to true to enable ingress record generation | `false` |
| `ingress.pathType` | Ingress path type | `ImplementationSpecific` |
| `ingress.apiVersion` | Force Ingress API version (automatically detected if not set) | `""` |
| `ingress.hostname` | Default host for the ingress resource | `nginx.local` |
| `ingress.path` | The Path to Nginx. You may need to set this to '/\*' in order to use this with ALB ingress controllers. | `/` |
| `ingress.annotations` | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}` |
| `ingress.tls` | Create TLS Secret | `false` |
| `ingress.extraHosts` | The list of additional hostnames to be covered with this ingress record. | `[]` |
| `ingress.extraPaths` | Any additional arbitrary paths that may need to be added to the ingress under the main host. | `[]` |
| `ingress.extraTls` | The tls configuration for additional hostnames to be covered with this ingress record. | `[]` |
| `ingress.secrets` | If you're providing your own certificates, please use this to add the certificates as secrets | `[]` |
| `healthIngress.enabled` | Set to true to enable health ingress record generation | `false` |
| `healthIngress.pathType` | Ingress path type | `ImplementationSpecific` |
| `healthIngress.hostname` | When the health ingress is enabled, a host pointing to this will be created | `example.local` |
| `healthIngress.annotations` | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}` |
| `healthIngress.tls` | Enable TLS configuration for the hostname defined at `healthIngress.hostname` parameter | `false` |
| `healthIngress.extraHosts` | The list of additional hostnames to be covered with this health ingress record | `[]` |
| `healthIngress.extraTls` | TLS configuration for additional hostnames to be covered | `[]` |
| `healthIngress.secrets` | TLS Secret configuration | `[]` |

### Metrics parameters

| Name                                       | Description                                                                                                                               | Value                    |
| ------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `metrics.enabled`                          | Start a Prometheus exporter sidecar container                                                                                             | `false`                  |
| `metrics.port`                             | mod-chart Container Status Port scraped by Prometheus Exporter                                                                            | `""`                     |
| `metrics.image.registry`                   | mod-chart Prometheus exporter image registry                                                                                              | `docker.io`              |
| `metrics.image.repository`                 | mod-chart Prometheus exporter image repository                                                                                            | `bitnami/nginx-exporter` |
| `metrics.image.tag`                        | mod-chart Prometheus exporter image tag (immutable tags are recommended)                                                                  | `0.10.0-debian-10-r8`    |
| `metrics.image.pullPolicy`                 | mod-chart Prometheus exporter image pull policy                                                                                           | `IfNotPresent`           |
| `metrics.image.pullSecrets`                | Specify docker-registry secret names as an array                                                                                          | `[]`                     |
| `metrics.podAnnotations`                   | Additional annotations for mod-chart Prometheus exporter pod(s)                                                                           | `{}`                     |
| `metrics.securityContext.enabled`          | Enabled mod-chart Exporter containers' Security Context                                                                                   | `false`                  |
| `metrics.securityContext.runAsUser`        | Set mod-chart Exporter container's Security Context runAsUser                                                                             | `1001`                   |
| `metrics.service.port`                     | mod-chart Prometheus exporter service port                                                                                                | `9113`                   |
| `metrics.service.annotations`              | Annotations for the Prometheus exporter service                                                                                           | `{}`                     |
| `metrics.resources.limits`                 | The resources limits for the mod-chart Prometheus exporter container                                                                      | `{}`                     |
| `metrics.resources.requests`               | The requested resources for the mod-chart Prometheus exporter container                                                                   | `{}`                     |
| `metrics.serviceMonitor.enabled`           | Creates a Prometheus Operator ServiceMonitor (also requires `metrics.enabled` to be `true`)                                               | `false`                  |
| `metrics.serviceMonitor.namespace`         | Namespace in which Prometheus is running                                                                                                  | `""`                     |
| `metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in prometheus.                                                         | `""`                     |
| `metrics.serviceMonitor.interval`          | Interval at which metrics should be scraped.                                                                                              | `""`                     |
| `metrics.serviceMonitor.scrapeTimeout`     | Timeout after which the scrape is ended                                                                                                   | `""`                     |
| `metrics.serviceMonitor.selector`          | Prometheus instance selector labels                                                                                                       | `{}`                     |
| `metrics.serviceMonitor.labels`            | Additional labels that can be used so PodMonitor will be discovered by Prometheus                                                         | `{}`                     |
| `metrics.serviceMonitor.relabelings`       | RelabelConfigs to apply to samples before scraping                                                                                        | `[]`                     |
| `metrics.serviceMonitor.metricRelabelings` | MetricRelabelConfigs to apply to samples before ingestion                                                                                 | `[]`                     |
| `metrics.prometheusRule.enabled`           | if `true`, creates a Prometheus Operator PrometheusRule (also requires `metrics.enabled` to be `true` and `metrics.prometheusRule.rules`) | `false`                  |
| `metrics.prometheusRule.namespace`         | Namespace for the PrometheusRule Resource (defaults to the Release Namespace)                                                             | `""`                     |
| `metrics.prometheusRule.additionalLabels`  | Additional labels that can be used so PrometheusRule will be discovered by Prometheus                                                     | `{}`                     |
| `metrics.prometheusRule.rules`             | Prometheus Rule definitions                                                                                                               | `[]`                     |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
$ helm install my-release \
  --set replicaCount=2 \
    ygqygq2/mod-chart
```

The above command sets the `imagePullPolicy` to `Always`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install my-release -f values.yaml ygqygq2/mod-chart
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

Bitnami will release a new chart updating its containers if a new version of the main container, significant changes, or critical vulnerabilities exist.

### Use a different mod-chart version

To modify the application version used in this chart, specify a different version of the image using the `image.tag` parameter and/or a different repository using the `image.repository` parameter. Refer to the [chart documentation for more information on these parameters and how to use them with images from a private registry](https://docs.bitnami.com/kubernetes/infrastructure/nginx/configuration/change-image-version/).

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

Refer to the chart documentation for more information on, and examples of, configuring and using [sidecars and init containers](https://docs.bitnami.com/kubernetes/infrastructure/tomcat/configuration/configure-sidecar-init-containers/).

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, you can use of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinity) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Persistence

The [Bitnami Tomcat](https://github.com/bitnami/containers/tree/main/bitnami/tomcat) image stores the Tomcat data and configurations at the `/bitnami/tomcat` path of the container.

Persistent Volume Claims (PVCs) are used to keep the data across deployments. This is known to work in GCE, AWS, and minikube.

See the [Parameters](#parameters) section to configure the PVC or to disable persistence.

### Adjust permissions of persistent volume mountpoint

As the image run as non-root by default, it is necessary to adjust the ownership of the persistent volume so that the container can write data into it.

By default, the chart is configured to use Kubernetes Security Context to automatically change the ownership of the volume. However, this feature does not work in all Kubernetes distributions.
As an alternative, this chart supports using an init container to change the ownership of the volume before mounting it in the final destination.

You can enable this init container by setting `volumePermissions.enabled` to `true`.

### Deploying extra resources

There are cases where you may want to deploy extra objects, such a ConfigMap containing your app's configuration or some extra deployment with a micro service used by your app. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

### Ingress

This chart provides support for ingress resources. If you have an ingress controller installed on your cluster, such as [nginx-ingress-controller](https://github.com/bitnami/charts/tree/master/bitnami/nginx-ingress-controller) or [contour](https://github.com/bitnami/charts/tree/master/bitnami/contour) you can utilize the ingress controller to serve your application.

To enable ingress integration, please set `ingress.enabled` to `true`.

#### Hosts

Most likely you will only want to have one hostname that maps to this mod-chart installation. If that's your case, the property `ingress.hostname` will set it. However, it is possible to have more than one host. To facilitate this, the `ingress.extraHosts` object can be specified as an array. You can also use `ingress.extraTLS` to add the TLS configuration for extra hosts.

For each host indicated at `ingress.extraHosts`, please indicate a `name`, `path`, and any `annotations` that you may want the ingress controller to know about.

For annotations, please see [this document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/user-guide/nginx-configuration/annotations.md). Not all annotations are supported by all ingress controllers, but this document does a good job of indicating which annotation is supported by many popular ingress controllers.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).
