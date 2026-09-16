# Changelog

History of `SKILL.md` itself and this skill's own portability. One entry per change to the skill's instructions — append here whenever the pipeline, a stage's checklist, or a cross-referenced skill changes. Not a log of projects built with the skill — see [USELOG.md](USELOG.md) for that.

## v0.12 — 2026-09-16

**Changed:** the `description`. It now covers reworking an existing page, names the funnel case,
and says the pipeline is entered at whichever stage the work actually starts — rather than
"from scratch ... from research and brand through build".

**Why:** this skill is at v0.12 with **one** entry in [USELOG.md](USELOG.md). Eleven revisions,
one real run. The second entry, added today, is a run where the skill never loaded at all.

Every one of those revisions edited the body. The body is only read once the skill has already
been selected, and selection reads nothing but the description — which carried three gates that
between them excluded most real work: "from scratch" ruled out anything that already exists,
"marketing website or landing page" ruled out funnels and app flows, and "from research and
brand through build" implied a full eight-stage run so a job starting at build or verify did
not look like a match.

v0.10 is the sharpest illustration. It correctly diagnosed, from the only run in the log, that
the pipeline had no entry point for work that already exists — and fixed it by adding the
"Joining a page that already exists" table to the body, behind the gate that was itself the
reason such work never reached the skill. Today's edit added a sixth row to that same table and
would have inherited the same fate.

**The lesson, for the next revision of this or any skill:** a body fix and a routing fix are
different repairs. When a use-log entry says the skill was not used, or was used for something
its description does not name, the description is the defect — editing the instructions is
treating a symptom. Check the description first whenever the log is thin.

## v0.11 — 2026-09-16

**Changed:** a sixth row in "Joining a page that already exists" for a live page to rebuild or
port, pointing at a new [reference/funnel-source-anatomy.md](reference/funnel-source-anatomy.md).
Also corrected the `verifying-landing-pages` check count in stage 6 and in
[reference/skill-routing.md](reference/skill-routing.md) — both still said 26, which went stale
at that skill's v0.2 and was wrong by eleven.

**Why:** a funnel rebuild, where the source was a hosted builder's single-file HTML export. The
extraction was worth an hour and none of it was guessable:

- The copy is **not in the page.** Every string renders through `t("key")`; the table ships as
  a separate i18n script. Grepping the HTML for a headline visible on screen returns nothing.
- The flow is a `STEPS=[...]` array in the minified bundle — the authoritative order, unlike
  the design board, which also held variants the shipped funnel never reaches.
- There are **two** `:root{}` blocks. The first is the platform default; the second is the
  funnel's override, and they disagreed on nearly every token. Taking the first yields a page
  that is quietly the wrong brand throughout.
- An asset manifest (`PS_PREFETCH`) lists images for screens you cannot reach without paying.

None of that is recoverable by reasoning about the page — only by digging, twice, in the wrong
places first. That is the test for what belongs in a reference file rather than being left to
be re-derived. The desktop layout decisions from the same run were deliberately **not** written
down: a competent pass reinvents a sticky pricing rail unaided, and a skill that documents the
guessable parts alongside the unguessable ones buries the half that matters.

## v0.10 — 2026-09-14

**Changed:** added a "Joining a page that already exists" table, and split stage 3's
instruction to pull from an existing source into tokens (fine) versus pixels (a licensing
decision that belongs in the brief).

**Why:** the first real run, logged in [USELOG.md](USELOG.md) — an audit of an existing
landing page. Two of its four findings land here.

The pipeline had no entry point for work that already exists. Every stage is written to
follow the one before it, so auditing a page built a month earlier meant improvising a jump
to stage 6 with nothing in the skill sanctioning it. Most real work is not a blank page. The
new table keys the entry point to what is actually in the project rather than to an assumed
starting state, and says explicitly that entering late does not excuse stage 8.

The stage 3 change is preventive. The page audited had taken its five product screenshots
from another company's Figma file; one of them renders that company's name in body text, and
a CSS overlay covering a second was one layout change away from exposing it. Stage 3 as
written invited exactly that — "pull tokens/fonts from that source directly" reads as
permission to take whatever is in the file. Tokens are a shortcut; pixels are someone's
property.

`SKILL.md` is now 1187 words, well over the 500 that `writing-skills` targets. The joining
table is a decision point where a run demonstrably went wrong, which is the one thing that
skill says to keep inline, so it stays — but the budget is spent and the next addition
should displace something rather than append to it.

## v0.9 — 2026-09-12

**Changed:** added [reference/review-preferences.md](reference/review-preferences.md) and a
"What gets work bounced" section pointing at it, plus references from stage 5 and stage 6.
Ten patterns, each cited to a verbatim correction, and a pre-show checklist.

**Why:** the first long review cycle this skill's evidence base has seen — ~15 rounds on the
that same web app. Stage 6 passed every time and the work still came back, which says the gap is
not in the checks but in what the checks are blind to.

One cause dominated. Desktop kept getting built as the phone layout at a bigger size, and it
was reported four separate times in four different wordings before it stopped
("giống responsive iPad quá", "chưa optimal cho desktop" ×2, "chưa đủ đẹp"). That is not a
correctness failure — every one of those pages built, deployed and passed accessibility.
`verifying-landing-pages` cannot catch it, and should not be asked to: it is a taste contract,
not a check.

Placed at stage 5 rather than stage 6 deliberately. Every one of those four rounds was a
rebuild, not a fix — by the time a desktop layout exists and is wrong in this particular way,
there is nothing to correct, only to redo.

Two things were deliberately left out. Per-project brand taste, because that belongs in the
stage 4 brief where it can be versioned, not in a skill shared across projects. And the
subagent baseline the `writing-skills` Iron Law asks for: its own rule says to stop when the
no-guidance control does not exhibit the failure, and here the control fails trivially — an
agent with no record of a reviewer's preferences cannot infer them. The test would pass and
teach nothing. The evidence standard used instead is the one this skill was already built on:
every claim traces to a real build.

## v0.8 — 2026-09-04

**Changed:** split `reference/verification-checklist.md` out into its own skill,
`verifying-landing-pages`, and pointed stage 6 at it as a required sub-skill. Added
`site-architecture` to stage 2. Dropped the "Why the checklist is shaped the way it is"
section — its two principles moved into the new skill, where the checks they explain now live.

**Why:** a survey of the skills registry, prompted by asking whether any of this already
exists. Two findings drove the change.

First, nothing in the registry verifies a landing page. Searching for QA and verification
skills returns generic checklists under 150 installs, and every landing-page skill checked
states it does not cover QA, i18n or deploy — including `site-architecture` (100.2K installs),
`landing-page-conversion-audit` (38.8K, and it needs live traffic data to say anything) and
`landing-page-generator` (1.5K). The 26 checks were the one genuinely uncontested asset here
and they were reachable only by installing an entire pipeline. They stand alone: wanting the
checks does not imply wanting the pipeline.

Second, stage 2 was the weakest stage against the field. `site-architecture` does page
hierarchy, URL structure, navigation and internal linking properly, and this skill was
gesturing at all of it in a single sentence. Composing beats restating — the same reason the
other twelve are named rather than copied.

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
