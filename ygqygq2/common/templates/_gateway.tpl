{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Gateway API related template helpers
This file contains helper functions for Gateway API resources:
- HTTPRoute, GRPCRoute, TCPRoute, TLSRoute
- Backend, BackendTrafficPolicy, ClientTrafficPolicy

NOTE: These helpers follow the same patterns as other Bitnami common helpers
for consistency and ease of maintenance.
*/}}

{{/*
Return the HTTPRoute resource name
Usage:
{{ include "common.names.gateway.httproute" . }}
*/}}
{{- define "common.names.gateway.httproute" -}}
{{- include "common.names.fullname" . -}}
{{- end -}}

{{/*
Return the GRPCRoute resource name
Usage:
{{ include "common.names.gateway.grpcroute" . }}
*/}}
{{- define "common.names.gateway.grpcroute" -}}
{{- printf "%s-grpc" (include "common.names.fullname" .) -}}
{{- end -}}

{{/*
Return the TCPRoute resource name
Usage:
{{ include "common.names.gateway.tcproute" . }}
*/}}
{{- define "common.names.gateway.tcproute" -}}
{{- printf "%s-tcp" (include "common.names.fullname" .) -}}
{{- end -}}

{{/*
Return the TLSRoute resource name
Usage:
{{ include "common.names.gateway.tlsroute" . }}
*/}}
{{- define "common.names.gateway.tlsroute" -}}
{{- printf "%s-tls" (include "common.names.fullname" .) -}}
{{- end -}}

{{/*
Return the Backend resource name
Usage:
{{ include "common.names.gateway.backend" . }}
*/}}
{{- define "common.names.gateway.backend" -}}
{{- printf "%s-backend" (include "common.names.fullname" .) -}}
{{- end -}}

{{/*
Return the BackendTrafficPolicy resource name
Usage:
{{ include "common.names.gateway.backendtrafficpolicy" . }}
*/}}
{{- define "common.names.gateway.backendtrafficpolicy" -}}
{{- printf "%s-backend-traffic" (include "common.names.fullname" .) -}}
{{- end -}}

{{/*
Return the ClientTrafficPolicy resource name
Usage:
{{ include "common.names.gateway.clienttrafficpolicy" . }}
*/}}
{{- define "common.names.gateway.clienttrafficpolicy" -}}
{{- printf "%s-client-traffic" (include "common.names.fullname" .) -}}
{{- end -}}

{{/*
Generate parentRefs for Gateway API route resources
This helper creates the standard parentRefs structure used by
HTTPRoute, GRPCRoute, TCPRoute, and TLSRoute.

Parameters:
- gateway (dict): Gateway configuration from values
  - name (string): Gateway resource name to attach to
  - namespace (string, optional): Gateway namespace if different from current
  - sectionName (string, optional): Specific listener section name

Usage:
{{ include "common.gateway.parentRefs" (dict "gateway" .Values.gateway "context" $) }}

Example output:
parentRefs:
  - name: my-gateway
    namespace: envoy-gateway-system
    sectionName: https
*/}}
{{- define "common.gateway.parentRefs" -}}
{{- $gateway := .gateway -}}
{{- if not $gateway.name -}}
  {{- fail "gateway.name is required when Gateway API is enabled" -}}
{{- end -}}
parentRefs:
  - name: {{ $gateway.name }}
    {{- if $gateway.namespace }}
    namespace: {{ $gateway.namespace }}
    {{- end }}
    {{- if $gateway.sectionName }}
    sectionName: {{ $gateway.sectionName }}
    {{- end }}
{{- end -}}

{{/*
Process backendRefs with smart defaults
This helper processes backendRefs array and auto-fills empty name and port values.

Parameters:
- backendRefs (list): Array of backend references
- serviceName (string): Default service name (usually fullname)
- servicePort (int/string): Default service port
- context ($): Chart context for template functions

Usage:
{{ include "common.gateway.processBackendRefs" (dict "backendRefs" .backendRefs "serviceName" $serviceName "servicePort" $servicePort "context" $) }}

Logic:
- If name is empty string "", fill with serviceName
- If port is not specified, fill with servicePort
- Preserve all other fields as-is
*/}}
{{- define "common.gateway.processBackendRefs" -}}
{{- $backendRefs := .backendRefs -}}
{{- $serviceName := .serviceName -}}
{{- $servicePort := .servicePort -}}
{{- $context := .context -}}
{{- range $idx, $ref := $backendRefs -}}
  {{- $processedRef := dict -}}
  {{- /* Process name field */ -}}
  {{- if hasKey $ref "name" -}}
    {{- if eq $ref.name "" -}}
      {{- $_ := set $processedRef "name" $serviceName -}}
    {{- else -}}
      {{- $_ := set $processedRef "name" $ref.name -}}
    {{- end -}}
  {{- else -}}
    {{- $_ := set $processedRef "name" $serviceName -}}
  {{- end -}}
  {{- /* Process port field */ -}}
  {{- if hasKey $ref "port" -}}
    {{- $_ := set $processedRef "port" $ref.port -}}
  {{- else if $servicePort -}}
    {{- $_ := set $processedRef "port" $servicePort -}}
  {{- end -}}
  {{- /* Copy all other fields */ -}}
  {{- range $key, $value := $ref -}}
    {{- if and (ne $key "name") (ne $key "port") -}}
      {{- $_ := set $processedRef $key $value -}}
    {{- end -}}
  {{- end -}}
