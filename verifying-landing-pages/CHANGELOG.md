# Changelog

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
