enum CelestialBodyType { satellite, planet, star }

extension CelestialBodyTypeX on CelestialBodyType {
  String get label => switch (this) {
    CelestialBodyType.satellite => '卫星',
    CelestialBodyType.planet => '行星',
    CelestialBodyType.star => '恒星',
  };

  String get nextActionHint => switch (this) {
    CelestialBodyType.satellite => '继续补充上下文，再决定是否升级为行星。',
    CelestialBodyType.planet => '适合做复盘、整理和后续编辑。',
    CelestialBodyType.star => '可以作为一个主题中枢，后续接摘要和聚类。',
  };
}

class SpacePoint {
  const SpacePoint({required this.x, required this.y, required this.z});

  final double x;
  final double y;
  final double z;

  Map<String, double> toJson() {
    return {'x': x, 'y': y, 'z': z};
  }
}

class CelestialBody {
  const CelestialBody({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.position,
    required this.createdAt,
    required this.cluster,
    required this.tags,
    required this.intensity,
  });

  final String id;
  final String title;
  final String content;
  final CelestialBodyType type;
  final SpacePoint position;
  final DateTime createdAt;
  final String cluster;
  final List<String> tags;
  final double intensity;

  int get characterCount => content.trim().runes.length;

  String get summary {
    final normalized = content.trim();
    if (normalized.length <= 88) {
      return normalized;
    }
    return '${normalized.substring(0, 88)}...';
  }

  Map<String, Object> toRendererPayload() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'summary': summary,
      'type': type.name,
      'position': position.toJson(),
      'cluster': cluster,
      'tags': tags,
      'intensity': intensity,
    };
  }
}
