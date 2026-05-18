# Starrymind Design System

> _灵感星图 · StarryMind_
>
> 抛弃传统树状目录与连线式知识图谱的繁琐维护。利用 AI 将碎片化的念头转化为多维向量，在 3D 空间中通过"引力"自动完成相似思维的聚类，形成动态生长的个人灵感星系。

---

## 1. What is Starrymind?

**灵感星图 / StarryMind** is a micro-SaaS for reflective thought management built on **LLM vector semantics** and **3D visual interaction**. Fragmented thoughts are embedded as high-dimensional vectors and rendered as celestial bodies in a live 3D universe — related ideas pull toward one another by semantic gravity and slowly collapse into visible constellations.

- **Category:** Personal thought management, micro-SaaS
- **Platforms:** Mobile-first (iOS/Android via hybrid Flutter + WebGL); web companion
- **Audience:** Reflective individuals — journalers, writers, thinkers
- **Tone:** Contemplative, literary, unhurried. Never clinical, never hype.

### The core metaphor

Every thought is a **celestial body** (天体). AI assigns its scale from text length + depth:

| Entity              | Criterion                       | Appearance                                              |
|---------------------|---------------------------------|---------------------------------------------------------|
| **Satellite** 卫星  | < 100 字 · fragment             | Small, low luminosity, orbits a planet or star          |
| **Planet** 行星     | 100–500 字 · reflection         | Mid-size, hue driven by sentiment analysis              |
| **Star** 恒星       | > 500 字 · long-form anchor     | Largest, animated glow + breathing halo                 |

### Gravity as meaning

Per-input embeddings (e.g. `text-embedding-3-small`). Cosine similarity → semantic gravity; universal repulsion prevents overlap. Equilibrium yields **constellation collapse** — emergent clusters with glowing connective arcs. No manual tagging, no manual edges.

## 2. Sources

Created from scratch on 2026-04-21 against the provided **PRD v1.1** (`uploads/PRD.md`). No codebase, Figma, or brand assets were attached. All marks, illustrations, and tokens are bespoke.

- **PRD:** `uploads/PRD.md` (StarryMind PRD v1.1)
- **Codebase / Figma:** none provided
- **Fonts:** Google-Fonts substitutes (Cormorant Garamond, Noto Serif SC, Inter, Noto Sans SC, JetBrains Mono) — swap when licensed fonts are acquired.

## 3. Index

| File / folder          | What's in it                                                     |
|------------------------|------------------------------------------------------------------|
| `README.md`            | This file — brand, content, visual & iconography guidelines      |
| `SKILL.md`             | Agent-skill manifest (portable to Claude Code)                   |
| `colors_and_type.css`  | All color + type tokens as CSS custom properties                 |
| `assets/`              | Logo marks, constellation illustrations, starfield, paper grain  |
| `preview/`             | Design-system preview cards (colors, type, spacing, components)  |
| `ui_kits/mobile/`      | Mobile UI kit — iOS frame, components, core screens              |

## 4. Content fundamentals

Starrymind speaks the way a late-night journal speaks to itself: quiet, unhurried, a little literary.

**Voice**
- **Contemplative, not cheerful.** "Tonight your thoughts orbited _memory_."  Never "You've been super productive today! 🎉"
- **Observational, not prescriptive.** The product _notices_; it does not _instruct_.
- **Poetic, grounded.** One metaphor per sentence. Never purple.
- **Bilingual.** Primary copy is Simplified Chinese (literary-modern register, 书面化现代汉语); English parallels available. Same tone in both.

**Person & address**
- **"You"** (你) — gentle second person. Never "we."
- **Forbidden:** "users," "AI-powered," "supercharge," "unleash," marketing exclamations, emoji in UI chrome.

**Casing & punctuation**
- Titles & buttons: **sentence case**, no trailing period. (_"Record a thought"_ · _"See the sky"_)
- Eyebrows / meta: ALL CAPS, wide tracking (`--tracking-wide`), chrome only.
- Chinese: full-width punctuation （，。：、""）. Never mix half-width inside zh-CN strings.
- Em-dashes and ellipses are welcome — they match the rhythm.

**Copy examples**

