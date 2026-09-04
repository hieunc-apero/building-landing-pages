# Changelog

History of `SKILL.md` itself and this skill's own portability. One entry per change to the skill's instructions — append here whenever the pipeline, a stage's checklist, or a cross-referenced skill changes. Not a log of projects built with the skill — see [USELOG.md](USELOG.md) for that.

## v0.7 — 2026-09-04

**Changed:** added a preflight step before stage 1 — list what is installed, name the missing
skills and the stage each covers, and ask before installing any of them. Shipped optional
`install.sh` / `install.ps1` at the repo root for people who would rather run one command.

**Why:** the skill names thirteen skills it does not bundle, and the skill format has no way to
declare a dependency — checked across 35 installed skills, the only frontmatter fields in use are
`name`, `description`, `license`, `metadata`, `version`, `argument-hint`, `user-invocable` and
`allowed-tools`, and the CLI has no transitive install. So a recipient missing a dependency got
no signal at all: the stage silently happened by hand.

Auto-installing was rejected deliberately. The installer prints "they run with full agent
permissions" on every run, and these come from nine separate third-party repositories — having
one skill pull all of that in unattended makes the person who trusted this skill carry a supply
chain they never looked at. Making the gap visible solves the actual problem; the install script
stays opt-in and user-run.

## v0.6 — 2026-09-04

**Changed:** moved the stage-indexed skill table and the whole install/portability section out
to a third reference file, [reference/skill-routing.md](reference/skill-routing.md), and cut the
stage table's "sub-skill" column down to bare names. What stays inline is the one thing that is
a real decision point: the phase rule separating `frontend-design`, `impeccable` and
`ui-ux-pro-max`. `SKILL.md` drops from 1305 to 889 words.

**Why:** v0.5 solved a missing-knowledge problem by inlining all of it, which traded one flaw
for another — `writing-skills` puts the target for a skill of this kind at under 500 words and
says heavy reference belongs in its own file, loaded on demand. The routing table is exactly
that: a lookup consulted at one stage, not something needed in context while reading the
pipeline. The stage table's fourth column had also grown into paragraphs restating what the
routing table already said.

Still above 500 words. The remaining bulk is the eight-row stage table, which is the skill's
actual content — splitting that would mean the skill no longer says what it does.

## v0.5 — 2026-09-04

**Changed:** replaced the five-item cross-reference list with a stage-indexed table covering
every skill the routing knowledge assigns to a stage — added `ui-ux-pro-max` and
`svg-logo-designer` (stage 3), `extract-design-system` and `competitor-analysis` (stage 1),
`motion-design` + `gsap-*`, `animate-text` and `shader-glsl` (stage 5), and
`fixing-accessibility` (stage 6). Added the phase rule for the three UI skills that
self-select on the same request. Rewrote Portability around the two installer traps below.

**Why:** `ui-ux-pro-max` was missing entirely, which meant stage 3 told the agent to
brainstorm a direction by hand while a skill built for exactly that — palettes, type
pairings, style families — sat installed and unmentioned. Root cause: this skill was
extracted from the transcripts of two builds and captured the six skills *those two builds
happened to use*. Several of the others were installed after those projects shipped. The
source was history; the routing knowledge is current, and the skill had fallen a step behind.

Checking whether the newly referenced skills were actually reachable turned up the same
class of bug v0.3 fixed for `ux-copy`, twice more: `svg-logo-designer` and `motion-design`
existed only project-scoped, so both were silently absent outside one directory. Both are
now installed globally.

Two installer traps found while fixing that, both now documented in Portability:

1. `npx skills add <pkg> -y` auto-detects scope and chooses **project** whenever the working
   directory is inside one — a bare git repo qualifies (verified: `skills ls` in a
   git-init-only directory reports "No project skills found"). Any setup script that installs
   skills while sitting inside a repo therefore installs them somewhere nothing resolves
   them, and exits 0. Always pass `-g`.
2. The selector after `@` matches the skill's frontmatter `name:`, not its folder name. For
   `rknall/claude-skills` that is `SVG Logo Designer`, not `svg-logo-designer`; the mismatch
   makes the CLI print the repo's skill list and install nothing, exiting successfully.