- {{ $processedRef | toYaml | nindent 2 | trim }}
{{- end -}}
{{- end -}}

{{/*
Render HTTPRoute rules with auto-filled backendRefs
This helper processes HTTPRoute rules array and handles backendRef defaults.

Parameters:
- rules (list): Array of HTTPRoute rules
- serviceName (string): Default service name for backendRefs
- servicePort (int/string): Default service port for backendRefs
- context ($): Chart context

Usage:
{{ include "common.gateway.httproute.rules" (dict "rules" .Values.gateway.http.rules "serviceName" $fullname "servicePort" .Values.service.ports.http.port "context" $) }}
*/}}
{{- define "common.gateway.httproute.rules" -}}
{{- $rules := .rules -}}
{{- $serviceName := .serviceName -}}
{{- $servicePort := .servicePort -}}
{{- $context := .context -}}
{{- range $ruleIndex, $rule := $rules -}}
  {{- /* Create a new rule dict to process */ -}}
  {{- $processedRule := dict -}}
  {{- /* Process backendRefs separately with auto-fill logic */ -}}
  {{- if hasKey $rule "backendRefs" -}}
    {{- $processedBackendRefs := list -}}
    {{- range $idx, $ref := $rule.backendRefs -}}
      {{- $processedRef := dict -}}
      {{- /* Auto-fill empty name */ -}}
      {{- if hasKey $ref "name" -}}
        {{- if eq $ref.name "" -}}
          {{- $_ := set $processedRef "name" $serviceName -}}
        {{- else -}}
          {{- $_ := set $processedRef "name" $ref.name -}}
        {{- end -}}
      {{- else -}}
        {{- $_ := set $processedRef "name" $serviceName -}}
      {{- end -}}
      {{- /* Auto-fill missing port */ -}}
      {{- if hasKey $ref "port" -}}
        {{- $_ := set $processedRef "port" $ref.port -}}
      {{- else if $servicePort -}}
        {{- $_ := set $processedRef "port" $servicePort -}}
      {{- end -}}
      {{- /* Copy all other fields */ -}}
      {{- range $key, $value := $ref -}}
        {{- if and (ne $key "name") (ne $key "port") -}}
          {{- $_ := set $processedRef $key $value -}}
        {{- end -}}
      {{- end -}}
      {{- $processedBackendRefs = append $processedBackendRefs $processedRef -}}
    {{- end -}}
    {{- $_ := set $processedRule "backendRefs" $processedBackendRefs -}}
  {{- end -}}
  {{- /* Copy all other fields from the original rule */ -}}
  {{- range $key, $value := $rule -}}
    {{- if ne $key "backendRefs" -}}
      {{- $_ := set $processedRule $key $value -}}
    {{- end -}}
  {{- end }}
- {{ $processedRule | toYaml | nindent 2 | trim }}
{{ end -}}
{{- end -}}

{{/*
Render GRPCRoute rules with auto-filled backendRefs
Same logic as HTTPRoute rules.

Usage:
{{ include "common.gateway.grpcroute.rules" (dict "rules" .Values.gateway.grpc.rules "serviceName" $fullname "servicePort" .Values.service.ports.grpc.port "context" $) }}
*/}}
{{- define "common.gateway.grpcroute.rules" -}}
{{- include "common.gateway.httproute.rules" . -}}
{{- end -}}

{{/*
Render TCPRoute rules with auto-filled backendRefs

Usage:
{{ include "common.gateway.tcproute.rules" (dict "rules" .Values.gateway.tcp.rules "serviceName" $fullname "servicePort" .Values.service.ports.tcp.port "context" $) }}
*/}}
{{- define "common.gateway.tcproute.rules" -}}
{{- include "common.gateway.httproute.rules" . -}}
{{- end -}}

{{/*
Render TLSRoute rules with auto-filled backendRefs

Usage:
{{ include "common.gateway.tlsroute.rules" (dict "rules" .Values.gateway.tls.rules "serviceName" $fullname "servicePort" .Values.service.ports.https.port "context" $) }}
*/}}
{{- define "common.gateway.tlsroute.rules" -}}
{{- include "common.gateway.httproute.rules" . -}}
{{- end -}}