| Context         | ✅ On-brand                                                                   | ❌ Off-brand                               |
|-----------------|------------------------------------------------------------------------------|-------------------------------------------|
| Empty state     | The sky is quiet. Begin with one thought.                                    | No data yet! Add your first item 🚀       |
| Empty (中)      | 星空尚静。从一念起。                                                         | 还没有内容哦，快添加吧！                 |
| AI reading      | Tonight your thoughts orbited _memory_. A small constellation formed near _regret_. | You mentioned memory 4 times this week. |
| Save            | Kept.                                                                        | Successfully saved! ✓                     |
| Delete          | Let this one go?                                                             | Are you sure you want to delete?          |
| Error           | The connection has drifted. Try again in a moment.                           | Oops! Something went wrong.               |

**Lengths**
- Headlines: 3–9 words, single idea.
- Sub-copy: 1–2 sentences, 20–40 words.
- **Star reading (AI):** 40–120 words, serif-set, italicized, present tense.
- Body: 17px serif (Cormorant Garamond), measure ~60 chars in prose surfaces.

## 5. Visual foundations

The product looks like **a cream-paper universe seen in the soft light of morning** — a pale, warm-white cosmos where thoughts are dark ink with golden halos. This is the signature reversal: _a sky made of paper instead of night._

### Canvas & surfaces
- **Cream is default.** `--bg-canvas` = `#f6f1e1` (cream canvas). Edges deepen to `#ebe6d4` (cream void). Raised surfaces lift to `#faf6ea` → `#fdfaf1`.
- **The Sky** is now a _milky cream universe_ — see `assets/bg-starfield.svg`. Stars are small dark-ink dots; accent stars have warm gold halos. Nebulae are barely-there washes of plum / gold / sage at 18–35 % α.
- **Glass panels** per PRD §5.1 become **frosted cream panels:** `backdrop-filter: blur(16px); background: rgba(253,250,241,0.7); border: 1px solid rgba(29,33,64,0.10);`. They float over the cream sky with a soft warm drop-shadow.
- **Paper grain** (`assets/bg-grain.svg`) overlays surfaces at **4–8 % α** to kill banding.
- **Gradients:** only radial, only very soft. Never linear SaaS hero gradients. Never dark → light washes.

### Color
- **Primary accent:** `--star-gold` (`#c9934b`). Deeper than the old night-sky gold — it must hold its own on cream. Use for primary CTA, starlight, active states. **One gold element per view** is usually right.
- **Ink:** `--ink-900` (`#1d2140`). A deep, slightly blue-violet indigo. All text, all line-art strokes, all satellite bodies sit in this ink family.
- **Sentiment tints** (PRD §2.1, on planets only, not on chrome): `--plum` `#7d5a8e` reflective · `--sage` `#7a9080` calm · `--ember` `#c8704e` tense · `--indigo-cool` `#6a7bb0` distant. Used as _material tint_ on planet bodies only.
- **Never** pure `#fff` or `#000`. Use `--cream-paper-2` / `--ink-900`.

### Typography
- **Display & body: Cormorant Garamond** (serif, weight 400/500; italic 400/500 for quotes). Tracking ~−1.5% on headlines. This is **one family for both display and running text** — the whole app reads like a paperback.
- **UI chrome: Inter** (`--font-ui`) — reserved for buttons, eyebrow labels, chips, metadata. Never for prose.
- **CJK fallback:** Noto Serif SC (display + body), Noto Sans SC (ui). Pre-chained in `colors_and_type.css`.
- **Mono:** JetBrains Mono — developer surfaces only.
- **Scale:** `--fs-*` tokens. Body minimum 14 px (dense) / 17 px (prose).
- **⚠ Substitution flag:** Cormorant Garamond & Inter are Google-Fonts placeholders; swap via `--font-display` / `--font-body` / `--font-ui`.

### Spacing & rhythm
- 4 px base grid. Tokens `--space-1` (4) → `--space-10` (128).
- Marketing breathes at `--space-8` / `--space-9` (64/96).
- App chrome is dense: `--space-2` → `--space-5`.

