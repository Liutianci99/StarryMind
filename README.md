# StarryMind

StarryMind（灵感星图）当前已经完成 Phase 1 MVP：Flutter 壳层通过 `webview_flutter` 加载本地 HTML，嵌入 Three.js 星图，并跑通新增节点与点击节点详情回传的通信闭环。

## 当前状态

- 已接入 `webview_flutter`
- 已将 Three.js / OrbitControls 与本地 HTML 一起打包到 assets
- 已完成 `Flutter -> WebView` 的新增节点指令
- 已完成 `WebView -> Flutter` 的节点点击回传
- 已提供 20 个 mock 天体作为 MVP 初始星图

## 开发

```bash
flutter analyze
dart test
flutter build apk
flutter run
```

## 文档

- [产品需求文档](docs/PRD.md)
- [开发文档](docs/development.md)
