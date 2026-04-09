import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:starry_mind/features/galaxy/domain/models/celestial_body.dart';
import 'package:starry_mind/features/galaxy/domain/repositories/galaxy_repository.dart';
import 'package:starry_mind/features/galaxy/domain/services/thought_draft_analyzer.dart';

class GalaxyController extends ChangeNotifier {
  GalaxyController({
    required GalaxyRepository repository,
    ThoughtDraftAnalyzer draftAnalyzer = const ThoughtDraftAnalyzer(),
  }) : _repository = repository,
       _draftAnalyzer = draftAnalyzer;

  final GalaxyRepository _repository;
  final ThoughtDraftAnalyzer _draftAnalyzer;
  final TextEditingController composerController = TextEditingController();
  final math.Random _random = math.Random();

  bool _isBootstrapping = true;
  List<CelestialBody> _bodies = const [];
  CelestialBody? _selectedBody;

  bool get isBootstrapping => _isBootstrapping;
  List<CelestialBody> get bodies => _bodies;
  CelestialBody? get selectedBody => _selectedBody;

  int get totalBodies => _bodies.length;
  int get starCount => _countByType(CelestialBodyType.star);
  int get planetCount => _countByType(CelestialBodyType.planet);
  int get satelliteCount => _countByType(CelestialBodyType.satellite);
  String get activeCluster => _selectedBody?.cluster ?? '等待选择节点';
  String get rendererLabel => 'Flutter 占位画布';
  String get nextMilestone => '接入 WebView/Three.js 通信闭环';

  Future<void> bootstrap() async {
    final seedBodies = await _repository.loadBootstrapBodies();
    _bodies = seedBodies;
    _selectedBody = seedBodies.isNotEmpty ? seedBodies.first : null;
    _isBootstrapping = false;
    notifyListeners();
  }

  void selectBody(CelestialBody body) {
    if (_selectedBody?.id == body.id) {
      return;
    }
    _selectedBody = body;
    notifyListeners();
  }

  void submitThought() {
    final raw = composerController.text.trim();
    if (raw.isEmpty) {
      return;
    }

    final body = CelestialBody(
      id: 'local-${DateTime.now().microsecondsSinceEpoch}',
      title: _draftAnalyzer.deriveTitle(raw),
      content: raw,
      type: _draftAnalyzer.resolveType(raw),
      position: _generatePoint(),
      createdAt: DateTime.now(),
      cluster: _draftAnalyzer.deriveCluster(raw),
      tags: _draftAnalyzer.deriveTags(raw),
      intensity: 0.56 + _random.nextDouble() * 0.34,
    );

    _bodies = [..._bodies, body];
    _selectedBody = body;
    composerController.clear();
    notifyListeners();
  }

  int _countByType(CelestialBodyType type) {
    return _bodies.where((body) => body.type == type).length;
  }

  SpacePoint _generatePoint() {
    final angle = _random.nextDouble() * math.pi * 2;
    final radius = 0.16 + _random.nextDouble() * 0.28;
    final x = (0.5 + math.cos(angle) * radius).clamp(0.12, 0.88);
    final y = (0.5 + math.sin(angle) * radius).clamp(0.14, 0.82);
    return SpacePoint(x: x.toDouble(), y: y.toDouble());
  }

  @override
  void dispose() {
    composerController.dispose();
    super.dispose();
  }
}
