# Design Brief Template

Structure of the "locked brief" from stage 4 of [SKILL.md](../SKILL.md) — the single file everything downstream (a design tool, a coding session, a different account) reads instead of re-deriving decisions. Modeled on the brief that carried the company site from research to build. Version it — `v2`, `v2.1`, `v2.2`... — every time a locked decision changes, and say in one line what changed and why.

```markdown
# <Project> — Website Design Brief

> Supersedes all previous versions. <One-line scope: page count, single-page vs multi-page.>

## 1. Context & goals
- What the product/company is, in one paragraph a stranger could repeat.
- Audiences, in priority order.
- Primary CTA · Secondary CTA.
- What's NOT true yet (no app, no portfolio, no pricing) — this shapes what visual weight has to come from instead.

## 2. Sitemap
Page tree, one line per page/section, with a [Must]/[Future] tag on anything not certain yet.

## 3. Design direction
### 3.1 Brand identity — LOCKED (do not reinvent)
Logo concept in one sentence. Color roles (primary/secondary, with hex). Signature gradient/motif if any, with an explicit discipline rule for where it may and may not appear. Typography pairing (display + body) with a one-line reason the pairing works.

### 3.2 References — what to take from each
| Ref (URL) | Take this |
|---|---|
| site-a.com | the one specific thing — hero pattern, nav style, whatever — not "the vibe" |

One reference usually matters more than the rest — name it and explain which specific hard constraint it solves (e.g. "no portfolio yet, and this one proves a static hero can carry the page alone").

### 3.3 Anti-goals
Explicit list of aesthetics to avoid, each with the *reason*, not just the ban — "no neon blue-purple gradient: reads as generic AI-SaaS, and this brand's gradient is warm-coded so it must never drift there."

### 3.4 Tokens
| Token | Value | Notes |
|---|---|---|
| `bg`, `text`, `accent`, ... | hex | where each is allowed to appear |

### 3.5 Motion — static-first
- Every section must read completely with all effects off; that static state is the design, not a degraded fallback.
- No blur as a pre-entrance state — opacity/translate only.
- A section already in the viewport (anchor jump, fast scroll, reload mid-page) renders its final state immediately, never a hidden-waiting-to-animate state.
- At most one effect idea per section; name the 1-2 signature scroll-linked moments explicitly and leave everything else as simple entrance/hover.

## 4. Global elements
Nav behavior, footer contents — the things every section shares.

## 5. Section by section (Home)
Per section: goal (one line), layout, final copy (not lorem ipsum), CTA if any, effect (referencing the rule in §3.5).
```

## Why a brief, not just a conversation

The brief is what stage 8 (Handoff) writes *to* and stage 4→5 hands *off* — a design tool or a different session reads the file, not the chat history. Re-sending the whole file on every change (rather than describing the diff in chat) is what let one of those builds catch a real conflict: a later session cross-checked the brief against an earlier locked brand-identity decision and found the accent color had drifted — catchable only because both were written down, not because anyone remembered correctly.
