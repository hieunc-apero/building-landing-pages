# Skill Routing

Which skill to reach for at each stage of [SKILL.md](../SKILL.md), what each one is actually
for, and the two routing traps that keep a stage's skill from running. Read this when a stage
names a skill you haven't used before, when a named skill doesn't seem to exist, or when a skill
you know is installed never seems to fire.

## By stage

| Stage | Skill | For |
|---|---|---|
| 1 Research | `extract-design-system` | Pull real tokens off a live page instead of eyeballing them — a competitor's site, **or the page you are rebuilding**. Invoke it **by name**: its description says "a public website", so a funnel, an app flow or your own in-house page will not trigger it on their own |
| 1 Research | `competitor-analysis` | Mobile apps only — the ASO/keyword/store layer, not the visual teardown |
| 2 Structure | `brainstorming` | Turn research into an approved structure before anything gets built |
| 2 Structure | `site-architecture` | Page hierarchy, URL structure, navigation, internal linking — deeper than doing it inline |
| 3 Brand | `ui-ux-pro-max` | Choose the direction: style family, palette, type pairing |
| 3 Brand | `svg-logo-designer` | The mark itself — variations, layouts, PNG export |
| 3 Brand | `figma:figma-design-to-code` | Only when an existing Figma source has to be read |
| 5 Build | `frontend-design` / `impeccable` | The interface craft — see the phase rule in SKILL.md |
| 5 Build | `ux-copy` | **Every** piece of interface text, automatically: CTAs, errors, empty states, tooltips, even spellchecks |
| 5 Build | `motion-design` + `gsap-*` | How motion should behave, and how to implement it — both, not one or the other |
| 5 Build | `animate-text` | Named text effects: reveal, typewriter, stagger, counters, text swaps |
| 5 Build | `shader-glsl` | GPU work only — shader backgrounds, distortion, image transitions |
| 6 Verify | `verifying-landing-pages` | The 37 checks — build, visual, content integrity, conversion path, i18n, deploy, handoff |
| 6 Verify | `fixing-accessibility` | Contrast, ARIA, keyboard nav, focus management, form errors |
| any | `artifact-design` | When a stage's deliverable is a *proposal to show*, not the final build |

`verifying-landing-pages` ships from the same repository as this skill; the rest are third
party. Call them all by name — do not copy their content into this skill. They update independently of
it, and one of them (`impeccable`) is ~40 files on its own.

## A skill that is installed, global, and still never fires

The scope trap below is the loud failure — the skill is genuinely absent. The quiet one is a
skill that is present, correctly installed, and simply never *selected*, because selection reads
only the `description`. However well the body handles a case, if that one sentence does not name
it, the case never arrives.

This skill was the worst offender on this machine: eleven revisions against **one** logged run,
because its own description said "from scratch … from research and brand through build" and most
real work is neither. Fixed in v0.12 — one line of frontmatter, nothing in the body.

One is still live, because it is third party. `extract-design-system` reads "Extract design
primitives from **a public website**". Pulling tokens off a multi-step funnel, an app flow or
your own in-house page is the same operation and matches none of those words. On the run logged
for 2026-09-16 the tokens were re-derived by hand with `grep` while the skill sat installed,
global, and unused.

Editing a third-party description does not survive — `update-skills.ps1` reinstalls over it
(`npx skills add … -y`). Route around it from the table above instead; that is what the
"invoke by name" note is for.

**The check, whenever a skill seems never to be used:** read its `description` against the last
three jobs it should have caught. If a job does not obviously match the words in that single
sentence, the description is the defect — not the instructions, and not the model. A thin
[USELOG.md](../USELOG.md) is the symptom that sends you here.

## A named skill that "doesn't exist" is usually installed in the wrong scope

Everything above except `artifact-design` (harness-provided) and `figma:figma-design-to-code`
(plugin-provided) must be installed **globally**. A project-scoped skill resolves only when the
working directory matches that project, and is otherwise silently absent — no error, no
warning. The stage just quietly gets done by hand and nobody notices.

This has bitten three times on one machine: `ux-copy` (v0.3), `svg-logo-designer` and
`motion-design` (v0.5).

**Cause 1 — the installer defaults to the wrong scope.** `npx skills add <pkg> -y` auto-detects
scope and picks *project* whenever the working directory sits inside one. A bare git repo
counts: run `npx skills ls` in a directory that has nothing but `git init` and it answers
"No project skills found". Always pass `-g` explicitly.

```bash
npx skills add <owner>/<repo>@<skill> -g -y
```

**Cause 2 — the selector is the frontmatter name, not the folder name.** What follows `@` is
matched against the skill's `name:` field. For `rknall/claude-skills` that is
`SVG Logo Designer`, not `svg-logo-designer` — and on a mismatch the CLI prints the repo's
skill list, installs nothing, and exits 0.

**Verify rather than assume.** A skill being listed somewhere is not evidence it will resolve:

```bash
ls ~/.claude/skills/<name>
```

## The one skill that is genuinely optional

`figma:figma-design-to-code` is plugin-provided and machine-dependent. If it isn't available,
read the Figma source through whatever Figma MCP tools the session does have, or fall back to
a screenshot. Don't block stage 3 or 4 on it.
