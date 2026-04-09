import 'package:starry_mind/features/galaxy/domain/models/celestial_body.dart';

class ThoughtDraftAnalyzer {
  const ThoughtDraftAnalyzer();

  CelestialBodyType resolveType(String raw) {
    final characterCount = raw.runes.length;
    if (characterCount < 100) {
      return CelestialBodyType.satellite;
    }
    if (characterCount <= 500) {
      return CelestialBodyType.planet;
    }
    return CelestialBodyType.star;
  }

  String deriveTitle(String raw) {
    if (raw.length <= 16) {
      return raw;
    }
    return '${raw.substring(0, 16)}...';
  }

  String deriveCluster(String raw) {
    final normalized = raw.toLowerCase();
    if (normalized.contains('three') ||
        normalized.contains('渲染') ||
        normalized.contains('webview')) {
      return '渲染桥接';
    }
    if (normalized.contains('向量') ||
        normalized.contains('embedding') ||
        normalized.contains('语义')) {
      return '语义引擎';
    }
    if (normalized.contains('输入') ||
        normalized.contains('记录') ||
        normalized.contains('笔记')) {
      return '采集流程';
    }
    if (normalized.contains('动画') ||
        normalized.contains('交互') ||
        normalized.contains('手势')) {
      return '交互体验';
    }
    return '灵感草稿';
  }

  List<String> deriveTags(String raw) {
    final tags = <String>{};
    if (raw.contains('MVP') || raw.contains('mvp')) {
      tags.add('mvp');
    }
    if (raw.contains('AI') || raw.contains('ai')) {
      tags.add('ai');
    }
    if (raw.contains('WebView') || raw.contains('webview')) {
      tags.add('webview');
    }
    if (raw.contains('3D') || raw.contains('Three')) {
      tags.add('3d');
    }
    if (tags.isEmpty) {
      tags.add('draft');
    }
    return tags.toList(growable: false);
  }
}
