import 'package:starry_mind/core/storage/hive_storage.dart';
import 'package:starry_mind/features/galaxy/data/mock/mock_galaxy_repository.dart';
import 'package:starry_mind/features/galaxy/domain/models/celestial_body.dart';
import 'package:starry_mind/features/galaxy/domain/repositories/galaxy_repository.dart';

class LocalGalaxyRepository implements GalaxyRepository {
  @override
  Future<List<CelestialBody>> loadAll() async {
    final stored = await HiveStorage.loadAll();
    if (stored.isNotEmpty) return stored;

    // First launch: seed with demo data
    final seeds = MockGalaxyRepository.seedBodies();
    await HiveStorage.saveAll(seeds);
    return seeds;
  }

  @override
  Future<void> save(CelestialBody body) => HiveStorage.save(body);

  @override
  Future<void> delete(String id) => HiveStorage.delete(id);
}
