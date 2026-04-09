import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:starry_mind/features/galaxy/application/galaxy_controller.dart';
import 'package:starry_mind/features/galaxy/data/mock/mock_galaxy_repository.dart';
import 'package:starry_mind/features/galaxy/presentation/widgets/celestial_body_detail_panel.dart';
import 'package:starry_mind/features/galaxy/presentation/widgets/galaxy_render_surface.dart';
import 'package:starry_mind/features/galaxy/presentation/widgets/galaxy_status_panel.dart';
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
    _controller = GalaxyController(repository: MockGalaxyRepository())
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
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isCompact = constraints.maxWidth < 1024;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _Header(isCompact: isCompact),
                        const SizedBox(height: 16),
                        Expanded(
                          child: _controller.isBootstrapping
                              ? const Center(child: CircularProgressIndicator())
                              : isCompact
                              ? _CompactContent(
                                  controller: _controller,
                                  onBodySelected: (id) =>
                                      _handleBodySelected(id, showSheet: true),
                                )
                              : _WideContent(
                                  controller: _controller,
                                  onBodySelected: (id) =>
                                      _handleBodySelected(id, showSheet: false),
                                ),
                        ),
                        const SizedBox(height: 16),
                        ThoughtComposer(
                          controller: _controller.composerController,
                          onSubmit: _controller.submitThought,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleBodySelected(String id, {required bool showSheet}) {
    _controller.selectBodyById(id);
    final selectedBody = _controller.selectedBody;

    if (!showSheet || selectedBody == null) {
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
          child: SizedBox(
            height: math.min(MediaQuery.of(context).size.height * 0.56, 420),
            child: CelestialBodyDetailPanel(body: selectedBody),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FrostedPanel(
      child: isCompact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('StarryMind', style: theme.textTheme.headlineLarge),
                const SizedBox(height: 8),
                Text('灵感星图 MVP', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  '当前版本已经跑通 Flutter 壳、WebView 本地 HTML、Three.js 渲染以及节点点击回传详情的最小闭环。',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: const [
                    _HeaderBadge(label: '阶段：MVP'),
                    _HeaderBadge(label: '渲染：Three.js'),
                    _HeaderBadge(label: '桥接：Flutter <-> WebView'),
                  ],
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('StarryMind', style: theme.textTheme.headlineLarge),
                      const SizedBox(height: 8),
                      Text('灵感星图 MVP', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(
                        '当前版本已经跑通 Flutter 壳、WebView 本地 HTML、Three.js 渲染以及节点点击回传详情的最小闭环。',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                const Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.end,
                  children: [
                    _HeaderBadge(label: '阶段：MVP'),
                    _HeaderBadge(label: '渲染：Three.js'),
                    _HeaderBadge(label: '桥接：Flutter <-> WebView'),
                  ],
                ),
              ],
            ),
    );
  }
}

class _CompactContent extends StatelessWidget {
  const _CompactContent({
    required this.controller,
    required this.onBodySelected,
  });

  final GalaxyController controller;
  final ValueChanged<String> onBodySelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final canvasHeight = math.max(320.0, constraints.maxHeight * 0.78);

        return Column(
          children: [
            GalaxyStatusPanel(
              totalBodies: controller.totalBodies,
              starCount: controller.starCount,
              planetCount: controller.planetCount,
              satelliteCount: controller.satelliteCount,
              activeCluster: controller.activeCluster,
              rendererLabel: controller.rendererLabel,
              nextMilestone: controller.nextMilestone,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: canvasHeight,
              child: GalaxyRenderSurface(
                bodies: controller.bodies,
                selectedBody: controller.selectedBody,
                onBodySelected: onBodySelected,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _WideContent extends StatelessWidget {
  const _WideContent({required this.controller, required this.onBodySelected});

  final GalaxyController controller;
  final ValueChanged<String> onBodySelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 300,
          child: GalaxyStatusPanel(
            totalBodies: controller.totalBodies,
            starCount: controller.starCount,
            planetCount: controller.planetCount,
            satelliteCount: controller.satelliteCount,
            activeCluster: controller.activeCluster,
            rendererLabel: controller.rendererLabel,
            nextMilestone: controller.nextMilestone,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GalaxyRenderSurface(
            bodies: controller.bodies,
            selectedBody: controller.selectedBody,
            onBodySelected: onBodySelected,
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 320,
          child: CelestialBodyDetailPanel(body: controller.selectedBody),
        ),
      ],
    );
  }
}

class _HeaderBadge extends StatelessWidget {
  const _HeaderBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Text(label),
    );
  }
}
