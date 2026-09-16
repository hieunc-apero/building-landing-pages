# Use Log

One entry per verification pass — evidence for the next `writing-skills` REFACTOR pass, not a
project changelog. Append one after **every** pass, including a partial one and including a pass
where the page turned out clean.

The field that earns this file is **What got through**. A checklist is only ever improved by the
defects it failed to catch, and those are visible for about a day — until someone else finds
them and the miss is remembered as their find rather than as a gap here. Write it down while it
still stings.

## Entry format

```markdown
## <date> — <project name>

**Sections run:** build / visual / content / conversion / i18n / deploy / assets / handoff (list which)
**Skipped:** <any section skipped, and why — "not applicable" is a valid answer worth recording>
**Caught:** <what the checklist found that a casual look would have missed — this is what justifies the section>
**What got through:** <defects found by someone else, or later. The most valuable line in the entry>
**Dead weight:** <any check that has now run several times and never once fired>
**Gap found:** <what should turn into the next CHANGELOG entry>
```

A check that has never fired across several entries is a candidate for deletion, not a badge.
Length is a cost here: every item competes for attention with the item that would have caught
the real bug.

*No entries yet. Append one after every run - including a partial or abandoned
one. A run that stopped early is exactly the signal that reveals a gap.*
