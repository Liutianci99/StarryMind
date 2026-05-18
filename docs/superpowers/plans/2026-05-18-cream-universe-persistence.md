# Cream Universe + Persistence Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Transform StarryMind from dark-theme MVP with ephemeral data into a cream-universe themed app with local persistence, then build a release APK.

**Architecture:** Three parallel tracks — (1) theme overhaul: rewrite `AppTheme`, `StarfieldBackdrop`, `FrostedPanel`, all widget colors, and `galaxy_mvp.html` to match the cream-universe design system; (2) persistence: add Hive for local storage so thoughts survive app restarts; (3) UX polish: redesign the home page from developer dashboard to user-facing sky experience. Finally build a release APK.

**Tech Stack:** Flutter 3.38, Dart 3.10, Hive (hive + hive_flutter), webview_flutter 4.x, Three.js (local vendor)

---

## File Map

| Action | File | Responsibility |
|--------|------|----------------|
| Modify | `pubspec.yaml` | Add hive, hive_flutter deps; add Google Fonts assets |
| Modify | `lib/core/theme/app_theme.dart` | Cream-universe color scheme, serif typography |
| Modify | `lib/shared/presentation/widgets/starfield_backdrop.dart` | Cream radial gradient, warm glow orbs, ink-colored star dots |
| Modify | `lib/shared/presentation/widgets/frosted_panel.dart` | Cream-glass panel: warm white bg, ink borders, warm shadows |
| Modify | `lib/features/galaxy/domain/models/celestial_body.dart` | Add Hive type adapters, `toJson`/`fromJson` for persistence |
| Create | `lib/core/storage/hive_storage.dart` | Hive init, box open/close, CRUD for bodies |
| Modify | `lib/features/galaxy/domain/repositories/galaxy_repository.dart` | Add save/delete/loadAll methods |
| Create | `lib/features/galaxy/data/local/local_galaxy_repository.dart` | Hive-backed repository implementation |
| Modify | `lib/features/galaxy/application/galaxy_controller.dart` | Wire persistence: save on submit, load on bootstrap, delete support |
| Modify | `lib/features/galaxy/presentation/pages/galaxy_home_page.dart` | Remove developer dashboard, full-bleed sky with floating glass chrome |
| Modify | `lib/features/galaxy/presentation/widgets/galaxy_render_surface.dart` | Cream colors, remove dark overlays |
| Modify | `lib/features/galaxy/presentation/widgets/celestial_body_detail_panel.dart` | Cream-glass styling, ink text |
| Modify | `lib/features/galaxy/presentation/widgets/galaxy_status_panel.dart` | Cream-glass styling (keep as compact info bar) |
| Modify | `lib/features/galaxy/presentation/widgets/thought_composer.dart` | Cream-glass dock, serif placeholder, star-gold send |
| Modify | `lib/app/starry_mind_app.dart` | Async init for Hive before runApp |
| Modify | `lib/main.dart` | WidgetsFlutterBinding + Hive init |
| Modify | `assets/web/galaxy_mvp.html` | Cream background, ink-colored bodies, gold halos, warm lights |
| Modify | `android/app/src/main/AndroidManifest.xml` | Internet permission for Google Fonts, app label |

---

### Task 1: Add Dependencies

**Files:**
- Modify: `pubspec.yaml`

- [ ] **Step 1: Add hive and hive_flutter to pubspec.yaml**

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  webview_flutter: ^4.13.1
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  google_fonts: ^6.2.1
```

- [ ] **Step 2: Run flutter pub get**

Run: `flutter pub get`
Expected: "Got dependencies!" with no errors

- [ ] **Step 3: Add internet permission for Google Fonts**

In `android/app/src/main/AndroidManifest.xml`, add before `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

Also change app label to "StarryMind":

```xml
android:label="StarryMind"
```

- [ ] **Step 4: Commit**

```bash
git add pubspec.yaml pubspec.lock android/app/src/main/AndroidManifest.xml
git commit -m "feat: add hive, google_fonts dependencies and internet permission"
```

---

### Task 2: Cream Universe Theme

**Files:**
- Modify: `lib/core/theme/app_theme.dart`

- [ ] **Step 1: Rewrite AppTheme to cream universe**

