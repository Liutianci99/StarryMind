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
                              ? _CompactContent(controller: _controller)
                              : _WideContent(controller: _controller),
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
                Text('灵感星图基础壳层', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  '当前用 Flutter 本地组件先把页面结构、状态流和 mock 数据闭环搭起来，后续再替换掉中心画布实现。',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: const [
                    _HeaderBadge(label: '阶段：Foundation'),
                    _HeaderBadge(label: '数据：Mock'),
                    _HeaderBadge(label: '目标：留出渲染桥'),
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
                      Text('灵感星图基础壳层', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(
                        '当前用 Flutter 本地组件先把页面结构、状态流和 mock 数据闭环搭起来，后续再替换掉中心画布实现。',
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
                    _HeaderBadge(label: '阶段：Foundation'),
                    _HeaderBadge(label: '数据：Mock'),
                    _HeaderBadge(label: '目标：留出渲染桥'),
                  ],
                ),
              ],
            ),
    );
  }
}

class _CompactContent extends StatelessWidget {
  const _CompactContent({required this.controller});

  final GalaxyController controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final canvasHeight = math.max(280.0, constraints.maxHeight * 0.44);

        return SingleChildScrollView(
          child: Column(
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
                  onSelect: controller.selectBody,
                ),
              ),
              const SizedBox(height: 16),
              CelestialBodyDetailPanel(body: controller.selectedBody),
            ],
          ),
        );
      },
    );
  }
}

class _WideContent extends StatelessWidget {
  const _WideContent({required this.controller});

  final GalaxyController controller;

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
            onSelect: controller.selectBody,
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
