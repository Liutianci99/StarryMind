# Mobile UI Kit — StarryMind

iOS device mock of the main product surface. Built per PRD §5.

## Screens

1. **The Sky** — full-bleed 3D canvas with glass input dock, glass header, filter chips, and tap-to-hit body popover. New text input → new celestial body lands in the sky.
2. **Star Reading** — AI interpretive card ("tonight's reading"), glass-panelled, italic serif.
3. **Note Reader** — focused reading state for a star/planet. Dark paper, serif display title, long-form body.

## Components

- `Sky3D` — starfield + nebulae + gravity lines + bodies
- `CelestialBody` — satellite / planet / star visual
- `GlassPanel`, `GlassInputDock` — glassmorphism floating chrome
- `ThoughtPopover` — raycaster-hit floating card
- `StarReading` — AI summary card
- `NoteReader` — focused long-form reading overlay

## Caveats

- The "3D" canvas is a 2D SVG/CSS mock — the real product uses Three.js/WebGL embedded in a Flutter WebView per PRD §4.2. Visual language is faithful; motion is simulated with CSS `@keyframes breathe`.
- iOS frame is a realistic scaffold, not pixel-perfect Apple-HIG. The status bar & home indicator are decorative.
