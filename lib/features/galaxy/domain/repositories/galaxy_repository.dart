import 'package:starry_mind/features/galaxy/domain/models/celestial_body.dart';

abstract class GalaxyRepository {
  Future<List<CelestialBody>> loadAll();
  Future<void> save(CelestialBody body);
  Future<void> delete(String id);
}
