import 'package:starry_mind/features/galaxy/data/mock/mock_galaxy_repository.dart';
import 'package:starry_mind/features/galaxy/domain/models/celestial_body.dart';
import 'package:starry_mind/features/galaxy/domain/services/thought_draft_analyzer.dart';
import 'package:test/test.dart';

void main() {
  group('ThoughtDraftAnalyzer', () {
    const analyzer = ThoughtDraftAnalyzer();

    test('classifies short drafts as satellites', () {
      expect(
        analyzer.resolveType('先把 WebView 桥接打通。'),
        CelestialBodyType.satellite,
      );
    });

    test('maps render keywords into the rendering cluster', () {
      expect(analyzer.deriveCluster('WebView 和 Three.js 的渲染通信还没接好。'), '渲染桥接');
      expect(analyzer.deriveTags('WebView 和 Three.js 的渲染通信还没接好。'), [
        'webview',
        '3d',
      ]);
    });
  });

  test('MockGalaxyRepository returns bootstrap bodies', () async {
    final repository = MockGalaxyRepository();

    final bodies = await repository.loadBootstrapBodies();

    expect(bodies.length, greaterThanOrEqualTo(20));
    expect(bodies.first.title, '向量引力引擎');
    expect(bodies.first.toRendererPayload()['position'], {
      'x': -0.25,
      'y': 0.22,
      'z': 0.12,
    });
    expect(
      bodies.where((body) => body.type == CelestialBodyType.star),
      isNotEmpty,
    );
  });
}
