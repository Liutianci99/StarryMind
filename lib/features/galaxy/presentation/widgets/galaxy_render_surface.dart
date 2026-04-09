import 'package:flutter/material.dart';
import 'package:starry_mind/features/galaxy/domain/models/celestial_body.dart';
import 'package:starry_mind/shared/presentation/widgets/frosted_panel.dart';

class GalaxyRenderSurface extends StatelessWidget {
  const GalaxyRenderSurface({
    super.key,
    required this.bodies,
    required this.selectedBody,
    required this.onSelect,
  });

  final List<CelestialBody> bodies;
  final CelestialBody? selectedBody;
  final ValueChanged<CelestialBody> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FrostedPanel(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, constraints.maxHeight);

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF10254A).withValues(alpha: 0.38),
                          const Color(0xFF060B16).withValues(alpha: 0.24),
                          const Color(0xFF02040A).withValues(alpha: 0.72),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: _GalaxyLinkPainter(
                        bodies: bodies,
                        selectedBody: selectedBody,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 18,
                  left: 18,
                  right: 18,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Galaxy Surface',
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '现在是 Flutter 占位画布，后续直接替换成 WebView 容器。',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      _SurfaceBadge(label: '${bodies.length} bodies'),
                    ],
                  ),
                ),
                for (final body in bodies)
                  _BodyNode(
                    size: size,
                    body: body,
                    selected: body.id == selectedBody?.id,
                    onTap: () => onSelect(body),
                  ),
                const Positioned(
                  right: 18,
                  bottom: 18,
                  child: _SurfaceBadge(label: 'phase: foundation'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BodyNode extends StatelessWidget {
  const _BodyNode({
    required this.size,
    required this.body,
    required this.selected,
    required this.onTap,
  });

  final Size size;
  final CelestialBody body;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final diameter = _diameterFor(body);
    final left = size.width * body.position.x - diameter / 2;
    final top = size.height * body.position.y - diameter / 2;
    final color = _colorFor(body.type);

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
      left: left,
      top: top,
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 92,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: diameter,
                height: diameter,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Colors.white.withValues(alpha: 0.96), color],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: selected ? 0.55 : 0.26),
                      blurRadius: selected ? 26 : 16,
                      spreadRadius: selected ? 3 : 1,
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withValues(
                      alpha: selected ? 0.72 : 0.3,
                    ),
                    width: selected ? 2 : 1,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                body.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: selected ? 0.95 : 0.74),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _diameterFor(CelestialBody body) {
    final base = switch (body.type) {
      CelestialBodyType.satellite => 18.0,
      CelestialBodyType.planet => 28.0,
      CelestialBodyType.star => 40.0,
    };
    return base + body.intensity * 12;
  }

  Color _colorFor(CelestialBodyType type) {
    return switch (type) {
      CelestialBodyType.satellite => const Color(0xFF9AD7FF),
      CelestialBodyType.planet => const Color(0xFFFFC96B),
      CelestialBodyType.star => const Color(0xFFFF8A65),
    };
  }
}

class _GalaxyLinkPainter extends CustomPainter {
  _GalaxyLinkPainter({required this.bodies, required this.selectedBody});

  final List<CelestialBody> bodies;
  final CelestialBody? selectedBody;

  @override
  void paint(Canvas canvas, Size size) {
    if (bodies.isEmpty) {
      return;
    }

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final source = selectedBody ?? bodies.first;
    final sourceOffset = Offset(
      size.width * source.position.x,
      size.height * source.position.y,
    );

    for (final body in bodies) {
      if (body.id == source.id) {
        continue;
      }

      final targetOffset = Offset(
        size.width * body.position.x,
        size.height * body.position.y,
      );
      final sameCluster = source.cluster == body.cluster;
      linePaint.color = (sameCluster ? const Color(0xFF83E5FF) : Colors.white)
          .withValues(alpha: sameCluster ? 0.28 : 0.08);
      canvas.drawLine(sourceOffset, targetOffset, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _GalaxyLinkPainter oldDelegate) {
    return oldDelegate.bodies != bodies ||
        oldDelegate.selectedBody?.id != selectedBody?.id;
  }
}

class _SurfaceBadge extends StatelessWidget {
  const _SurfaceBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.24),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Text(label),
    );
  }
}