Replace entire file with:

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Design system tokens
  static const creamCanvas = Color(0xFFF6F1E1);
  static const creamVoid = Color(0xFFEBE6D4);
  static const creamPaper = Color(0xFFFAF6EA);
  static const creamPaper2 = Color(0xFFFDFAF1);
  static const creamHover = Color(0xFFF2ECD8);
  static const creamPress = Color(0xFFEAE2C9);

  static const ink900 = Color(0xFF1D2140);
  static const ink700 = Color(0xFF2E3458);
  static const ink500 = Color(0xFF5A6086);
  static const ink400 = Color(0xFF878CAC);
  static const ink300 = Color(0xFFB4B7C8);

  static const starGold = Color(0xFFC9934B);
  static const starGoldSoft = Color(0xFFE0B775);
  static const plum = Color(0xFF7D5A8E);
  static const sage = Color(0xFF7A9080);
  static const ember = Color(0xFFC8704E);
  static const indigoCool = Color(0xFF6A7BB0);

  static ThemeData build() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: starGold,
      brightness: Brightness.light,
    ).copyWith(
      primary: starGold,
      onPrimary: creamPaper,
      secondary: plum,
      tertiary: sage,
      surface: creamPaper,
      onSurface: ink900,
      outline: ink300,
    );

    final displayFont = GoogleFonts.cormorantGaramondTextTheme();
    final uiFont = GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: creamCanvas,
      textTheme: TextTheme(
        headlineLarge: displayFont.headlineLarge?.copyWith(
          fontSize: 36, fontWeight: FontWeight.w500,
          letterSpacing: -0.8, height: 1.15, color: ink900,
        ),
        headlineMedium: displayFont.headlineMedium?.copyWith(
          fontSize: 24, fontWeight: FontWeight.w500,
          letterSpacing: -0.4, color: ink900,
        ),
        titleLarge: displayFont.titleLarge?.copyWith(
          fontSize: 18, fontWeight: FontWeight.w600, color: ink900,
        ),
        titleMedium: uiFont.titleMedium?.copyWith(
          fontSize: 14, fontWeight: FontWeight.w500, color: ink500,
        ),
        bodyLarge: displayFont.bodyLarge?.copyWith(
          fontSize: 16, height: 1.6, color: ink700,
        ),
        bodyMedium: displayFont.bodyMedium?.copyWith(
          fontSize: 14, height: 1.5, color: ink500,
        ),
        bodySmall: uiFont.bodySmall?.copyWith(
          fontSize: 11, letterSpacing: 0.14 * 11,
          fontWeight: FontWeight.w500, color: ink400,
        ),
        labelSmall: uiFont.labelSmall?.copyWith(
          fontSize: 10, letterSpacing: 1.4,
          fontWeight: FontWeight.w500, color: ink400,
        ),
      ),
      dividerColor: ink900.withValues(alpha: 0.08),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: creamVoid.withValues(alpha: 0.5),
        hintStyle: TextStyle(
          fontStyle: FontStyle.italic, color: ink400,
          fontFamily: GoogleFonts.cormorantGaramond().fontFamily,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: ink900.withValues(alpha: 0.10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: ink900.withValues(alpha: 0.10)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: starGold.withValues(alpha: 0.50)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: starGold,
          foregroundColor: creamPaper,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          textStyle: uiFont.labelLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Verify no analysis errors**

Run: `flutter analyze`
Expected: No issues found

- [ ] **Step 3: Commit**

```bash
git add lib/core/theme/app_theme.dart
git commit -m "feat: rewrite theme to cream-universe design system"
```

---

### Task 3: Cream Starfield Backdrop

**Files:**
- Modify: `lib/shared/presentation/widgets/starfield_backdrop.dart`

- [ ] **Step 1: Rewrite to cream universe**

Replace entire file:

```dart
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:starry_mind/core/theme/app_theme.dart';

class StarfieldBackdrop extends StatelessWidget {
  const StarfieldBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: _BackgroundGradient()),
        const Positioned(
          top: -80,
          left: -40,
          child: _GlowOrb(size: 260, color: Color(0x24C9934B)),
        ),
        const Positioned(
          right: -60,
          top: 200,
          child: _GlowOrb(size: 220, color: Color(0x1A7D5A8E)),
        ),
        const Positioned(
          bottom: -60,
          left: 80,
          child: _GlowOrb(size: 240, color: Color(0x1A7A9080)),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(painter: _StarfieldPainter()),
          ),
        ),
        child,
      ],
    );
  }
}

class _BackgroundGradient extends StatelessWidget {
  const _BackgroundGradient();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.3),
          radius: 1.2,
          colors: [
            AppTheme.creamPaper2,
            AppTheme.creamCanvas,
            AppTheme.creamVoid,
          ],
          stops: [0, 0.5, 1],
        ),
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}

class _StarfieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var index = 0; index < 100; index++) {
      final x = _hash(index * 17 + 1) * size.width;
      final y = _hash(index * 31 + 3) * size.height;
      final radius = 0.4 + _hash(index * 53 + 7) * 1.2;
      final alpha = 0.08 + _hash(index * 71 + 11) * 0.18;
      paint.color = AppTheme.ink900.withValues(alpha: alpha);
      canvas.drawCircle(Offset(x, y), radius, paint);

      if (index % 11 == 0) {
        final glowPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = AppTheme.starGold.withValues(alpha: 0.12);
        canvas.drawCircle(Offset(x, y), radius * 3.0, glowPaint);
      }
    }
  }

  double _hash(int seed) {
    final value = math.sin(seed * 12.9898) * 43758.5453;
    return value - value.floorToDouble();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/shared/presentation/widgets/starfield_backdrop.dart
git commit -m "feat: cream-universe starfield backdrop with ink dots and gold halos"
```

---

### Task 4: Cream Frosted Panel

**Files:**
- Modify: `lib/shared/presentation/widgets/frosted_panel.dart`

- [ ] **Step 1: Rewrite to cream-glass**

Replace entire file:

```dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:starry_mind/core/theme/app_theme.dart';

class FrostedPanel extends StatelessWidget {
  const FrostedPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 20,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xD1FDFAF1), // cream-paper-2 at ~82%
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: AppTheme.ink900.withValues(alpha: 0.10)),
            boxShadow: [
              BoxShadow(
                color: AppTheme.ink900.withValues(alpha: 0.14),
                blurRadius: 28,
                offset: const Offset(0, 12),
                spreadRadius: -12,
              ),
            ],
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/shared/presentation/widgets/frosted_panel.dart
git commit -m "feat: cream-glass frosted panel with backdrop blur"
```

---

### Task 5: Cream Three.js Renderer

**Files:**
- Modify: `assets/web/galaxy_mvp.html`

- [ ] **Step 1: Rewrite HTML to cream universe**

Replace entire file with cream-themed Three.js scene. Key changes from dark version:
- Background: cream gradient (`#f6f1e1`) instead of dark space
- Body colors: use sentiment palette (amber, plum, sage, cobalt) instead of satellite/planet/star fixed colors
- Lights: warm ambient, soft directional instead of cold point lights
- Fog: cream-tinted
- Starfield: small ink dots instead of white particles
- Glow: gold halos instead of color-matched glow

```html
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <title>StarryMind Galaxy</title>
    <style>
      html, body {
        margin: 0; width: 100%; height: 100%; overflow: hidden;
        background: radial-gradient(circle at 30% 20%, #fdfaf1, #f6f1e1 50%, #ebe6d4);
        touch-action: none;
      }
      #scene { width: 100%; height: 100%; display: block; }
    </style>
    <script src="vendor/three.min.js"></script>
    <script src="vendor/OrbitControls.js"></script>
  </head>
  <body>
    <canvas id="scene"></canvas>
    <script>
      (function () {
        var palette = {
          satellite: 0xc9934b,
          planet:    0x7d5a8e,
          star:      0xc9934b,
        };
        var glowColor = 0xc9934b;
        var baseSize = { satellite: 0.52, planet: 0.88, star: 1.28 };

        var state = {
          scene: null, camera: null, renderer: null, controls: null,
          root: null, starfield: null,
          raycaster: new THREE.Raycaster(),
          pointer: new THREE.Vector2(),
          bodies: new Map(), selectedId: null, animations: [],
        };

        function notifyReady() {
          if (window.StarryMindReady) window.StarryMindReady.postMessage("ready");
        }
        function notifySelected(id) {
          if (window.StarryMindBodySelected) window.StarryMindBodySelected.postMessage(JSON.stringify({ id: id }));
        }

        function worldPosition(p) {
          return new THREE.Vector3(p.x * 18, p.y * 12, p.z * 16);
        }
        function sizeForBody(b) {
          return baseSize[b.type] * (0.88 + b.intensity * 0.42);
        }

        function createNebula(scene) {
          var nebulae = [
            { color: 0xc9934b, pos: [-12, 8, -16], size: 14, opacity: 0.06 },
            { color: 0x7d5a8e, pos: [14, 4, -10], size: 11, opacity: 0.05 },
            { color: 0x7a9080, pos: [-6, -10, -18], size: 13, opacity: 0.04 },
          ];
          nebulae.forEach(function (e) {
            var mat = new THREE.SpriteMaterial({ color: e.color, opacity: e.opacity, transparent: true });
            var sp = new THREE.Sprite(mat);
            sp.position.set(e.pos[0], e.pos[1], e.pos[2]);
            sp.scale.set(e.size, e.size, 1);
            scene.add(sp);
          });
        }

        function createStarfield(scene) {
          var geo = new THREE.BufferGeometry();
          var pos = [];
          for (var i = 0; i < 600; i++) {
            pos.push((Math.random() - 0.5) * 120);
            pos.push((Math.random() - 0.5) * 80);
            pos.push(-8 - Math.random() * 100);
          }
          geo.setAttribute("position", new THREE.Float32BufferAttribute(pos, 3));
          var mat = new THREE.PointsMaterial({ color: 0x1d2140, size: 0.18, transparent: true, opacity: 0.15 });
          var pts = new THREE.Points(geo, mat);
          scene.add(pts);
          state.starfield = pts;
        }

        function buildBody(body) {
          var color = palette[body.type] || 0xc9934b;
          var size = sizeForBody(body);
          var group = new THREE.Group();
          var target = worldPosition(body.position);

          var glow = new THREE.Mesh(
            new THREE.SphereGeometry(size * 2.0, 24, 24),
            new THREE.MeshBasicMaterial({ color: glowColor, transparent: true, opacity: 0.08 })
          );
          group.add(glow);

          var sphere = new THREE.Mesh(
            new THREE.SphereGeometry(size, 32, 32),
            new THREE.MeshStandardMaterial({
              color: color, emissive: color,
              emissiveIntensity: body.type === "star" ? 0.5 : 0.25,
              roughness: 0.45, metalness: 0.04,
            })
          );
          group.add(sphere);

          if (body.type === "satellite") {
            var ring = new THREE.Mesh(
              new THREE.TorusGeometry(size * 1.75, size * 0.04, 8, 48),
              new THREE.MeshBasicMaterial({ color: 0x1d2140, transparent: true, opacity: 0.12 })
            );
            ring.rotation.x = Math.PI / 2.8;
            group.add(ring);
          }

          group.userData = { id: body.id };
          group.position.copy(target);
          state.root.add(group);
          state.bodies.set(body.id, {
            body: body, group: group, sphere: sphere, glow: glow,
            basePosition: target,
            rotationSpeed: 0.002 + Math.random() * 0.004,
            floatSeed: Math.random() * Math.PI * 2,
          });
          return target;
        }

        function clearBodies() {
          state.bodies.forEach(function (e) { state.root.remove(e.group); });
          state.bodies.clear();
          state.selectedId = null;
          state.animations = [];
        }

        function setSelectedBody(id) {
          state.selectedId = id;
          state.bodies.forEach(function (entry, eid) {
            var active = eid === id;
            entry.group.userData.targetScale = active ? 1.15 : 1;
            entry.glow.material.opacity = active ? 0.18 : 0.08;
            entry.sphere.material.emissiveIntensity = active
              ? (entry.body.type === "star" ? 0.9 : 0.6)
              : (entry.body.type === "star" ? 0.5 : 0.25);
          });
        }

        function bootstrap(bodies) {
          clearBodies();
          bodies.forEach(function (b) { buildBody(b); });
          if (bodies.length > 0) setSelectedBody(bodies[0].id);
        }

        function addBody(body) {
          if (state.bodies.has(body.id)) return;
          var target = buildBody(body);
          var entry = state.bodies.get(body.id);
          entry.group.position.set(0, 0, 22);
          entry.group.scale.setScalar(0.02);
          state.animations.push({
            id: body.id, start: performance.now(), duration: 900,
            from: new THREE.Vector3(0, 0, 22), to: target.clone(),
          });
          setSelectedBody(body.id);
        }

        function selectBody(id) {
          if (!state.bodies.has(id)) return;
          setSelectedBody(id);
        }

        function onResize() {
          state.camera.aspect = window.innerWidth / window.innerHeight;
          state.camera.updateProjectionMatrix();
          state.renderer.setSize(window.innerWidth, window.innerHeight);
          state.renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, 2));
        }

        function onCanvasClick(event) {
          var rect = state.renderer.domElement.getBoundingClientRect();
          state.pointer.x = ((event.clientX - rect.left) / rect.width) * 2 - 1;
          state.pointer.y = -((event.clientY - rect.top) / rect.height) * 2 + 1;
          state.raycaster.setFromCamera(state.pointer, state.camera);
          var meshes = [];
          state.bodies.forEach(function (e) { meshes.push(e.sphere); });
          var hits = state.raycaster.intersectObjects(meshes, false);
          if (!hits.length) return;
          var mesh = hits[0].object;
          var found = null;
          state.bodies.forEach(function (e, eid) { if (e.sphere === mesh) found = eid; });
          if (!found) return;
          setSelectedBody(found);
          notifySelected(found);
        }

        function animateFrame(now) {
          requestAnimationFrame(animateFrame);
          state.controls.update();
          if (state.starfield) state.starfield.rotation.y += 0.0002;

          state.bodies.forEach(function (entry) {
            entry.sphere.rotation.y += entry.rotationSpeed;
            entry.sphere.rotation.x += entry.rotationSpeed * 0.3;
            var floatY = Math.sin(now * 0.0008 + entry.floatSeed) * 0.14;
            entry.group.position.x += (entry.basePosition.x - entry.group.position.x) * 0.06;
            entry.group.position.y += (entry.basePosition.y + floatY - entry.group.position.y) * 0.06;
            entry.group.position.z += (entry.basePosition.z - entry.group.position.z) * 0.06;
            var ts = entry.group.userData.targetScale || 1;
            var ns = entry.group.scale.x + (ts - entry.group.scale.x) * 0.12;
            entry.group.scale.setScalar(ns);
          });

          state.animations = state.animations.filter(function (a) {
            var entry = state.bodies.get(a.id);
            if (!entry) return false;
            var p = Math.min((now - a.start) / a.duration, 1);
            var e = 1 - Math.pow(1 - p, 3);
            entry.group.position.lerpVectors(a.from, a.to, e);
            entry.group.scale.setScalar(0.02 + e * 0.98);
            return p < 1;
          });

          state.renderer.render(state.scene, state.camera);
        }

        function init() {
          var canvas = document.getElementById("scene");
          state.renderer = new THREE.WebGLRenderer({ canvas: canvas, antialias: true, alpha: true });
          state.renderer.setClearColor(0xf6f1e1, 1);
          state.renderer.setSize(window.innerWidth, window.innerHeight);
          state.renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, 2));

          state.scene = new THREE.Scene();
          state.scene.fog = new THREE.FogExp2(0xf6f1e1, 0.012);

          state.camera = new THREE.PerspectiveCamera(54, window.innerWidth / window.innerHeight, 0.1, 180);
          state.camera.position.set(0, 5, 24);

          state.controls = new THREE.OrbitControls(state.camera, state.renderer.domElement);
          state.controls.enableDamping = true;
          state.controls.dampingFactor = 0.045;
          state.controls.enablePan = false;
          state.controls.rotateSpeed = 0.58;
          state.controls.zoomSpeed = 0.88;
          state.controls.minDistance = 10;
          state.controls.maxDistance = 40;

          state.scene.add(new THREE.AmbientLight(0xf6f1e1, 1.8));
          var keyLight = new THREE.DirectionalLight(0xfdf0d5, 0.9);
          keyLight.position.set(10, 14, 12);
          state.scene.add(keyLight);
          var fillLight = new THREE.DirectionalLight(0xe0d4c0, 0.4);
          fillLight.position.set(-8, -4, 10);
          state.scene.add(fillLight);

          state.root = new THREE.Group();
          state.scene.add(state.root);
          createNebula(state.scene);
          createStarfield(state.scene);

          state.renderer.domElement.addEventListener("click", onCanvasClick);
          window.addEventListener("resize", onResize);

          window.StarryMindBridge = { bootstrap: bootstrap, addBody: addBody, selectBody: selectBody };
          requestAnimationFrame(animateFrame);
          notifyReady();
        }

        init();
      })();
    </script>
  </body>
</html>
```

- [ ] **Step 2: Commit**

```bash
git add assets/web/galaxy_mvp.html
git commit -m "feat: cream-universe Three.js renderer with warm lights and ink dots"
```

---

### Task 6: Data Model with Persistence Support

**Files:**
- Modify: `lib/features/galaxy/domain/models/celestial_body.dart`

- [ ] **Step 1: Add JSON serialization for Hive storage**

Replace entire file:

```dart
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
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/galaxy/domain/models/celestial_body.dart
git commit -m "feat: add JSON serialization to CelestialBody for persistence"
```

---

### Task 7: Hive Storage Layer

**Files:**
- Create: `lib/core/storage/hive_storage.dart`

- [ ] **Step 1: Create Hive storage service**

```dart
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
```

- [ ] **Step 2: Commit**

```bash
git add lib/core/storage/hive_storage.dart
git commit -m "feat: add Hive storage layer for celestial body persistence"
```

---

### Task 8: Local Repository Implementation

**Files:**
- Modify: `lib/features/galaxy/domain/repositories/galaxy_repository.dart`
- Create: `lib/features/galaxy/data/local/local_galaxy_repository.dart`

- [ ] **Step 1: Extend repository interface**

Replace `galaxy_repository.dart`:

```dart
import 'package:starry_mind/features/galaxy/domain/models/celestial_body.dart';

abstract class GalaxyRepository {
  Future<List<CelestialBody>> loadAll();
  Future<void> save(CelestialBody body);
  Future<void> delete(String id);
}
```

- [ ] **Step 2: Create local repository**

```dart
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
```

- [ ] **Step 3: Update MockGalaxyRepository to expose seeds as static**

In `mock_galaxy_repository.dart`, change the class:

Replace `class MockGalaxyRepository implements GalaxyRepository {` and its `@override` method with:

```dart
class MockGalaxyRepository {
  static List<CelestialBody> seedBodies() {
    return [
```

And close with:
```dart
    ];
  }
}
```

Remove the `implements GalaxyRepository` and the `@override` annotation. The rest of the body list stays identical.

- [ ] **Step 4: Commit**

```bash
git add lib/features/galaxy/domain/repositories/galaxy_repository.dart lib/features/galaxy/data/local/local_galaxy_repository.dart lib/features/galaxy/data/mock/mock_galaxy_repository.dart
git commit -m "feat: local Hive-backed repository with seed data on first launch"
```

---

### Task 9: Wire Persistence into Controller

**Files:**
- Modify: `lib/features/galaxy/application/galaxy_controller.dart`

- [ ] **Step 1: Update controller for persistence**

Replace entire file:

```dart
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
```

Note: `submitThought` is now `Future<void>` (was `void`).

- [ ] **Step 2: Commit**

```bash
git add lib/features/galaxy/application/galaxy_controller.dart
git commit -m "feat: wire persistence into controller — save on submit, delete support"
```

---

### Task 10: App Initialization with Hive

**Files:**
- Modify: `lib/main.dart`
- Modify: `lib/app/starry_mind_app.dart`

- [ ] **Step 1: Update main.dart for async Hive init**

```dart
import 'package:flutter/material.dart';
import 'package:starry_mind/app/starry_mind_app.dart';
import 'package:starry_mind/core/storage/hive_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveStorage.init();
  runApp(const StarryMindApp());
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/main.dart
git commit -m "feat: async Hive initialization before app launch"
```

---

### Task 11: Redesign Home Page — Sky-First UX

**Files:**
- Modify: `lib/features/galaxy/presentation/pages/galaxy_home_page.dart`

- [ ] **Step 1: Rewrite home page for user-facing sky experience**

Replace entire file. Removes developer dashboard header and status panel. Full-bleed sky with floating glass input dock:

```dart
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:starry_mind/core/theme/app_theme.dart';
import 'package:starry_mind/features/galaxy/application/galaxy_controller.dart';
import 'package:starry_mind/features/galaxy/data/local/local_galaxy_repository.dart';
import 'package:starry_mind/features/galaxy/presentation/widgets/celestial_body_detail_panel.dart';
import 'package:starry_mind/features/galaxy/presentation/widgets/galaxy_render_surface.dart';
import 'package:starry_mind/features/galaxy/presentation/widgets/thought_composer.dart';
import 'package:starry_mind/shared/presentation/widgets/frosted_panel.dart';
import 'package:starry_mind/shared/presentation/widgets/starfield_backdrop.dart';

class GalaxyHomePage extends StatefulWidget {
  const GalaxyHomePage({super.key});

  @override
  State<GalaxyHomePage> createState() => _GalaxyHomePageState();
}

class _GalaxyHomePageState extends State<GalaxyHomePage> {
  late final GalaxyController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GalaxyController(repository: LocalGalaxyRepository())
      ..bootstrap();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          body: StarfieldBackdrop(
            child: SafeArea(
              child: _controller.isBootstrapping
                  ? const Center(child: _PulsingStar())
                  : Stack(
                      children: [
                        // Full-bleed 3D sky
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 100),
                            child: GalaxyRenderSurface(
                              bodies: _controller.bodies,
                              selectedBody: _controller.selectedBody,
                              onBodySelected: _handleBodySelected,
                            ),
                          ),
                        ),
                        // Top bar: title + stats
                        Positioned(
                          top: 12,
                          left: 16,
                          right: 16,
                          child: _TopBar(controller: _controller),
                        ),
                        // Bottom: input dock
                        Positioned(
                          bottom: 8,
                          left: 12,
                          right: 12,
                          child: ThoughtComposer(
                            controller: _controller.composerController,
                            onSubmit: _controller.submitThought,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  void _handleBodySelected(String id) {
    _controller.selectBodyById(id);
    final body = _controller.selectedBody;
    if (body == null) return;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
          child: SizedBox(
            height: math.min(MediaQuery.of(context).size.height * 0.52, 400),
            child: CelestialBodyDetailPanel(
              body: body,
              onDelete: () {
                Navigator.of(context).pop();
                _controller.deleteBody(body.id);
              },
            ),
          ),
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.controller});

  final GalaxyController controller;

  @override
  Widget build(BuildContext context) {
    return FrostedPanel(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 999,
      child: Row(
        children: [
          Container(
            width: 8, height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.starGold,
              boxShadow: [BoxShadow(color: AppTheme.starGold.withValues(alpha: 0.5), blurRadius: 8)],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              controller.activeCluster.isEmpty
                  ? '星空尚静'
                  : controller.activeCluster,
              style: TextStyle(
                fontFamily: 'Cormorant Garamond',
                fontStyle: FontStyle.italic,
                fontSize: 15,
                color: AppTheme.ink900,
              ),
            ),
          ),
          _StatChip('${controller.totalBodies}'),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: AppTheme.ink900.withValues(alpha: 0.06),
        border: Border.all(color: AppTheme.ink900.withValues(alpha: 0.10)),
      ),
      child: Text(
        value,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12, fontWeight: FontWeight.w500,
          color: AppTheme.ink500,
        ),
      ),
    );
  }
}

class _PulsingStar extends StatefulWidget {
  const _PulsingStar();

  @override
  State<_PulsingStar> createState() => _PulsingStarState();
}

class _PulsingStarState extends State<_PulsingStar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        final opacity = 0.4 + _anim.value * 0.6;
        return Container(
          width: 16, height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.starGold.withValues(alpha: opacity),
            boxShadow: [
              BoxShadow(
                color: AppTheme.starGold.withValues(alpha: opacity * 0.5),
                blurRadius: 24,
              ),
            ],
          ),
        );
      },
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/galaxy/presentation/pages/galaxy_home_page.dart
git commit -m "feat: redesign home page — full-bleed sky with floating glass chrome"
```

---

### Task 12: Update Remaining Widgets for Cream Theme

**Files:**
- Modify: `lib/features/galaxy/presentation/widgets/galaxy_render_surface.dart`
- Modify: `lib/features/galaxy/presentation/widgets/celestial_body_detail_panel.dart`
- Modify: `lib/features/galaxy/presentation/widgets/thought_composer.dart`
- Modify: `lib/features/galaxy/presentation/widgets/galaxy_status_panel.dart`

- [ ] **Step 1: Update GalaxyRenderSurface**

Replace entire `galaxy_render_surface.dart`:

```dart
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
                child: Center(
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
```

- [ ] **Step 2: Update CelestialBodyDetailPanel**

Replace entire `celestial_body_detail_panel.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:starry_mind/core/theme/app_theme.dart';
import 'package:starry_mind/features/galaxy/domain/models/celestial_body.dart';
import 'package:starry_mind/shared/presentation/widgets/frosted_panel.dart';

class CelestialBodyDetailPanel extends StatelessWidget {
  const CelestialBodyDetailPanel({
    super.key,
    required this.body,
    this.onDelete,
  });

  final CelestialBody? body;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    if (body == null) return const SizedBox.shrink();

    return FrostedPanel(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _Tag(body!.type.label),
                const SizedBox(width: 8),
                _Tag(body!.cluster),
                const Spacer(),
                if (onDelete != null)
                  GestureDetector(
                    onTap: onDelete,
                    child: Text(
                      'let go',
                      style: TextStyle(
                        fontFamily: 'Cormorant Garamond',
                        fontStyle: FontStyle.italic,
                        fontSize: 13, color: AppTheme.ember,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              body!.title,
              style: const TextStyle(
                fontFamily: 'Cormorant Garamond',
                fontSize: 22, fontWeight: FontWeight.w500,
                color: AppTheme.ink900, height: 1.3,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _formatDateTime(body!.createdAt),
              style: const TextStyle(
                fontFamily: 'Inter', fontSize: 11,
                color: AppTheme.ink400,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              body!.content,
              style: const TextStyle(
                fontFamily: 'Cormorant Garamond',
                fontSize: 16, height: 1.7, color: AppTheme.ink700,
              ),
            ),
            if (body!.tags.isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: body!.tags.map((t) => _Tag('#$t')).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: AppTheme.ink900.withValues(alpha: 0.05),
        border: Border.all(color: AppTheme.ink900.withValues(alpha: 0.10)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Inter', fontSize: 11,
          color: AppTheme.ink500, letterSpacing: 0.5,
        ),
      ),
    );
  }
}
```

- [ ] **Step 3: Update ThoughtComposer**

Replace entire `thought_composer.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:starry_mind/core/theme/app_theme.dart';
import 'package:starry_mind/shared/presentation/widgets/frosted_panel.dart';

class ThoughtComposer extends StatelessWidget {
  const ThoughtComposer({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return FrostedPanel(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      borderRadius: 999,
      child: Row(
        children: [
          Icon(Icons.star_rounded, size: 18, color: AppTheme.starGold),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 3,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSubmit(),
              style: const TextStyle(
                fontFamily: 'Cormorant Garamond',
                fontStyle: FontStyle.italic,
                fontSize: 15, color: AppTheme.ink900,
              ),
              decoration: const InputDecoration(
                hintText: 'Whatever crosses your mind —',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onSubmit,
            child: Text(
              'enter',
              style: TextStyle(
                fontFamily: 'Cormorant Garamond',
                fontStyle: FontStyle.italic,
                fontSize: 13,
                color: AppTheme.starGold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Delete galaxy_status_panel.dart (no longer used)**

The status panel was part of the developer dashboard. Remove it:

```bash
rm lib/features/galaxy/presentation/widgets/galaxy_status_panel.dart
```

- [ ] **Step 5: Verify analysis**

Run: `flutter analyze`
Expected: No issues found

- [ ] **Step 6: Commit**

```bash
git add -A
git commit -m "feat: cream-theme all widgets — render surface, detail panel, composer; remove status panel"
```

---

### Task 13: Update Tests

**Files:**
- Modify: `test/widget_test.dart`

- [ ] **Step 1: Update tests for new interfaces**

Replace entire file:

```dart
import 'package:test/test.dart';
import 'package:starry_mind/features/galaxy/domain/models/celestial_body.dart';
import 'package:starry_mind/features/galaxy/domain/services/thought_draft_analyzer.dart';
import 'package:starry_mind/features/galaxy/data/mock/mock_galaxy_repository.dart';

void main() {
  group('ThoughtDraftAnalyzer', () {
    const analyzer = ThoughtDraftAnalyzer();

    test('short input resolves to satellite', () {
      expect(analyzer.resolveType('quick note'), CelestialBodyType.satellite);
    });

    test('keyword maps to correct cluster', () {
      expect(analyzer.deriveCluster('WebView bridge'), '渲染桥接');
    });

    test('derives tags from content', () {
      final tags = analyzer.deriveTags('WebView 3D rendering');
      expect(tags, containsAll(['webview', '3d']));
    });
  });

  group('MockGalaxyRepository', () {
    test('provides at least 20 seed bodies', () {
      final seeds = MockGalaxyRepository.seedBodies();
      expect(seeds.length, greaterThanOrEqualTo(20));
    });

    test('first seed has correct title', () {
      final seeds = MockGalaxyRepository.seedBodies();
      expect(seeds.first.title, '向量引力引擎');
    });

    test('contains at least one star', () {
      final seeds = MockGalaxyRepository.seedBodies();
      expect(seeds.any((b) => b.type == CelestialBodyType.star), isTrue);
    });
  });

  group('CelestialBody JSON', () {
    test('roundtrip serialization', () {
      final body = CelestialBody(
        id: 'test-1',
        title: 'Test',
        content: 'Hello world',
        type: CelestialBodyType.planet,
        position: SpacePoint(x: 0.1, y: 0.2, z: 0.3),
        createdAt: DateTime(2026, 5, 18),
        cluster: 'test',
        tags: ['a', 'b'],
        intensity: 0.7,
      );
      final json = body.toJson();
      final restored = CelestialBody.fromJson(json);
      expect(restored.id, body.id);
      expect(restored.title, body.title);
      expect(restored.type, body.type);
      expect(restored.position.x, body.position.x);
      expect(restored.tags, body.tags);
      expect(restored.intensity, body.intensity);
    });
  });
}
```

- [ ] **Step 2: Run tests**

Run: `dart test test/widget_test.dart`
Expected: All tests pass

- [ ] **Step 3: Commit**

```bash
git add test/widget_test.dart
git commit -m "test: update tests for new interfaces and add JSON roundtrip test"
```

---

### Task 14: Build Release APK

- [ ] **Step 1: Run flutter analyze one final time**

Run: `flutter analyze`
Expected: No issues found

- [ ] **Step 2: Build release APK**

Run: `flutter build apk --release`
Expected: Build completes with `build/app/outputs/flutter-apk/app-release.apk`

- [ ] **Step 3: Copy APK to desktop**

```bash
cp build/app/outputs/flutter-apk/app-release.apk /Users/ltc/Desktop/starrymind.apk
```

- [ ] **Step 4: Commit all remaining changes and push**

```bash
git add -A
git commit -m "chore: release build configuration"
git push origin feat/design-system
```