### Borders & cards
- Whisper-thin: `1px solid rgba(29,33,64,0.08–0.16)` on cream.
- **Cards** = `--bg-raised` (`#fdfaf1`) + `--border-2` + `--shadow-card` (warm soft drop).
- Radii: default `--radius-lg` (14 px); pills for chips; `--radius-sm` (4 px) in dense inputs. No hyper-rounding above 28 px.

### Shadows & glow
- Shadows are **warm and soft** on cream — see `--shadow-card` / `--shadow-raised` / `--shadow-pop`.
- **Stars still glow** — gold halos remain (`--glow-star-sm/md/lg`). The halo just sits on cream instead of indigo.
- Glow animates in on hover over `--dur-base` (280 ms).

### Motion
- **Easing:** `--ease-drift` for the 3D canvas (celestial, slow); `--ease-settle` for UI; linear only for scrubbers.
- **Durations:** quick 160 ms · base 280 ms · slow 600 ms · drift 1800 ms.
- **House entrance:** opacity 0→1 over 600 ms with a 4-px upward translate.
- **No bounces.** Motion is drift, settle, fade.
- **Ambient life:** stars emit a breathing halo (`--glow-star-md` opacity 40–80 % oscillating over 1.8 s). Planets self-rotate slowly.
- **Loading:** no spinners. A star pulses.

### Hover, press, focus
- **Hover:** `--bg-surface` → `--bg-hover` (slightly warmer cream). Primary CTA gold saturates + glow intensifies. No scale, no translate.
- **Press:** `--bg-press` (slightly deeper cream).
- **Focus:** 2-px `--border-accent` + 2-px offset. Always visible.
- **Active nav:** 2-px gold left rule + `--fg-1` text. No fill.
- **Raycaster hit** (PRD §5.3): hit body gains `--glow-star-md`; a floating cream-glass panel slides in at `--dur-base`.

### Layout
- Web marketing max 1120 px. App fluid, 1440 px cap. Prose cap ~680 px.
- **3D canvas always full-bleed.** Controls float above as cream-glass panels, bottom-anchored (input) + edge-anchored (nav, filter, reading).
- **Mobile:** glass input dock at bottom, safe-area padded; optional side sheet.

### Imagery & illustration
- **Hand-drawn constellation line art** in dark ink on cream. Lines are wobble-filtered — slightly sketched. See `assets/illus-constellation-*.svg`.
- **3D** only in the star-canvas. Minimal materials (emissive + subtle bloom). No fake PBR.
- **Photography:** avoid. If ever used: warm-toned, morning-forward, grain.

## 6. Iconography

Thin, 1.5-px stroke, outline-only — tuned to sit alongside the constellations' fine line art.

- **Primary set: [Lucide](https://lucide.dev) via CDN.** Stroke 1.5. Size 20 default / 16 dense / 24 prominent.
- **Brand-specific icons** (star, satellite, planet, constellation, astrolabe) live in `assets/icons/` when added. Same 1.5-px stroke, 24-box.
- **Never** emoji in product chrome. Emoji inside user-authored thought text are untouched.
- **Never** Unicode symbol chars (✓ ✗ →). Use proper SVGs.
- **No filled variants.**

```html
<script src="https://unpkg.com/lucide@latest"></script>
<i data-lucide="sparkles"></i>
<script>lucide.createIcons();</script>
```

**Standard vocabulary**

| Use                      | Lucide                |
|--------------------------|-----------------------|
| A thought / star         | `star`                |
| New thought              | `plus` / `sparkle`    |
| The sky view             | `sparkles`            |
| AI reading / divination  | `sparkles`            |
| Search                   | `search`              |
| Settings                 | `settings`            |
| Profile                  | `user`                |
| Close                    | `x`                   |
| Back                     | `arrow-left`          |
| Menu                     | `menu`                |
| Tag                      | `hash`                |
| Focus a body             | `scan-search`         |
| Filter sky               | `sliders-horizontal`  |

## 7. Theme notes

The original system was drafted as a **deep-night sky** (indigo + cream-white ink). The user pivoted to the **cream universe** as the default. The night theme is preserved as `[data-theme="deep-night"]` in `colors_and_type.css` for developer use, but is not a product-facing theme.
