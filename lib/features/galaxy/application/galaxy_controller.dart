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
  String get activeCluster => _selectedBody?.cluster ?? '';

  Future<void> bootstrap() async {
    final loaded = await _repository.loadAll();
    _bodies = loaded;
    _selectedBody = loaded.isNotEmpty ? loaded.first : null;
    _isBootstrapping = false;
    notifyListeners();
  }

  void selectBody(CelestialBody body) {
    if (_selectedBody?.id == body.id) return;
    _selectedBody = body;
    notifyListeners();
  }

  void selectBodyById(String id) {
    for (final body in _bodies) {
      if (body.id == id) {
        selectBody(body);
        return;
      }
    }
  }

  Future<void> submitThought() async {
    final raw = composerController.text.trim();
    if (raw.isEmpty) return;

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

    await _repository.save(body);
  }

  Future<void> deleteBody(String id) async {
    _bodies = _bodies.where((b) => b.id != id).toList();
    if (_selectedBody?.id == id) {
      _selectedBody = _bodies.isNotEmpty ? _bodies.last : null;
    }
    notifyListeners();
    await _repository.delete(id);
  }

  int _countByType(CelestialBodyType type) {
    return _bodies.where((body) => body.type == type).length;
  }

  SpacePoint _generatePoint() {
    final theta = _random.nextDouble() * math.pi * 2;
    final phi = math.acos(2 * _random.nextDouble() - 1);
    final radius = 0.35 + _random.nextDouble() * 0.45;
    return SpacePoint(
      x: math.cos(theta) * math.sin(phi) * radius * 1.15,
      y: math.cos(phi) * radius * 0.82,
      z: math.sin(theta) * math.sin(phi) * radius * 1.1,
    );
  }

  @override
  void dispose() {
    composerController.dispose();
    super.dispose();
  }
}
