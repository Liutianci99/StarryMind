enum CelestialBodyType { satellite, planet, star }

extension CelestialBodyTypeX on CelestialBodyType {
  String get label => switch (this) {
    CelestialBodyType.satellite => '卫星',
    CelestialBodyType.planet => '行星',
    CelestialBodyType.star => '恒星',
  };

  String get nextActionHint => switch (this) {
    CelestialBodyType.satellite => '继续补充，再决定是否升级为行星。',
    CelestialBodyType.planet => '适合做复盘、整理和后续编辑。',
    CelestialBodyType.star => '可以作为主题中枢，后续接摘要和聚类。',
  };
}

class SpacePoint {
  const SpacePoint({required this.x, required this.y, required this.z});

  final double x;
  final double y;
  final double z;

  Map<String, double> toJson() => {'x': x, 'y': y, 'z': z};

  factory SpacePoint.fromJson(Map<String, dynamic> json) {
    return SpacePoint(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      z: (json['z'] as num).toDouble(),
    );
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
    if (normalized.length <= 88) return normalized;
    return '${normalized.substring(0, 88)}...';
  }

  Map<String, Object> toRendererPayload() {
    return {
      'id': id, 'title': title, 'content': content, 'summary': summary,
      'type': type.name, 'position': position.toJson(),
      'cluster': cluster, 'tags': tags, 'intensity': intensity,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, 'title': title, 'content': content,
      'type': type.name,
      'position': position.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'cluster': cluster, 'tags': tags, 'intensity': intensity,
    };
  }

  factory CelestialBody.fromJson(Map<String, dynamic> json) {
    return CelestialBody(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      type: CelestialBodyType.values.byName(json['type'] as String),
      position: SpacePoint.fromJson(json['position'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      cluster: json['cluster'] as String,
      tags: (json['tags'] as List<dynamic>).cast<String>(),
      intensity: (json['intensity'] as num).toDouble(),
    );
  }
}
