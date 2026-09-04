# Skill Routing

Which skill to reach for at each stage of [SKILL.md](../SKILL.md), what each one is actually
for, and the install traps that make a skill silently absent. Read this when a stage names a
skill you haven't used before, or when a named skill doesn't seem to exist.

## By stage

| Stage | Skill | For |
|---|---|---|
| 1 Research | `extract-design-system` | Pull a competitor's real tokens off their site instead of eyeballing them |
| 1 Research | `competitor-analysis` | Mobile apps only — the ASO/keyword/store layer, not the visual teardown |
| 2 Structure | `brainstorming` | Turn research into an approved structure before anything gets built |
| 3 Brand | `ui-ux-pro-max` | Choose the direction: style family, palette, type pairing |
| 3 Brand | `svg-logo-designer` | The mark itself — variations, layouts, PNG export |
| 3 Brand | `figma:figma-design-to-code` | Only when an existing Figma source has to be read |
| 5 Build | `frontend-design` / `impeccable` | The interface craft — see the phase rule in SKILL.md |
| 5 Build | `ux-copy` | **Every** piece of interface text, automatically: CTAs, errors, empty states, tooltips, even spellchecks |
| 5 Build | `motion-design` + `gsap-*` | How motion should behave, and how to implement it — both, not one or the other |
| 5 Build | `animate-text` | Named text effects: reveal, typewriter, stagger, counters, text swaps |
| 5 Build | `shader-glsl` | GPU work only — shader backgrounds, distortion, image transitions |
| 6 Verify | `fixing-accessibility` | Contrast, ARIA, keyboard nav, focus management, form errors |
| any | `artifact-design` | When a stage's deliverable is a *proposal to show*, not the final build |

Call these by name — do not copy their content into this skill. They update independently of
it, and one of them (`impeccable`) is ~40 files on its own.

## A named skill that "doesn't exist" is usually installed in the wrong scope

Everything above except `artifact-design` (harness-provided) and `figma:figma-design-to-code`
(plugin-provided) must be installed **globally**. A project-scoped skill resolves only when the
working directory matches that project, and is otherwise silently absent — no error, no
warning. The stage just quietly gets done by hand and nobody notices.

This has bitten three times on one machine: `ux-copy` (v0.3), `svg-logo-designer` and
`motion-design` (v0.5).

**Trap 1 — the installer defaults to the wrong scope.** `npx skills add <pkg> -y` auto-detects
scope and picks *project* whenever the working directory sits inside one. A bare git repo
counts: run `npx skills ls` in a directory that has nothing but `git init` and it answers
"No project skills found". Always pass `-g` explicitly.

```bash
npx skills add <owner>/<repo>@<skill> -g -y
```

**Trap 2 — the selector is the frontmatter name, not the folder name.** What follows `@` is
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
