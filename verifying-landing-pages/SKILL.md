---
name: verifying-landing-pages
description: Use when a marketing site, landing page, or funnel is about to be called done, merged, or shipped - including before claiming that a build passes, a locale is complete, a deploy is live, or a visual change renders the way the code reads.
---

# Verifying Landing Pages

Checks to run before calling a marketing site or landing page finished. Concrete items,
extracted from real bugs caught (or almost missed) on two production builds - not a
generic QA list.

**The one rule underneath all of them: a green exit code is not evidence.** Every item here
exists because something reported success while the thing that mattered was never observed -
a CLI returned 0, a page rendered locally, a translation batch "looked complete".

Run the sections that apply. Skip i18n if the site is single-locale; skip Deploy until there
is something to deploy. An item you skip on purpose is fine; an item you assume is not.

## Before any of this: get the page actually running

These checks are worth nothing against a page whose assets never arrived, and a page in that
state does not look broken. Opening an HTML file directly - `file://`, or a preview that
renders it as a `data:` snapshot - silently breaks every relative path inside it. Images
resolve to nothing, their frames render empty, and the layout around them still reads as
deliberate. A screenshot-only pass will sign off on it.

Serve it over HTTP from its own directory, then assert the assets arrived before checking
anything else:

```js
[...document.images].filter(i => !i.naturalWidth).map(i => i.getAttribute('src'))
// must return []
```

## Code correctness
- [ ] Typecheck / build passes clean (`tsc --noEmit`, `next build`, etc.)
- [ ] Lint passes clean
- [ ] Any e2e/interaction tests pass — if one fails, isolate whether it's pre-existing flake (run baseline 3-4x *without* your change) before dismissing it as unrelated, and don't dismiss it as flake without that baseline either
- [ ] Parse the shipped HTML/JS with a script: balanced tags, no leftover template/comment markers in the body, every referenced asset actually exists on disk

## Visual QA
- [ ] Verify with a real screenshot or a real pixel measurement (`getBoundingClientRect`, `measureText`) — not by reading the code and assuming it renders as written
- [ ] No image renders larger than its source. Compare `naturalWidth`/`naturalHeight` against the rendered box for every image (`[...document.images].filter(i => i.naturalWidth && i.getBoundingClientRect().width > i.naturalWidth)`) — anything upscaling is a defect. An asset folder routinely mixes hero art, gallery thumbnails and avatars under one naming scheme and one extension: one real set ran 786×1458, 188×282 and 400×545 side by side, all `*.webp`, all `tile`/`hero`-ish names. The 188px one filled a 431px frame and read as mush at a glance but "loaded fine" to every check that only asks whether the file 404s
- [ ] Measure the accent colour's contrast **as text**, separately from its contrast as a fill or rule — an accent chosen to sit on a dark ground routinely fails AA the moment someone uses it for a word on a light one (amber `#FFB020` is 10:1 on near-black and 1.83:1 on white). Write down which roles it is allowed in
- [ ] Check every locale/breakpoint that changed, not just the one you were looking at

> **The hard part of this section is measuring, not judging.** Two traps, both hit in a single
> real session:
>
> - An element whose background is a `linear-gradient` reports
>   `background-color: rgba(0, 0, 0, 0)`. Walking up the tree looking for a painted colour
>   lands on the page background and invents a failure that isn't there. Read
>   `background-image`, measure against the **darkest stop**, and report the range - a button
>   can pass at 8.8:1 at one end of its gradient and fail at 2.96:1 at the other.
> - Centring is measured against `document.documentElement.clientWidth`, never `innerWidth`.
>   `innerWidth` includes the scrollbar, so every block on the page reports the same few
>   pixels of false offset and the whole run looks broken.

- [ ] `prefers-reduced-motion` / the fully-static fallback still reads correctly with all animation off — this is the design, not a degraded mode
- [ ] No section is stuck in a pre-animation state (opacity/blur) when scrolled to directly — anchor link, fast scroll, or reload mid-page must all show the final state immediately

## Content integrity
- [ ] No fabricated stats, reviews, or testimonials — pull real numbers (App Store API, analytics) or mark placeholder content as visibly placeholder
- [ ] Brand name/terms consistent everywhere — grep for the old name after any rename, including in code comments and alt text
- [ ] The page does not contradict itself on any measurable claim — collect every number that describes the same thing (render time, price, limits, counts) and check they agree, including numbers baked into screenshots. One audited page stated its render time four ways: "about twelve seconds" in the hero, `~12s` in the stats, `11s` on a chip, and "Progressing in 15s" inside an image
- [ ] Copy follows the project's copy rules (see `ux-copy` — no stray em dashes, consistent terms, etc.)

## Conversion path

The page exists to send someone somewhere. Everything above can pass while that fails, and it
will not look broken: a dead button renders exactly like a live one.

- [ ] **Follow the primary action to its destination and confirm it leaves the page.** Not the
  first hop — the last. An audited launch page chained hero CTA → `#download` → a section whose
  own button was `href="#"`. Every CTA resolved; nothing left the page; the App Store link did
  not exist
