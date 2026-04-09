# StarryMind 开发文档

最后更新：2026-04-09

## 当前目标

先把 Flutter 端的项目骨架和主界面结构搭起来，不强行完成 MVP。当前重点是把后续可扩展的分层、状态流、mock 数据流和渲染边界先定住。

## 项目结构

```text
lib/
  app/
    starry_mind_app.dart
  core/
    theme/
      app_theme.dart
  features/
    galaxy/
      application/
        galaxy_controller.dart
      data/
        mock/
          mock_galaxy_repository.dart
      domain/
        models/
          celestial_body.dart
        repositories/
          galaxy_repository.dart
        services/
          thought_draft_analyzer.dart
      presentation/
        pages/
          galaxy_home_page.dart
        widgets/
          celestial_body_detail_panel.dart
          galaxy_render_surface.dart
          galaxy_status_panel.dart
          thought_composer.dart
  shared/
    presentation/
      widgets/
        frosted_panel.dart
        starfield_backdrop.dart
docs/
  PRD.md
  development.md
test/
  widget_test.dart
```

## 已完成

- 用 `StarryMindApp` 替换 Flutter 默认模板入口。
- 建立基础分层：`app`、`core`、`features`、`shared`。
- 基于 `galaxy` feature 建立 `domain / data / application / presentation` 结构。
- 用 `MockGalaxyRepository + GalaxyController` 跑通初始化数据、选择节点、输入新增节点。
- 完成首页基础框架：
  - 星空背景
  - 顶部项目状态头部
  - 星图画布占位层
  - 节点详情面板
  - 底部输入组件
- 建立统一半透明面板组件，方便后续继续扩展 UI。
- 新增基础纯 Dart 测试，覆盖输入分类规则和 mock 数据加载。

## 当前约束

- 中央星图区域目前仍是 Flutter 原生占位实现，不是真正的 3D 渲染层。
- 语义聚类、节点位置、标签提取目前都是本地 mock 规则。
- 还没有接入本地持久化、WebView、后端或大模型。
- 当前环境下 `flutter test` 的 tester shell 会异常断开，因此暂时使用 `dart test` 维护基础自动化校验。

## TODO

- 接入 `webview_flutter`，把 `GalaxyRenderSurface` 替换为真正的 WebView 容器。
- 建立 Flutter -> WebView 的 JS bridge，先支持新增节点和选中节点事件。
- 独立维护 Web 侧渲染资源，完成随机 20 个天体的 Three.js 原型。
- 定义节点详情浮层、双击聚焦阅读、相机推进等核心交互。
- 接入本地持久化，保留输入记录和最近选中的节点。
- 接入后端与 AI 调度层，补上摘要、实体分级、embedding 和向量检索。
- 将 mock 语义规则替换为真实的相似度计算与聚类逻辑。
