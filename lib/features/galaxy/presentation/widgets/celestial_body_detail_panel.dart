import 'package:flutter/material.dart';
import 'package:starry_mind/core/theme/app_theme.dart';
import 'package:starry_mind/features/galaxy/domain/models/celestial_body.dart';
import 'package:starry_mind/shared/presentation/widgets/frosted_panel.dart';

class CelestialBodyDetailPanel extends StatelessWidget {
  const CelestialBodyDetailPanel({
    super.key,
    required this.body,
    this.onDelete,
  });

  final CelestialBody? body;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    if (body == null) return const SizedBox.shrink();

    return FrostedPanel(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _Tag(body!.type.label),
                const SizedBox(width: 8),
                _Tag(body!.cluster),
                const Spacer(),
                if (onDelete != null)
                  GestureDetector(
                    onTap: onDelete,
                    child: const Text(
                      'let go',
                      style: TextStyle(
                        fontFamily: 'Cormorant Garamond',
                        fontStyle: FontStyle.italic,
                        fontSize: 13, color: AppTheme.ember,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              body!.title,
              style: const TextStyle(
                fontFamily: 'Cormorant Garamond',
                fontSize: 22, fontWeight: FontWeight.w500,
                color: AppTheme.ink900, height: 1.3,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _formatDateTime(body!.createdAt),
              style: const TextStyle(
                fontFamily: 'Inter', fontSize: 11,
                color: AppTheme.ink400,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              body!.content,
              style: const TextStyle(
                fontFamily: 'Cormorant Garamond',
                fontSize: 16, height: 1.7, color: AppTheme.ink700,
              ),
            ),
            if (body!.tags.isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: body!.tags.map((t) => _Tag('#$t')).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: AppTheme.ink900.withValues(alpha: 0.05),
        border: Border.all(color: AppTheme.ink900.withValues(alpha: 0.10)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Inter', fontSize: 11,
          color: AppTheme.ink500, letterSpacing: 0.5,
        ),
      ),
    );
  }
}
