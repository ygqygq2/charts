# Changelog

## 5.1.1 (2026-01-13)

- 增加 BackendTrafficPolicy 支持
- Gateway API 模板全面重构
  - 使用 common 库的 Gateway helper 函数替代内联逻辑
  - HTTPRoute/GRPCRoute/TCPRoute/TLSRoute 使用 `common.gateway.*` helpers
  - Backend/BackendTrafficPolicy 使用 common helpers
  - 统一资源命名使用 `common.names.gateway.*` helpers
  - 保持完全兼容原生 Gateway API 字段
  - 自动处理 backendRefs 中的空 name/port（填充当前 service 和默认端口）
  - 用户可直接复制 Gateway API 文档配置，无需修改
- 修复 GRPCRoute/TCPRoute/TLSRoute 的 parentRefs 错误使用 gatewayClassName 的问题，应使用 gateway.name

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
