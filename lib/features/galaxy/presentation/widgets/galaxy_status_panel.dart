import 'package:flutter/material.dart';
import 'package:starry_mind/shared/presentation/widgets/frosted_panel.dart';

class GalaxyStatusPanel extends StatelessWidget {
  const GalaxyStatusPanel({
    super.key,
    required this.totalBodies,
    required this.starCount,
    required this.planetCount,
    required this.satelliteCount,
    required this.activeCluster,
    required this.rendererLabel,
    required this.nextMilestone,
  });

  final int totalBodies;
  final int starCount;
  final int planetCount;
  final int satelliteCount;
  final String activeCluster;
  final String rendererLabel;
  final String nextMilestone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FrostedPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('MVP 控制台', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            '现在已经跑通 Flutter 壳、WebView 本地资源和 3D 星图通信闭环。',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _MetricTile(label: '总节点', value: totalBodies.toString()),
              _MetricTile(label: '恒星', value: starCount.toString()),
              _MetricTile(label: '行星', value: planetCount.toString()),
              _MetricTile(label: '卫星', value: satelliteCount.toString()),
            ],
          ),
          const SizedBox(height: 20),
          Text('当前聚类', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          _StatusPill(label: activeCluster, color: theme.colorScheme.primary),
          const SizedBox(height: 18),
          Text('渲染状态', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(rendererLabel, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 18),
          Text('下一阶段', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(nextMilestone, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 110,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withValues(alpha: 0.04),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(fontSize: 26),
          ),
          const SizedBox(height: 4),
          Text(label, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Text(label),
    );
  }
}
