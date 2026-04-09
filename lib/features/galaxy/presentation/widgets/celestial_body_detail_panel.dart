import 'package:flutter/material.dart';
import 'package:starry_mind/features/galaxy/domain/models/celestial_body.dart';
import 'package:starry_mind/shared/presentation/widgets/frosted_panel.dart';

class CelestialBodyDetailPanel extends StatelessWidget {
  const CelestialBodyDetailPanel({super.key, required this.body});

  final CelestialBody? body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FrostedPanel(
      child: body == null
          ? Center(
              child: Text(
                '选择一颗天体后，这里会显示摘要与后续动作。',
                style: theme.textTheme.bodyMedium,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('节点详情', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _MetaTag(label: body!.type.label),
                      _MetaTag(label: body!.cluster),
                      _MetaTag(label: '${body!.characterCount} 字'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(body!.title, style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text(
                    _formatDateTime(body!.createdAt),
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(body!.content, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 18),
                  Text('标签', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: body!.tags
                        .map((tag) => _MetaTag(label: '#$tag'))
                        .toList(growable: false),
                  ),
                  const SizedBox(height: 18),
                  Text('下一步建议', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    body!.type.nextActionHint,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '${dateTime.year}-$month-$day $hour:$minute';
  }
}

class _MetaTag extends StatelessWidget {
  const _MetaTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Text(label),
    );
  }
}
