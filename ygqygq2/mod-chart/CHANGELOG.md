# Changelog

## 5.1.0 (2026-01-05)

- [ygqygq2/mod-chart] - Add complete Gateway API support
  - Add HTTPRoute with advanced features (header/query matching, traffic weights, filters, timeouts)
  - Add GRPCRoute for gRPC service routing
  - Add TCPRoute for TCP traffic routing
  - Add TLSRoute for TLS passthrough
  - Support filters: RequestRedirect, URLRewrite, RequestHeaderModifier, ResponseHeaderModifier, RequestMirror
  - Split gateway templates into separate files for better maintainability

## 5.0.1 (2025-01-26)

- [ygqygq2/mod-chart] - support vpa

## 5.0.0 (2024-11-20)

- [ygqygq2/mod-chart] - Release 5.0.0 add podMonitor support
