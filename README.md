# building-landing-pages

Two Claude Code skills for shipping a marketing site or landing page.

| Skill | What it is |
|---|---|
| **`building-landing-pages`** | An 8-stage pipeline: research → structure → brand → design brief → build → verify → deploy → handoff |
| **`verifying-landing-pages`** | The 26 checks to run before calling one finished. Stands alone; you do not need the pipeline to want them |

Both were distilled from the full session transcripts of two real builds — a pre-launch company
site and a multi-language app landing page — not written from first principles. Most of what
they contain is a record of bugs that actually happened.

## Install

```bash
npx skills add hieunc-apero/building-landing-pages@building-landing-pages -g -y
npx skills add hieunc-apero/building-landing-pages@verifying-landing-pages -g -y
```

Take the second one on its own if all you want is the pre-launch checklist.

The `-g` is not optional. Without it, `npx skills add` auto-detects scope and installs
**project-scoped** whenever your working directory is inside a project — and a bare git repo
counts. A project-scoped skill silently fails to resolve anywhere else: no error, no warning.

Verify it landed:

```bash
ls ~/.claude/skills/
```

## Optional: install everything at once

If you would rather not paste a dozen commands, the repo ships a script. Clone it, read the
script, then run whichever tier you want:

```bash
git clone https://github.com/hieunc-apero/building-landing-pages && cd building-landing-pages
./install.sh --dry-run          # print the commands, install nothing
./install.sh                    # both skills + required dependencies
./install.sh --recommended      # plus one skill per remaining stage
./install.sh --all              # plus the optional motion / GPU / ASO set
```

On Windows: `.\install.ps1`, `.\install.ps1 -Recommended`, `.\install.ps1 -All`, `-DryRun`.

Run `--dry-run` first. Every skill it installs runs with full agent permissions and comes from
a different third-party repository — you should know what you are agreeing to. The pipeline
never installs anything on its own: it checks what is present, tells you what is missing, and
asks.

## Dependencies — read this before using the pipeline

`building-landing-pages` **composes other skills rather than duplicating them**. It calls them
by name at the matching stage. If a named skill isn't installed, nothing errors — that stage
just quietly gets done by hand, and you won't be told.

Nothing here is bundled. Install what you want; the pipeline degrades gracefully, it just gets
less useful.

**Required** — the pipeline doesn't really work without these:

```bash
npx skills add hieunc-apero/building-landing-pages@verifying-landing-pages -g -y  # stage 6
npx skills add obra/superpowers -s brainstorming -g -y
npx skills add anthropics/skills@frontend-design -g -y
npx skills add anthropics/knowledge-work-plugins@ux-copy -g -y
```

**Recommended** — each covers a whole stage:

```bash
npx skills add coreyhaines31/marketingskills@site-architecture -g -y      # stage 2, hierarchy + URLs + nav
npx skills add nextlevelbuilder/ui-ux-pro-max-skill@ui-ux-pro-max -g -y   # stage 3, pick a direction
npx skills add pbakaus/impeccable@impeccable -g -y                        # stage 5, audit an existing UI
npx skills add ibelick/ui-skills@fixing-accessibility -g -y               # stage 6, deeper a11y pass
npx skills add arvindrk/extract-design-system@extract-design-system -g -y # stage 1, competitor tokens
```

**Optional** — install if the project needs them:

```bash
npx skills add "rknall/claude-skills@SVG Logo Designer" -g -y      # stage 3, the logo itself
npx skills add lottiefiles/motion-design-skill@motion-design -g -y # stage 5, how motion behaves
npx skills add greensock/gsap-skills@gsap-core -g -y               # stage 5, implementing it
npx skills add pixel-point/animate-text@animate-text -g -y         # stage 5, text effects
npx skills add iart-ai/webgl-animation-skills@shader-glsl -g -y    # stage 5, GPU work
npx skills add eronred/aso-skills@competitor-analysis -g -y        # stage 1, mobile apps only
```

Two dependencies need nothing installed: `artifact-design` is provided by the harness, and
`figma:figma-design-to-code` comes from the Figma plugin if you have it. The pipeline treats
the Figma one as genuinely optional and tells you what to do instead.

> The selector after `@` matches the skill's frontmatter `name:` field, **not** its folder
> name. That's why the logo one is `"SVG Logo Designer"` with spaces and quotes. Get it wrong
> and the CLI prints the repo's skill list, installs nothing, and exits 0.

## What's in here

| File | |
|---|---|
| `building-landing-pages/SKILL.md` | The pipeline. Eight stages, what each one gates on |
| `building-landing-pages/reference/skill-routing.md` | Which sub-skill at which stage, and why one sometimes silently doesn't exist |
| `building-landing-pages/reference/design-brief-template.md` | Structure of the locked brief from stage 4 |
| `verifying-landing-pages/SKILL.md` | The 26 checks: build, visual, content integrity, i18n, deploy, assets, handoff |
| `*/CHANGELOG.md` | Why each version changed, including what testing found |
| `building-landing-pages/USELOG.md` | Empty by design — one entry per real run, feeds the next revision |

## Why these exist as skills at all

A survey of the registry found the landing-page space crowded but shallow. Every skill checked
covers one stage: `site-architecture` (100.2K installs) does information architecture and stops
there; `landing-page-conversion-audit` (38.8K) audits a page that already has paid traffic;
`landing-page-generator` (1.5K) plans a paid-ads page and explicitly does not build, QA or
deploy. Nothing ran end to end, and **nothing verified anything** — the closest QA matches were
generic checklists under 150 installs, and no landing-page skill covered i18n or deploy
verification at all.

So: the pipeline exists to hold an order across stages, and `verifying-landing-pages` exists
because that gap was real.

## Honesty about maturity

- The three discipline principles the pipeline used to preach were **baseline-tested against 12
  subagent runs with the skill absent, and produced zero violations** — agents already behaved
  that way unprompted. They were demoted, then removed. See `CHANGELOG.md` v0.4 and v0.8.
- The evidence has limits: one model, two repetitions per scenario, single-turn agents with
  clean context. The failures this was extracted from happened deep into long sessions.
- `USELOG.md` is empty. The pipeline is extracted from real builds, but the packaged skill
  hasn't yet been run end-to-end on a new project.

If you use it, an entry in `USELOG.md` — especially for a run that went wrong — is the most
useful thing you can send back.
