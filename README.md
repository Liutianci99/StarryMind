# StarryMind

StarryMind（灵感星图）当前处于 Flutter 基础框架阶段，先完成应用壳层、页面分层、mock 数据流和星图界面骨架，暂未完成 MVP 的 WebView/Three.js 闭环。

## 当前状态

- 已替换默认 Flutter counter 模板
- 已搭好 `core / features / shared` 的基础目录结构
- 已实现首页壳层、星空背景、节点画布占位、输入区、详情区
- 已用本地 mock 数据跑通初始化、选中节点和新增想法

## 开发

```bash
flutter analyze
dart test
flutter run
```

## 文档

- [产品需求文档](docs/PRD.md)
- [开发文档](docs/development.md)