- [ ] No control ships as `href="#"`, an empty `href`, or a handler that does nothing. Count them:

```js
[...document.querySelectorAll('a')].filter(a => !a.getAttribute('href') || a.getAttribute('href') === '#').length
// expect 0
```

- [ ] At least one link actually points off-site when the page's job is off-site (store listing,
  checkout, signup, calendar). Filter out the ones that don't count:

```js
[...document.querySelectorAll('a[href^="http"]')]
  .map(a => a.href)
  .filter(h => !/fonts\.(googleapis|gstatic)\.com|^\/\//.test(h))
// expect the destination you are selling
```

- [ ] Policy and legal links the destination platform requires are **real links that resolve**,
  not styled text. An app store will reject a submission whose privacy policy is a `<span>` —
  and a page making claims about biometrics, on-device models or data retention needs the policy
  those claims refer to
- [ ] Any form on the page **delivers**, verified by submitting one and finding it at the other
  end. A 200 response is not delivery

## i18n (if applicable)
- [ ] Every locale has 100% key coverage — script-check every key against the source locale, don't spot-check
- [ ] Inline markup (`<em>`, `<br>`, `<strong>`) and `{placeholder}` tokens survive translation unchanged — verify per locale, not just the batch you just wrote
- [ ] Non-Latin scripts don't inherit a Latin-only italic/serif font — a browser-synthesized fake italic on Arabic/Japanese/Thai/etc. reads as a broken font, not as emphasis
- [ ] RTL locales render correctly as a layout, not just as LTR-with-flipped-text
- [ ] A key missing from a locale falls back to the source-locale string, never to the raw key name

## Deploy
- [ ] The live production build came from a **commit**, not from a local upload — `vercel --prod` and friends deploy the working directory, so production can be bytes that match no branch at all. Push, then confirm the deployed commit SHA
- [ ] A custom domain is verified by **loading it**, not by having changed nameservers — DNS propagation, domain verification and TLS issuance are three separate things that fail separately. A half-issued certificate shows a browser security warning, which is worse than a clean failure because the page looks malicious rather than missing
- [ ] Env vars are present on the *target* platform, not just locally — a silent missing-env failure (form doesn't save, mail doesn't send) is worse than a build failure
- [ ] After connecting a git integration, push one real commit and confirm a new deployment actually appears — a successful CLI command is not proof the webhook works
- [ ] Cache headers won't hide a real file change — `immutable, max-age=<long>` on an asset you intend to overwrite in place will serve the old bytes to every returning visitor; version the filename instead of relying on cache-busting after the fact
- [ ] Load the live URL cold (cache-busted query string or incognito), not just the local dev server

## Assets and licences
- [ ] Every non-system display face has a **webfont licence**, not just a desktop one — commercial foundries (Klim, Grilli Type, Displaay…) price web use separately and usually by monthly pageviews. This blocks the build at the type layer, so settle it before the design brief locks a face, not at launch
- [ ] Every asset is **ours, or licensed** - not a screenshot, mockup or export lifted from another product's design file. Ask it of each image: if that company opened this page, would they recognise their own work?
- [ ] Product screenshots show **our** product. A foreign wordmark or body string baked into a PNG is invisible to every text search you would normally run, and an overlay positioned on top of it breaks the moment the layout moves. Open the images and read them
- [ ] No identifiable person appears without a release - a face that arrived with a borrowed mockup is a licensing problem, not placeholder content
- [ ] Copy inside a borrowed asset is now your copy, typos included - proofread the text in the images, not just the markup
- [ ] Every referenced asset actually exists in the repo — a brand vector cited in a handoff is not the same as a brand vector committed

## Handoff
- [ ] Every locked decision (brand token, deferred feature, "why not X") is written to the project's memory/HANDOFF.md, not left only in chat history — a different session or account needs to pick this up without re-deriving it
- [ ] Append an entry to this skill's own [USELOG.md](USELOG.md) — including for a pass that found nothing. Record what the checklist **missed** before anyone else finds it; a miss remembered as someone else's catch never becomes a check here

## If something here fails

Bisect until you can name the one line. The symptom is rarely the bug - a recurring "still
shows the old logo" turned out to be a cache header, not a wrong file, and a page that "won't
update" turned out to be serving a build that came from a local upload rather than any commit.

## Maintaining this skill

Two files, two purposes. [USELOG.md](USELOG.md) records what each pass caught and — the line
that matters — what got through. [CHANGELOG.md](CHANGELOG.md) records changes to the checks
themselves, and a change should cite the log entry that justified it.

Additions are not free. Every check competes for attention with the one that would have caught
the real bug, so a check earns its place by having fired, and a check that has run across
several entries without ever firing is a candidate for deletion. One corroborating log entry
before adding, not one good idea.

## Related

Part of a larger pipeline for building a marketing site from scratch: `building-landing-pages`
covers research, structure, brand, the design brief, the build, deploy and handoff, and calls
this skill at its verification stage. This one stands alone and does not require it.