{{/*
Generate BackendTrafficPolicy targetRefs with smart defaults
Auto-generates targetRefs pointing to HTTPRoute or GRPCRoute if not specified.

Parameters:
- spec (dict): BackendTrafficPolicy spec (may contain custom targetRefs)
- values (dict): All values (to check which routes are enabled)
- fullname (string): Full resource name
- context ($): Chart context

Usage:
{{ include "common.gateway.backendtrafficpolicy.targetRefs" (dict "spec" .Values.gateway.backendTrafficPolicy.spec "values" .Values "fullname" $fullname "context" $) }}

Logic:
- If spec.targetRefs exists, use it as-is
- Else if .Values.gateway.backendTrafficPolicy.targetRefs exists, use it
- Else auto-generate: 
  - If http.enabled: target HTTPRoute
  - Else if grpc.enabled: target GRPCRoute
*/}}
{{- define "common.gateway.backendtrafficpolicy.targetRefs" -}}
{{- $spec := .spec -}}
{{- $values := .values -}}
{{- $fullname := .fullname -}}
{{- $context := .context -}}
{{- if $spec.targetRefs -}}
{{- toYaml $spec.targetRefs -}}
{{- else if $values.gateway.backendTrafficPolicy.targetRefs -}}
{{- toYaml $values.gateway.backendTrafficPolicy.targetRefs -}}
{{- else -}}
{{- if $values.gateway.http.enabled -}}
- group: gateway.networking.k8s.io
  kind: HTTPRoute
  name: {{ $fullname }}
{{- else if $values.gateway.grpc.enabled -}}
- group: gateway.networking.k8s.io
  kind: GRPCRoute
  name: {{ printf "%s-grpc" $fullname }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Generate BackendTrafficPolicy spec
Handles both full spec mode and legacy field-by-field mode.

Parameters:
- config (dict): backendTrafficPolicy configuration from values
- fullname (string): Full resource name for targetRefs
- values (dict): All values for auto-generating targetRefs
- context ($): Chart context

Usage:
{{ include "common.gateway.backendtrafficpolicy.spec" (dict "config" .Values.gateway.backendTrafficPolicy "fullname" $fullname "values" .Values "context" $) }}
*/}}
{{- define "common.gateway.backendtrafficpolicy.spec" -}}
{{- $config := .config -}}
{{- $fullname := .fullname -}}
{{- $values := .values -}}
{{- $context := .context -}}
{{- if $config.spec -}}
{{- /* Full spec mode: render as-is */ -}}
{{- toYaml $config.spec -}}
{{- else -}}
{{- /* Legacy mode: construct spec from individual fields */ -}}
{{- $spec := dict -}}
{{- /* Generate targetRefs */ -}}
{{- $targetRefs := include "common.gateway.backendtrafficpolicy.targetRefs" (dict "spec" $spec "values" $values "fullname" $fullname "context" $context) | fromYaml -}}
{{- if $targetRefs -}}
  {{- $_ := set $spec "targetRefs" $targetRefs -}}
{{- end -}}
{{- /* Add other fields if they exist */ -}}
{{- range $key := list "loadBalancer" "timeout" "http" "http2" "retry" "healthCheck" "circuitBreaker" "proxyProtocol" "tcpKeepalive" "connection" "dns" "useClientProtocol" "faultInjection" "rateLimit" -}}
  {{- $value := index $config $key -}}
  {{- if $value -}}
    {{- $_ := set $spec $key $value -}}
  {{- end -}}
{{- end -}}
{{- toYaml $spec -}}
{{- end -}}
{{- end -}}

{{/*
Generate Backend spec
Handles both full spec mode and legacy endpoints/appProtocols mode.

Parameters:
- config (dict): backend configuration from values
- context ($): Chart context

Usage:
{{ include "common.gateway.backend.spec" (dict "config" .Values.gateway.backend "context" $) }}
*/}}
{{- define "common.gateway.backend.spec" -}}
{{- $config := .config -}}
{{- $context := .context -}}
{{- if $config.spec -}}
{{- /* Full spec mode: render as-is */ -}}
{{- toYaml $config.spec -}}
{{- else -}}
{{- /* Legacy mode: construct from endpoints and appProtocols */ -}}
{{- if $config.endpoints -}}
endpoints:
  {{- toYaml $config.endpoints | nindent 2 }}
{{- end -}}
{{- if $config.appProtocols -}}
appProtocols:
  {{- toYaml $config.appProtocols | nindent 2 }}
{{- end -}}
{{- end -}}
{{- end -}}
