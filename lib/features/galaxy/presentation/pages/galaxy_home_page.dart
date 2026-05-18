import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:starry_mind/core/theme/app_theme.dart';
import 'package:starry_mind/features/galaxy/application/galaxy_controller.dart';
import 'package:starry_mind/features/galaxy/data/local/local_galaxy_repository.dart';
import 'package:starry_mind/features/galaxy/presentation/widgets/celestial_body_detail_panel.dart';
import 'package:starry_mind/features/galaxy/presentation/widgets/galaxy_render_surface.dart';
import 'package:starry_mind/features/galaxy/presentation/widgets/thought_composer.dart';
import 'package:starry_mind/shared/presentation/widgets/frosted_panel.dart';
import 'package:starry_mind/shared/presentation/widgets/starfield_backdrop.dart';

class GalaxyHomePage extends StatefulWidget {
  const GalaxyHomePage({super.key});

  @override
  State<GalaxyHomePage> createState() => _GalaxyHomePageState();
}

class _GalaxyHomePageState extends State<GalaxyHomePage> {
  late final GalaxyController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GalaxyController(repository: LocalGalaxyRepository())
      ..bootstrap();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          body: StarfieldBackdrop(
            child: SafeArea(
              child: _controller.isBootstrapping
                  ? const Center(child: _PulsingStar())
                  : Stack(
                      children: [
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 100),
                            child: GalaxyRenderSurface(
                              bodies: _controller.bodies,
                              selectedBody: _controller.selectedBody,
                              onBodySelected: _handleBodySelected,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          left: 16,
                          right: 16,
                          child: _TopBar(controller: _controller),
                        ),
                        Positioned(
                          bottom: 8,
                          left: 12,
                          right: 12,
                          child: ThoughtComposer(
                            controller: _controller.composerController,
                            onSubmit: _controller.submitThought,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  void _handleBodySelected(String id) {
    _controller.selectBodyById(id);
    final body = _controller.selectedBody;
    if (body == null) return;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
          child: SizedBox(
            height: math.min(MediaQuery.of(context).size.height * 0.52, 400),
            child: CelestialBodyDetailPanel(
              body: body,
              onDelete: () {
                Navigator.of(context).pop();
                _controller.deleteBody(body.id);
              },
            ),
          ),
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.controller});

  final GalaxyController controller;

  @override
  Widget build(BuildContext context) {
    return FrostedPanel(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 999,
      child: Row(
        children: [
          Container(
            width: 8, height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.starGold,
              boxShadow: [BoxShadow(color: AppTheme.starGold.withValues(alpha: 0.5), blurRadius: 8)],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              controller.activeCluster.isEmpty
                  ? '星空尚静'
                  : controller.activeCluster,
              style: const TextStyle(
                fontFamily: 'Cormorant Garamond',
                fontStyle: FontStyle.italic,
                fontSize: 15,
                color: AppTheme.ink900,
              ),
            ),
          ),
          _StatChip('${controller.totalBodies}'),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: AppTheme.ink900.withValues(alpha: 0.06),
        border: Border.all(color: AppTheme.ink900.withValues(alpha: 0.10)),
      ),
      child: Text(
        value,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12, fontWeight: FontWeight.w500,
          color: AppTheme.ink500,
        ),
      ),
    );
  }
}

class _PulsingStar extends StatefulWidget {
  const _PulsingStar();

  @override
  State<_PulsingStar> createState() => _PulsingStarState();
}

class _PulsingStarState extends State<_PulsingStar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        final opacity = 0.4 + _anim.value * 0.6;
        return Container(
          width: 16, height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.starGold.withValues(alpha: opacity),
            boxShadow: [
              BoxShadow(
                color: AppTheme.starGold.withValues(alpha: opacity * 0.5),
                blurRadius: 24,
              ),
            ],
          ),
        );
      },
    );
  }
}
