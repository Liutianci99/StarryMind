import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:starry_mind/features/galaxy/domain/models/celestial_body.dart';

class HiveStorage {
  static const _boxName = 'celestial_bodies';

  static Future<void> init() async {
    await Hive.initFlutter();
  }

  static Future<Box<String>> _openBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<String>(_boxName);
    }
    return Hive.openBox<String>(_boxName);
  }

  static Future<List<CelestialBody>> loadAll() async {
    final box = await _openBox();
    final bodies = <CelestialBody>[];
    for (final raw in box.values) {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      bodies.add(CelestialBody.fromJson(json));
    }
    bodies.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return bodies;
  }

  static Future<void> save(CelestialBody body) async {
    final box = await _openBox();
    await box.put(body.id, jsonEncode(body.toJson()));
  }

  static Future<void> delete(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  static Future<void> saveAll(List<CelestialBody> bodies) async {
    final box = await _openBox();
    final entries = <String, String>{};
    for (final body in bodies) {
      entries[body.id] = jsonEncode(body.toJson());
    }
    await box.putAll(entries);
  }
}
