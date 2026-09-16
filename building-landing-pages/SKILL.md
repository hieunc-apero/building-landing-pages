---
name: building-landing-pages
description: Use when building or reworking a marketing site, landing page, or multi-step funnel — a new product launch page, an app landing page, a company site, or one that already exists and needs auditing, restyling, porting to another breakpoint, or shipping. Covers research, brand, build, QA, and deploy, entered at whichever stage the work actually starts.
---

# Building Landing Pages

An 8-stage pipeline distilled from two real builds — a pre-launch company site and a multi-language app landing page — each stage backed by a real skill or a concrete checklist, not vibes.

## Before stage 1 — check what is actually installed

This skill composes skills it does not bundle. A missing one does not error — the stage just
quietly gets done by hand and nobody is told. Check once per project, before starting:

```bash
ls ~/.claude/skills/
```

Compare against the table in [reference/skill-routing.md](reference/skill-routing.md). Tell the
user which named skills are missing, which stage each one covers, and the exact install command
— then let them choose.

**Ask before installing anything.** These run with full agent permissions and come from nine
different third-party repositories; that is the user's call to make, not yours. A missing skill
is not a blocker either — say which stages will be weaker and carry on.

## Stages

| # | Stage | Do this | Sub-skill / tool |
|---|---|---|---|
| 1 | Research | Market + 3-5 direct competitor sites. WebFetch only reads text — for real visual reference, screenshot with a headless browser (Puppeteer/PowerShell) or read a Figma source directly. | `extract-design-system`; `competitor-analysis` *(mobile apps only)* |
| 2 | Structure | Turn research into a page structure before touching a design tool. | **REQUIRED SUB-SKILL:** `brainstorming`; then `site-architecture` for page hierarchy, URLs, nav and internal linking — it goes deeper than doing it inline |
| 3 | Brand | **First ask:** is there an existing Figma file, a `.pen` file, or any brand asset (logo, token doc, past brief) already? Don't assume — check the project's memory/HANDOFF for a prior brand decision too, a parallel session may have already locked one. If yes, pull tokens/fonts from that source directly (`figma:figma-design-to-code` if it's Figma) instead of re-brainstorming. Pull **tokens** — colour, type, spacing. Pulling someone else's **pixels** (screenshots, mockups, photography) is a licensing decision rather than a shortcut: write it in the brief as a decision with an owner and an expiry, and see the assets section of `verifying-landing-pages`. If no, brainstorm logo/token directions, present 2-3, confirm the direction before building the rest around it. | `ui-ux-pro-max` to pick the direction **before** committing; `svg-logo-designer` for the mark; `figma:figma-design-to-code` *(if the source is Figma)* |
| 4 | Design brief | Write one locked brief file — positioning, the tokens pulled or brainstormed in stage 3, a reference-site table with a "take this one thing" column, anti-goals, motion rules, section-by-section spec. Re-issue as vN.N on every material change; never edit silently. Template: [reference/design-brief-template.md](reference/design-brief-template.md). | — |
| 5 | Build | Visual tool (Pencil/Figma) for fast variants; hand-code (Next.js/HTML) once real interaction or motion is required — see the two-path note below. | `frontend-design` or `impeccable` for the UI; `ux-copy` for every string; `motion-design` + `gsap-*` for motion; `animate-text`, `shader-glsl` as needed. Read [reference/review-preferences.md](reference/review-preferences.md) **before** the first desktop layout, not after it comes back |
| 6 | Verify | Non-negotiable before calling anything done. | **REQUIRED SUB-SKILL:** `verifying-landing-pages` (37 checks: build, visual, content, conversion, i18n, deploy, handoff); `fixing-accessibility` for the deeper ARIA/keyboard/focus pass; the "Before showing work" list in [reference/review-preferences.md](reference/review-preferences.md) |
| 7 | Deploy | git → gh repo → host git-integration → **prove the pipeline is live** by pushing one throwaway commit and confirming a new deploy appears — a green CLI exit is not proof. | — |
| 8 | Handoff | Update the project's memory/HANDOFF.md after any stage that changes a locked decision — this is what lets a different session or account continue without re-deriving context. **Also append an entry to this skill's own [USELOG.md](USELOG.md)** — even for a partial or abandoned run. | — |

## Joining a page that already exists

The stage table reads as if it always starts at 1. Most real work does not. Enter where the
evidence puts you:

| What you find in the project | Enter at |
|---|---|
| No page, no brief | 1 |
| A brief or a locked brand decision, nothing built | 5 |
| A built page, and a specific change was asked for | 5, then 6 |
| A built page, and the question is whether it is any good | **6** — run the checks first, so the conversation opens with findings instead of opinion |
| A built page nobody has deployed | 6, then 7 |
| A **live page to rebuild, port or restyle** | 1, but research it rather than the market — lift its real flow, strings and tokens from the shipped source before designing anything: [reference/funnel-source-anatomy.md](reference/funnel-source-anatomy.md) |

Entering late does not excuse stage 8. Any run that changes a locked decision updates the
project's handoff, and **every** run appends to [USELOG.md](USELOG.md) — including one that
only audited.

i18n is a variant of stage 5/6, not a separate stage: extract the string inventory, stamp keys, translate in batches, and validate 100% key coverage + markup + placeholders survive **before** starting the next batch.

## Two build paths — pick by need for real interaction

- **Visual tool (Pencil, Figma):** fast to produce and compare many variants side by side, but no real JS — no working sliders, no functioning style-pickers, no scroll effects.
- **Hand-coded (Next.js/HTML):** required the moment the page needs anything the visual tool can't do. Both source builds started in the visual tool and moved to code once that ceiling was hit — don't force everything into one path.

## What gets work bounced

The 37 checks in `verifying-landing-pages` catch broken. They do not catch
*wrong for this reviewer* — and in the one long review cycle logged so far, that
is what sent work back, round after round.

The single recurring cause: **desktop built as the phone layout at a bigger
size.** Icon rails, swipe carousels, phone measures at 1400px, a narrow block
against the left edge of a wide container. It was raised four times in four
different wordings before it stopped happening.

Nine more patterns, each cited to a real correction, plus a pre-show checklist:
[reference/review-preferences.md](reference/review-preferences.md). Read it at
stage 5, before the first desktop layout exists — reading it at stage 6 means
rebuilding rather than checking.

## Picking between the UI skills

`frontend-design`, `impeccable` and `ui-ux-pro-max` all self-select on the same "make the UI"
request, so pick by *phase*, not by preference:

```
brainstorming  →  ui-ux-pro-max  →  frontend-design  →  impeccable
 (structure)      (pick direction)     (build blank page)    (audit & polish)
```

Blank page means `frontend-design`. An interface that already exists and needs to get better
means `impeccable`. Not knowing what it should look like yet means `ui-ux-pro-max` first, then
back to one of those two.

What every other named skill is for, and why a named skill sometimes silently doesn't exist:
[reference/skill-routing.md](reference/skill-routing.md). Read it the first time a stage names
a skill you haven't used — the install-scope trap in there is the single most common way a
stage gets quietly skipped.

## Maintaining this skill

Editing `SKILL.md` itself (stage instructions, checklist, cross-references)? Append an entry to [CHANGELOG.md](CHANGELOG.md) — version bump, what changed, why (ideally citing what a [USELOG.md](USELOG.md) entry surfaced). Skipping the changelog on a "small" edit is how a skill drifts from the evidence it was built on.
