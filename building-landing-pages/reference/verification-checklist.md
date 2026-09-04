# Verification Checklist

Concrete items, extracted from real bugs caught (or almost missed) on two production builds. Run the relevant sections before calling any stage done — this is stage 6 of [SKILL.md](../SKILL.md).

## Code correctness
- [ ] Typecheck / build passes clean (`tsc --noEmit`, `next build`, etc.)
- [ ] Lint passes clean
- [ ] Any e2e/interaction tests pass — if one fails, isolate whether it's pre-existing flake (run baseline 3-4x *without* your change) before dismissing it as unrelated, and don't dismiss it as flake without that baseline either
- [ ] Parse the shipped HTML/JS with a script: balanced tags, no leftover template/comment markers in the body, every referenced asset actually exists on disk

## Visual QA
- [ ] Verify with a real screenshot or a real pixel measurement (`getBoundingClientRect`, `measureText`) — not by reading the code and assuming it renders as written
- [ ] Measure the accent colour's contrast **as text**, separately from its contrast as a fill or rule — an accent chosen to sit on a dark ground routinely fails AA the moment someone uses it for a word on a light one (amber `#FFB020` is 10:1 on near-black and 1.83:1 on white). Write down which roles it is allowed in
- [ ] Check every locale/breakpoint that changed, not just the one you were looking at
- [ ] `prefers-reduced-motion` / the fully-static fallback still reads correctly with all animation off — this is the design, not a degraded mode
- [ ] No section is stuck in a pre-animation state (opacity/blur) when scrolled to directly — anchor link, fast scroll, or reload mid-page must all show the final state immediately

## Content integrity
- [ ] No fabricated stats, reviews, or testimonials — pull real numbers (App Store API, analytics) or mark placeholder content as visibly placeholder
- [ ] Brand name/terms consistent everywhere — grep for the old name after any rename, including in code comments and alt text
- [ ] Copy follows the project's copy rules (see `ux-copy` — no stray em dashes, consistent terms, etc.)

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
- [ ] Every referenced asset actually exists in the repo — a brand vector cited in a handoff is not the same as a brand vector committed

## Handoff
- [ ] Every locked decision (brand token, deferred feature, "why not X") is written to the project's memory/HANDOFF.md, not left only in chat history — a different session or account needs to pick this up without re-deriving it
