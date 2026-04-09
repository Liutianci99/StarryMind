import 'package:starry_mind/features/galaxy/domain/models/celestial_body.dart';
import 'package:starry_mind/features/galaxy/domain/repositories/galaxy_repository.dart';

class MockGalaxyRepository implements GalaxyRepository {
  @override
  Future<List<CelestialBody>> loadBootstrapBodies() async {
    return [
      CelestialBody(
        id: 'seed-1',
        title: '向量引力引擎',
        content:
            '如果后续引入 embedding，可以先只把文本转成向量，不急着做复杂知识图谱。第一阶段重点是让语义相近的想法能自然靠拢，再把聚类可视化成星云。',
        type: CelestialBodyType.star,
        position: SpacePoint(x: 0.30, y: 0.34),
        createdAt: DateTime(2026, 4, 7, 22, 15),
        cluster: '语义引擎',
        tags: ['embedding', 'cluster', 'mvp'],
        intensity: 0.92,
      ),
      CelestialBody(
        id: 'seed-2',
        title: 'Flutter 壳层拆分',
        content:
            '先把页面、状态、数据源和共享组件的边界拆清楚。这样后面接 WebView、接 AI、接本地存储时不会把首页写成一个巨大文件。',
        type: CelestialBodyType.planet,
        position: SpacePoint(x: 0.56, y: 0.28),
        createdAt: DateTime(2026, 4, 8, 9, 30),
        cluster: '应用框架',
        tags: ['flutter', 'architecture'],
        intensity: 0.74,
      ),
      CelestialBody(
        id: 'seed-3',
        title: '试试双击聚焦',
        content: '节点详情页未来可以从卡片切到沉浸阅读模式。',
        type: CelestialBodyType.satellite,
        position: SpacePoint(x: 0.74, y: 0.42),
        createdAt: DateTime(2026, 4, 8, 12, 6),
        cluster: '交互体验',
        tags: ['focus', 'reading'],
        intensity: 0.58,
      ),
      CelestialBody(
        id: 'seed-4',
        title: 'Three.js 容器通信',
        content:
            'MVP 最小闭环是 Flutter 壳向 WebView 发送新增节点指令，再由 Web 侧完成动画飞入。当前阶段可以先把渲染层抽成一个独立组件，后续直接替换实现。',
        type: CelestialBodyType.planet,
        position: SpacePoint(x: 0.46, y: 0.64),
        createdAt: DateTime(2026, 4, 8, 20, 18),
        cluster: '渲染桥接',
        tags: ['webview', 'threejs', 'bridge'],
        intensity: 0.79,
      ),
      CelestialBody(
        id: 'seed-5',
        title: '情绪色彩映射',
        content: '后续可以根据文本情绪给节点偏暖或偏冷的颜色，不必一开始就做复杂情感分析，只要先留出颜色策略的位置。',
        type: CelestialBodyType.planet,
        position: SpacePoint(x: 0.20, y: 0.66),
        createdAt: DateTime(2026, 4, 9, 8, 40),
        cluster: '视觉系统',
        tags: ['visual', 'sentiment'],
        intensity: 0.68,
      ),
      CelestialBody(
        id: 'seed-6',
        title: '快速记录入口',
        content: '输入要足够轻，最好单手就能把念头丢进星图。',
        type: CelestialBodyType.satellite,
        position: SpacePoint(x: 0.66, y: 0.72),
        createdAt: DateTime(2026, 4, 9, 9, 5),
        cluster: '采集流程',
        tags: ['input', 'mobile'],
        intensity: 0.52,
      ),
    ];
  }
}
