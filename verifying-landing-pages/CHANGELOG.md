# Changelog

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