**Not tested against subagents.** These are reference additions — missing names, wrong
scope — not discipline guidance, so the v0.4 RED cycle does not apply. The claims are
verified directly instead: every name in the table was checked to resolve globally on this
machine, and the scope-detection behaviour was reproduced rather than assumed.

## v0.4 — 2026-09-04

**Changed:** demoted the "3 rules that mattered more than any tool" section to a short
rationale note ("Why the checklist is shaped the way it is"), and added four concrete items
to `reference/verification-checklist.md`: deploy-from-commit vs local upload, domain
verified by loading it rather than by changing nameservers, webfont licensing as a build
blocker, and measuring an accent colour's contrast in its text role separately.

**Why:** ran the `writing-skills` RED phase that v0.1 recorded as never done. Twelve baseline
subagent runs, no skill loaded, across three claims — verify-the-deploy, don't-fabricate-
content, check-for-an-existing-brand-first. **Zero violations in twelve runs.**

The first round of six was a bad test and is not counted as evidence: the scenarios
enumerated A/B/C options with the compliant one spelled out, which is the academic-test
anti-pattern the methodology warns about — it hands the agent the answer. Round two used
open briefs with no options, plus a harder fixture where the locked brand decision sat in
meeting notes among six other docs with no "LOCKED" heading. Agents still found it,
unprompted, in both reps.

Per the methodology's own rule — if the no-guidance control doesn't exhibit the failure,
there is nothing to fix — the discipline framing was not earning its words. It is kept as
rationale (it explains *why* a checklist line exists) rather than deleted, because the
evidence has real limits: single model, two reps per scenario, and single-turn agents with
clean context. The failures this skill was extracted from happened deep into long sessions
with loaded context, which these runs do not reproduce.

The four checklist additions came out of the same runs — gap testing, not pressure testing.
Agents surfaced them unprompted while doing the tasks, and none were in the checklist:
`vercel --prod` uploading the working directory rather than a commit; a half-issued
certificate presenting as a security warning; commercial display faces needing a separate
pageview-priced web licence; and amber `#FFB020` measuring 1.83:1 as text on white against
10:1 on near-black.

## v0.3 — 2026-09-03

**Changed:** added a "Portability" note to the cross-referenced-skills section, and fixed the actual gap it describes — `ux-copy` was only installed project-scoped (inside one project's own `.claude/skills`), so it silently didn't resolve in any other project. Reinstalled globally (`npx skills add anthropics/knowledge-work-plugins@ux-copy -g`).

**Why:** asked directly to make sure this skill survives moving to another machine. Checking revealed that a dependency wasn't reliably available even on the machine it was written on — it resolved inside exactly one project directory and was silently absent everywhere else. A skill that names its dependencies is only as portable as the weakest of them.

## v0.2 — 2026-09-03

**Changed:** stage 3 (Brand) now opens with an explicit check — is there already a Figma file, a `.pen` file, or a locked brand decision in the project's memory/HANDOFF — before deciding to brainstorm or skip.

**Why:** the original v0.1 wording ("skip if one already exists") assumed the agent already knows whether a brand exists. Real transcripts show both source projects had this go wrong: one of them wrote a brief that contradicted a brand identity a parallel session had locked hours earlier, caught only because someone later thought to re-read that session. Without a forced check, a rebuild of this skill would default to brainstorming a new brand even when one already exists.

## v0.1 — 2026-09-03

Initial draft. 8-stage pipeline (Research → Structure → Brand → Design brief → Build → Verify → Deploy → Handoff) extracted from reading the full session transcripts of two real builds: a company site and an app landing page. Cross-references `brainstorming`, `frontend-design`, `impeccable`, `ux-copy`, `artifact-design`, and `figma:figma-design-to-code` by name rather than copying their content. Ships with two reference files: a verification checklist and a design-brief template.

Not yet run against a real project — see [USELOG.md](USELOG.md), currently empty. Not yet pressure-tested per the `writing-skills` RED-GREEN-REFACTOR method; the "3 rules" section in particular is untested discipline guidance.
