# StarryMind 开发文档

最后更新：2026-04-09

## 当前目标

当前已完成 Phase 1 MVP，重点从“基础壳层”切换为“稳定当前闭环并推进下一阶段能力”。本阶段已经跑通 Flutter 壳、WebView 本地资源、Three.js 渲染、新增节点动画和点击节点回传详情。

## 项目结构

```text
assets/
  web/
    galaxy_mvp.html
    vendor/
      OrbitControls.js
      three.min.js
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
- 将 `SpacePoint` 扩展为 3D 坐标，并为渲染层提供结构化 payload。
- 引入 `webview_flutter`，使用本地 `assets/web/galaxy_mvp.html` 作为渲染页。
- 将 Three.js 与 OrbitControls 作为本地资源打进项目，避免运行时依赖外网。
- 完成 Flutter -> WebView bridge：
  - 启动时 bootstrap 全量节点
  - 输入后新增节点并触发飞入动画
  - Flutter 选中节点时同步高亮 WebView 天体
- 完成 WebView -> Flutter bridge：
  - 点击 3D 天体后回传节点 id
  - 移动端弹出 Flutter 详情底部浮层
  - 宽屏布局同步更新右侧详情面板
- 完成首页 MVP 框架：
  - 星空背景与顶部状态头部
  - WebView 3D 渲染容器
  - 宽屏状态面板
  - 底部输入组件
- 建立统一半透明面板组件，方便后续继续扩展 UI。
- 扩充 mock 数据到 20 个初始天体，满足 MVP 首屏星图规模。
- 新增基础纯 Dart 测试，覆盖输入分类规则、mock 数据加载和渲染 payload。

## 当前约束

- 当前 3D 层已经可用，但仍是单 HTML 文件 + 本地脚本的 MVP 实现，还没有拆分成更清晰的 Web 端工程结构。
- Three.js 当前使用本地 vendor 脚本接入，尚未建立正式的前端构建链。
- 语义聚类、节点位置、标签提取目前仍是本地 mock 规则。
- 还没有接入本地持久化、后端或大模型。
- 当前环境下 `flutter test` 的 tester shell 会异常断开，因此暂时使用 `dart test` 维护基础自动化校验。

## TODO

- 将 Web 侧渲染资源拆出为独立的前端目录和更可维护的脚本结构。
- 把当前固定 mock 星图替换为本地持久化数据源，保留用户新增内容。
- 定义双击聚焦阅读、相机推进、节点标签显示等二阶段交互。
- 引入真实的节点摘要、实体分级、embedding 和相似度聚类。
- 支持节点删除、编辑和重新布局。
- 接入后端与 AI 调度层，补上向量检索、摘要和星云聚类。
