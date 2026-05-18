# Starrymind — Agent Skill Manifest

When the user invokes this design system, you are expected to make designs for StarryMind — a reflective-journal / thought-mapping micro-SaaS. Read `README.md` before anything else.

## Non-negotiables

1. **The default aesthetic is a cream universe** (`--bg-canvas` = `#f6f1e1`), NOT a night sky. Dark ink (`--ink-900`) on warm cream. Stars are dark dots with gold halos. Do not revert to indigo backgrounds unless the user asks for `[data-theme="deep-night"]`.
2. **Serif is the body font**, not sans. Cormorant Garamond + Noto Serif SC for both display and prose. Inter is UI chrome only (buttons, chips, eyebrows).
3. **Bilingual copy.** Primary strings exist in Simplified Chinese (literary register); English parallels live alongside. Use full-width punctuation in zh-CN.
4. **No emoji in chrome. No exclamations. No "AI-powered."**  See README §4 for the forbidden list.
5. **Gold is precious.** One `--star-gold` element per view. Don't sprinkle it on five chips.
6. **No bounces, no pops, no spinners.** Motion is drift / settle / fade. For loading, pulse a star.
7. **Outline icons only, 1.5-px stroke.** Lucide via CDN. No filled variants, no emoji, no Unicode glyphs.

## Tokens

Always load `colors_and_type.css` first. Use CSS custom properties (`var(--fg-1)`, `var(--bg-canvas)`, `var(--star-gold)`, etc). Don't inline hex values except in illustration SVGs.

## Core surfaces

- **The Sky** — full-bleed cream canvas with stars/nebulae. Use `assets/bg-starfield.svg` as the backdrop.
- **Cream-glass panels** — floating controls over the Sky. `backdrop-filter: blur(16px); background: rgba(253,250,241,0.7); border: 1px solid rgba(29,33,64,0.10);`
- **The Paper** — reading surface for long notes. `--bg-raised` (`#fdfaf1`) on `--bg-canvas`, serif-set, generous line-height (1.7–1.75).

## Components already built

See `preview/*.html` for rendered cards. Reusable React components live in `ui_kits/mobile/components.jsx`:
- `Sky3D`, `CelestialBody`, `ConstellationLines`, `StarDust`
- `GlassPanel`, `GlassInputDock`
- `ThoughtPopover`, `StarReading`, `NoteReader`

## When in doubt

Ask: _would a late-night journaler find this quiet, or noisy?_ If noisy, simplify.
