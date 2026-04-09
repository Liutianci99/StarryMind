import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:starry_mind/features/galaxy/domain/models/celestial_body.dart';
import 'package:starry_mind/shared/presentation/widgets/frosted_panel.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GalaxyRenderSurface extends StatefulWidget {
  const GalaxyRenderSurface({
    super.key,
    required this.bodies,
    required this.selectedBody,
    required this.onBodySelected,
  });

  final List<CelestialBody> bodies;
  final CelestialBody? selectedBody;
  final ValueChanged<String> onBodySelected;

  @override
  State<GalaxyRenderSurface> createState() => _GalaxyRenderSurfaceState();
}

class _GalaxyRenderSurfaceState extends State<GalaxyRenderSurface> {
  late final WebViewController _webViewController;
  final Set<String> _syncedBodyIds = <String>{};

  bool _rendererReady = false;
  String? _lastSelectedBodyId;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..addJavaScriptChannel(
        'StarryMindReady',
        onMessageReceived: (_) {
          if (!_rendererReady && mounted) {
            setState(() {
              _rendererReady = true;
            });
          }
          unawaited(_bootstrapRenderer());
        },
      )
      ..addJavaScriptChannel(
        'StarryMindBodySelected',
        onMessageReceived: (message) {
          final payload = jsonDecode(message.message);
          if (payload is Map<String, dynamic>) {
            final id = payload['id'];
            if (id is String) {
              widget.onBodySelected(id);
            }
          }
        },
      )
      ..loadFlutterAsset('assets/web/galaxy_mvp.html');
  }

  @override
  void didUpdateWidget(covariant GalaxyRenderSurface oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_rendererReady) {
      return;
    }

    unawaited(_syncRendererIncrementally());
  }

  Future<void> _bootstrapRenderer() async {
    if (!_rendererReady) {
      return;
    }

    final bodiesPayload = widget.bodies
        .map((body) => body.toRendererPayload())
        .toList(growable: false);

    await _runJavaScript(
      'window.StarryMindBridge.bootstrap(${jsonEncode(bodiesPayload)});',
    );

    _syncedBodyIds
      ..clear()
      ..addAll(widget.bodies.map((body) => body.id));

    await _syncSelection();
  }

  Future<void> _syncRendererIncrementally() async {
    for (final body in widget.bodies) {
      if (_syncedBodyIds.contains(body.id)) {
        continue;
      }

      await _runJavaScript(
        'window.StarryMindBridge.addBody(${jsonEncode(body.toRendererPayload())});',
      );
      _syncedBodyIds.add(body.id);
    }

    await _syncSelection();
  }

  Future<void> _syncSelection() async {
    final selectedId = widget.selectedBody?.id;
    if (selectedId == null || selectedId == _lastSelectedBodyId) {
      return;
    }

    _lastSelectedBodyId = selectedId;
    await _runJavaScript(
      'window.StarryMindBridge.selectBody(${jsonEncode(selectedId)});',
    );
  }

  Future<void> _runJavaScript(String script) async {
    try {
      await _webViewController.runJavaScript(script);
    } catch (_) {
      // The renderer may still be spinning up; later sync passes will retry.
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FrostedPanel(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF13284B).withValues(alpha: 0.24),
                      const Color(0xFF050A14).withValues(alpha: 0.22),
                      const Color(0xFF02040A).withValues(alpha: 0.82),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: WebViewWidget(controller: _webViewController),
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
                        Text('Galaxy MVP', style: theme.textTheme.titleLarge),
                        const SizedBox(height: 6),
                        Text(
                          'Flutter 壳已接入本地 WebView / Three.js 渲染页。',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  _SurfaceBadge(
                    label: _rendererReady ? 'bridge online' : 'loading',
                  ),
                ],
              ),
            ),
            const Positioned(
              right: 18,
              bottom: 18,
              child: _SurfaceBadge(label: 'tap bodies for detail'),
            ),
            if (!_rendererReady)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.18),
                  ),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
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
        color: Colors.black.withValues(alpha: 0.26),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Text(label),
    );
  }
}
