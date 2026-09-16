# Changelog

## v0.5 - 2026-09-16

**Changed:** `description` — "a marketing site, landing page, or funnel".

**Why:** same routing audit as `building-landing-pages` v0.12. This description was already the
better of the two — "before claiming that ... a visual change renders the way the code reads"
describes the run it missed almost exactly — but the noun list gated it. A multi-step funnel
with upload, paywall and checkout screens does not obviously read as a marketing site or a
landing page, so the skill was not reached for on a session that spent most of its time doing
precisely what this file is for.

Worth noting what that cost and what it did not: the run's verification was done by measurement
rather than by screenshot anyway, and caught four render bugs the screenshots had hidden. The
discipline survived without the checklist. The specific items did not — an upscaled image
shipped, and the client found it.

## v0.4 - 2026-09-16

**Changed:** one Visual QA check — no image may render larger than its source. 36 -> 37.

**Why:** a port of a live funnel to desktop. The source project's asset folder held hero
photography at 786x1458, gallery thumbnails at 188x282 and review portraits at 400x545, all
`*.webp`, all under the same two directories, all named to the same scheme. Three of the
rebuilt screens were given a thumbnail as their full-height stage image, upscaled ~2.7x.

Every check in this file passed on it. The files existed, they returned 200, they were the
right images, the layout measured correctly, contrast was fine. Nothing here asks whether an
image is being *stretched* — the page just looked slightly soft, which is exactly the failure
mode that survives a screenshot pass and gets caught by the client instead.

The check is a one-liner over `document.images` comparing `naturalWidth` to the rendered box,
so it costs nothing to run and needs no judgement call: any ratio above 1 is a defect.

## v0.3 - 2026-09-14

**Changed:** added a Conversion path section (4 checks, with runnable snippets) and one
content-integrity check for a page that contradicts itself on a measurable claim. 30 -> 36.

**Why:** the same page audited for v0.2 was audited again, this time by a dispatched
read-only agent working from this checklist in a fresh context. It reproduced every finding
the manual pass had made and returned nine more. One of those nine is the reason this
section exists:

The page had **no link off itself at all.** Its only purpose is app installs. Seven CTAs
resolved cleanly, the hero chained to `#download`, and the section it landed on carried a
button reading "Download on the App Store" with `href="#"`. Nine dead controls in total, and
zero off-site links once the font preconnects are filtered out. Every one of the 30 checks
passed over it, because not one of them asked whether the page does the job it exists for.

A dead button renders exactly like a live one, which is why nothing upstream catches this:
the markup is valid, the anchors resolve, the contrast is measurable, the layout holds. The
failure is only visible if you follow the primary action to its **last** hop rather than its
first.

The self-contradiction check came from the same audit: that page stated its render time four
ways - "about twelve seconds" in the hero, `~12s` in the stats, `11s` on a chip, and
"Progressing in 15s" inside a screenshot. Three were in the markup and greppable; the fourth
was pixels.

Both snippets in the new section were run against that page before shipping: 9 dead controls,
0 off-site links.

## v0.2 - 2026-09-14

**Changed:** added a precondition section (get the page served over HTTP and assert its
assets loaded, before checking anything), a note on how contrast and centring measurements
go wrong, and four asset-provenance items. 26 checks -> 30.

**Why:** the first real run of the sibling pipeline skill, on an existing landing page. Three
of its four findings land here.

The precondition exists because the page was nearly verified while broken. Opened directly
rather than served, it rendered as a `data:` snapshot: every relative asset path failed, all
ten images were empty frames, and the page still looked deliberate enough that a
screenshot-only pass would have signed it off. The checklist said to verify with a real
screenshot; it never said the screenshot could be of a page that never loaded.

The measurement note exists because two measurements in that session were wrong before they
were right. A gradient-backed button reports a transparent `background-color`, so resolving
its background by walking up the tree landed on the page background and produced a phantom
1.01:1 failure; the true figures ranged from 8.79:1 to 2.96:1 across the gradient's stops.
Separately, using `innerWidth` instead of `clientWidth` made a 15px scrollbar look like a
uniform 8px centring error on every block on the page. "Measure it" was doing more work in
the wording than it could carry.

The provenance items exist because the largest problem on that page was not in the list at
all. All five product screenshots were exports from another company's Figma file; one
renders their product name in body text in two places with nothing covering it, another is a
photograph of an identifiable person, and their typo shipped along with the pixels. The
nearest existing item asked whether a referenced asset exists in the repo - never whether it
is ours.

## v0.1 - 2026-09-04

Split out of `building-landing-pages` v0.7, where this lived as
`reference/verification-checklist.md`.

**Why:** a survey of the skills registry found no landing-page-specific verification skill at
all - the closest matches are generic QA checklists under 150 installs, and every landing-page
skill checked (including ones with 30-100K installs) explicitly does not cover QA, i18n or
deploy verification. Buried inside a pipeline skill, these checks were only reachable by
installing the whole pipeline. They are independently useful: you do not need the pipeline to
want the checks.

Ships 26 items across code correctness, visual QA, content integrity, i18n, deploy, assets and
licensing, and handoff.
