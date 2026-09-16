# Reading a Built Funnel

Some hosted funnel builders ship a finished funnel as **one self-contained HTML file** — flow,
copy, theme and analytics all minified into it. Read this when the brief is "rebuild / port /
restyle this funnel" and you have its live URL. It is the difference between re-typing a funnel
by eye off screenshots and lifting its real flow, real strings and real tokens in five minutes.

The selectors below were confirmed against a shipped funnel. Verify each one on the file in
front of you before relying on it — a builder can rename things between versions.

## Fetch the page, not the screenshots

```bash
curl -sL "https://<host>/<project-slug>/<funnel-slug>/" -o funnel.html
```

One file, typically 100–200 KB. Everything below is inside it unless noted.

## The four things worth extracting

### 1. Flow order — `STEPS`

```bash
grep -o 'STEPS=\[[^]]*\]' funnel.html
```

A plain array of screen names in order, e.g.
`["hero","hook","promise","petFor","message","petStyle","upload","social","processing","email","paywall","success"]`.
This is the funnel's real spine. Do not infer it from the Figma board — a board shows screens
laid out spatially, often including variants and dead ends that the shipped flow never reaches.

### 2. Copy — **not in the HTML**

This is the trap. Grepping the page for a headline you can see on screen returns nothing,
because every string is `t("key")` at render time. The page only carries the *accessor*:

```js
function t(k, vars) {
  var I = window.I18N || {}, d = I[L()] || {}, en = I.en || {};
  var s = d[k] != null ? d[k] : en[k] != null ? en[k] : k;   // falls back to the key itself
  if (vars) for (var p in vars) s = s.split("{" + p + "}").join(vars[p]);
  return s;
}
```

The table itself is a **separate file** referenced from the page — look for an i18n script in
the asset list (in the confirmed case `paywall-assets/fm-i18n.js`, served as
`window.I18N = {"en": { ... }}`). Fetch and dump it:

```bash
curl -sL "https://<host>/<project>/<funnel>/paywall-assets/fm-i18n.js" -o i18n.js
python -c "import json,sys; s=open('i18n.js',encoding='utf-8').read(); \
s=s[s.index('=')+1:].rstrip().rstrip(';'); d=json.loads(s); \
[print(k,'=',v) for k,v in d['en'].items()]"
```

Notes that matter:

- `{name}`-style placeholders are substituted from `vars` — keep them intact when you re-use a
  string, don't bake a sample value in.
- A missing key renders **as the key**, so `hero_h` appearing on screen means the table is
  stale, not that the copy is literally that.
- The table can carry keys for screens this funnel never shows (other funnels in the same
  project share it). Only trust keys the flow actually reaches.

### 3. Theme tokens — the **second** `:root{}`, not the first

```bash
grep -o ':root{[^}]*}' funnel.html
```

Expect two. The first is the platform default (generic grey/purple); the second is this
funnel's override and is the one you want — near the end of the main `<style>` block, not in a
separate one. In the confirmed case the two differed on almost every value: `--bg:#0f0f0f` →
`#0b0b0c`, `--pri:#9883ec` → `#ffffff`, plus a heading-font variable the default never sets.

Taking the first block gives you a funnel that is subtly the wrong brand everywhere and looks
approximately right, which is the hardest kind of wrong to notice.

Variable names may be non-English — the confirmed file mixed English (`--bg`, `--line`) with
transliterated names (`--font-tieu-de` for the display face, `--cta-bg-nhan` for the pressed
state). Read them as tokens; don't assume an unfamiliar name is dead.

### 4. Asset manifest — `PS_PREFETCH`

```bash
grep -o 'window.PS_PREFETCH=\[[^]]*\]' funnel.html
```

Every image the funnel uses, as paths relative to the funnel URL. Faster and more complete than
walking the DOM screen by screen, because it includes assets for screens you cannot reach
without uploading a photo or paying.

## Before you size anything: audit the resolutions

The manifest mixes sizes that look interchangeable by filename. Download and measure:

```bash
python -c "from PIL import Image; import glob; \
[print(f, Image.open(f).size) for f in sorted(glob.glob('*.webp'))]"
```

A real spread from one funnel: hero photography **786×1458**, gallery tiles **188×282**,
review portraits **400×545** — all under `intro-assets/` and `paywall-assets/`, all named alike.
Use a tile where a hero belongs and it upscales ~2.7× into visible mush. See the resolution
check in `verifying-landing-pages`.

## What this file does not give you

**Type specs.** The funnel's CSS tells you what the *implementation* shipped, which is often a
substitution for what the design actually specifies. If a Figma source exists, read the type off
the text node itself (`figma:get_design_context` on the node's parent frame) — it returns the
real family, weight, size, tracking and gradient. Inferring a typeface from a rendered
screenshot is guessing; two sans-serifs at 24px are indistinguishable in a PNG and completely
different on the page.

**Anything behind a conversion.** Checkout, post-payment screens and the activation flow only
render after real input. Read those from the design source and mark them as unverified against
production in the brief.

## Where to spend the time

Extraction is fast and is not the work. Once you have flow + strings + tokens + assets, the
whole remaining job is layout and craft — and every string you ship is one the client already
approved, in the brand's own tokens, which removes a review cycle that would otherwise be spent
arguing about wording you invented.
