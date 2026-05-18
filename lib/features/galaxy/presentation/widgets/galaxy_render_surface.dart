import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:starry_mind/core/theme/app_theme.dart';
import 'package:starry_mind/features/galaxy/domain/models/celestial_body.dart';
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
      ..setBackgroundColor(AppTheme.creamCanvas)
      ..addJavaScriptChannel(
        'StarryMindReady',
        onMessageReceived: (_) {
          if (!_rendererReady && mounted) {
            setState(() => _rendererReady = true);
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
            if (id is String) widget.onBodySelected(id);
          }
        },
      )
      ..loadFlutterAsset('assets/web/galaxy_mvp.html');
  }

  @override
  void didUpdateWidget(covariant GalaxyRenderSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_rendererReady) return;
    unawaited(_syncRendererIncrementally());
  }

  Future<void> _bootstrapRenderer() async {
    if (!_rendererReady) return;
    final payload = widget.bodies
        .map((b) => b.toRendererPayload())
        .toList(growable: false);
    await _runJs('window.StarryMindBridge.bootstrap(${jsonEncode(payload)});');
    _syncedBodyIds
      ..clear()
      ..addAll(widget.bodies.map((b) => b.id));
    await _syncSelection();
  }

  Future<void> _syncRendererIncrementally() async {
    for (final body in widget.bodies) {
      if (_syncedBodyIds.contains(body.id)) continue;
      await _runJs('window.StarryMindBridge.addBody(${jsonEncode(body.toRendererPayload())});');
      _syncedBodyIds.add(body.id);
    }
    await _syncSelection();
  }

  Future<void> _syncSelection() async {
    final id = widget.selectedBody?.id;
    if (id == null || id == _lastSelectedBodyId) return;
    _lastSelectedBodyId = id;
    await _runJs('window.StarryMindBridge.selectBody(${jsonEncode(id)});');
  }

  Future<void> _runJs(String script) async {
    try { await _webViewController.runJavaScript(script); } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(color: AppTheme.creamCanvas),
          ),
          Positioned.fill(
            child: WebViewWidget(controller: _webViewController),
          ),
          if (!_rendererReady)
            Positioned.fill(
              child: Container(
                color: AppTheme.creamCanvas,
                child: const Center(
                  child: SizedBox(
                    width: 12, height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: AppTheme.starGold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
