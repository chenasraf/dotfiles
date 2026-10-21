# Page templates

Skeletons for every page type in a review folder. Replace `<…>`. Keep the section order: the
reviewer reads many pages back to back, and a fixed order lets them skip straight to what they need.

Every page:
- starts with frontmatter in the vault's own convention (check the vault's CLAUDE.md / an existing
  note in the project folder; the Pantry vault uses `created` + `tags`),
- ends with an empty `## Comments` section, then a `---` footer of prev / start / next links, so
  the whole folder reads as one chain: Start → D01…Dn → F01…Fn → S01…Sn → Open Questions.
- writes every page-id mention as a link, never bare: `[[D08 Low-stock sync|D08]]`,
  `[[D08 Low-stock sync#4 · Quantity|D08 §4]]`, `[[F06 Low stock reaches the list|F06]]`. That covers
  tables (escaped `\|`), Open Questions, the coverage matrix and the reading-order list.
  `scripts/link_refs.py` finds and fixes misses.
- has headings free of quotes, backticks and pipes, so they work as link anchors.

Contents:
- [Start page](#start-page)
- [Decision page](#decision-page)
- [Flow page](#flow-page)
- [Story page](#story-page)
- [Glossary](#glossary)
- [Coverage Matrix](#coverage-matrix)
- [Open Questions](#open-questions)
- [Prior Art / Out of Scope](#prior-art--out-of-scope)
- [Mermaid rules](#mermaid-rules)

---

## Start page

File: `00 Start Here.md`. The `FROM` paths are vault-relative; set them to the folder's real path.

````markdown
---
created: <YYYY-MM-DD>
tags:
  - design
  - active
---
# <Feature> — Design Review

<One line: what's covered (map/epic id), what's in here.>

The source of truth stays in <where the ADRs / glossary / cards live>. This folder is a reading copy.
When a review comment changes a decision, the source is updated first and these pages after it.

## How to review

**Comment anywhere** by adding a task tagged `#review`, directly under the line it's about:

```
- [ ] #review <example question>
```

Say **"check review comments"** and Claude collects every open one, then either:
- replies indented under it (`- 🤖 …`) and leaves it open for you, or
- changes the page / source, notes what changed in a reply, and ticks it.

Tick a comment yourself when you're satisfied. To sign off a decision, set `review: approved`
(or `changes`) in its frontmatter. Flows and stories have the same field, and there it means "read,
and it behaves as expected". A flow comment that changes behaviour is fixed in the decision it
comes from.

### Open comments

```dataview
TASK
FROM "<vault-relative folder path>"
WHERE !completed AND contains(tags, "#review")
GROUP BY file.link
```

### Decision sign-off

```dataview
TABLE WITHOUT ID file.link AS Decision, card AS Card, adr AS ADR, review AS Review
FROM "<vault-relative folder path>/Decisions"
SORT file.name ASC
```

### Flow and story sign-off

```dataview
TABLE WITHOUT ID file.link AS Page, review AS Review
FROM "<vault-relative folder path>/Flows" OR "<vault-relative folder path>/Stories"
SORT file.name ASC
```

## Reading order
1. [[Glossary]]
2. **Decisions** D01 → Dn
3. **Flows** F01 → Fn
4. **Stories** S01 → Sn
5. [[Open Questions]]: **most worth your time.**

Also: [[Coverage Matrix]], [[Prior Art]], [[Out of Scope]].

## Decision map
<mermaid flowchart TB of "builds on" edges between decisions>

<Decision links grouped by area, one line each with a short hook.>

## Flows
| Flow | What it covers |
|---|---|
| [[F01 <name>]] | <…> |

## Stories
- [[S01 <name>]]: <hook>

## Comments
````

If Dataview isn't installed in the vault, replace the queries with a hand-kept list and say so.

---

## Decision page

File: `Decisions/D<NN> <Short name>.md`, numbered in **dependency order** (a decision comes after
everything it builds on), not in ADR/card order.

````markdown
---
created: <YYYY-MM-DD>
tags:
  - design
  - active
card: "<card id or —>"
adr: "<ADR number or —>"
review: pending
---
# D<NN> · <Short name>

> [Card #<id>](<url>) · ADR <nnnn> (or "resolution on the card (no ADR)") · decided <date> · builds on [[D<..>]]

## Question
<The question as it was asked, in plain words.>

## Context
<Only what's needed to see why it was a question: existing constraints, codebase facts.>

## Decision
### 1 · <Sub-decision title>
### 2–3 · <Title covering two source sections>

<One `### N · Title` heading per source section (§1, §2…), so any page can link
`[[D<NN> <Short name>#4 · <Title>|D<NN> §4]]`. Use a range heading when two sections share one
explanation. Decisions without numbered sections (e.g. card resolutions) use plain titles. Tables
for case splits; a small TB mermaid where branching is the point.>

## Why
<Reasons, short bullets.>

## Rejected
- **<Option>:** <why not>. (Keep every rejected option from the source; reviewers re-litigate these.)

## Consequences
<Storage/columns, API shape, accepted costs.>

## Shows up in
- [[F<..>]] · [[S<..>]]

## Comments

---
← [[D<prev>]] · ↩ [[00 Start Here]] · next → [[D<next>]]
````

---

## Flow page

File: `Flows/F<NN> <What happens>.md`. Name flows after what happens to the user or the data
("Low stock reaches the list"), not after decisions.

````markdown
---
created: <YYYY-MM-DD>
tags:
  - design
  - active
review: pending
---
# F<NN> · <What happens>

<One or two lines: the situation this flow starts from.>

**Decisions:** [[D<..>]] · [[D<..>]]

## <What starts it>   (when there are several triggers)

## Diagram
<mermaid: flowchart TB / sequenceDiagram / stateDiagram-v2 with direction TB>

## Walkthrough
1. <Numbered steps that match the diagram, each linking the decision §§ that govern it.>

## <Case table>   (e.g. "Reviving the row": state → what happens)

## Worked example
<Concrete names and numbers, step by step, showing the arithmetic.>

## Edge cases
- **<case>:** <outcome> ([[D<..>#<heading>]])

## Comments

---
← [[F<prev>]] · ↩ [[00 Start Here]] · next → [[F<next>]]
````

---

## Story page

File: `Stories/S<NN> <Scenario>.md`. A realistic scenario with named people and real values that
walks several flows end to end. Aim for 3–5 stories that together touch every flow; one of them
should be "mistakes and corrections" (stray taps, renames, deletes, undo).

````markdown
---
created: <YYYY-MM-DD>
tags:
  - design
  - active
review: pending
---
# S<NN> · <Scenario>

<One line.>

**Flows:** [[F<..>]] · …

## Setup
<Table of the lists/items/settings with their starting values.>

## Story
<mermaid sequenceDiagram (participants = people, lists, background jobs), Note over … for days>

1. **<Step>.** <What happens and why, linking the flow/decision.>

## Comments
````

---

## Glossary

One `###` heading per term, grouped under `##` areas, so pages can link `[[Glossary#Term]]`.
Each entry: a one- or two-sentence definition plus a `→ [[D..]]` / `→ [[F..]]` pointer. Mirror the
project's own glossary wording; add only terms the pages need. Avoid characters Obsidian anchors
choke on in headings (`#`, `|`, `[`, `]`, quotes).

---

## Coverage Matrix

- Decisions × flows table: ● central, ○ touches. Use `[[D01 Name\|D01]]` (escaped pipe) inside
  table cells.
- Stories × flows table.
- A "Not walked by any story" list: flows or branches no story exercises. Add a story, or leave
  them listed.

---

## Open Questions

Two groups:
1. **Open items on the tracker**: cards/issues still undecided, one `###` each with a link.
2. **Gaps found while writing this folder**: one `###` per gap, each with:
   - the conflict or silence, citing both sides (`[[D08 …]] §4 says … but [[D11 …]] §6 …`),
   - a concrete failure scenario with values,
   - a **Lean:** line with a suggested answer, clearly marked as a suggestion, not a decision.

Give each gap a short, stable heading so stories and flows can link `[[Open Questions#<gap>]]`.

---

## Prior Art / Out of Scope

- **Prior Art:** research findings in a table (topic → what others do → which decision used it).
- **Out of Scope:** each ruled-out idea, what's done instead, why not, and the cost accepted.

Include either only if the sources have that material.

---

## Mermaid rules

The reviewer reads on a laptop and on a phone; horizontal scrolling makes diagrams unusable.

- `flowchart TB` only. Never `LR`/`RL`. `stateDiagram-v2` gets `direction TB`.
- No `gantt` or `timeline`; they're horizontal by nature. Use a table for day-by-day timelines.
- At most ~3 sibling nodes on one row. Turn a fan of 4+ settings or cases into a vertical chain,
  or into one node plus a table under the diagram ("Revive the row (table below)").
- One connected component per diagram: disconnected pieces render side by side. Join them with a
  shared start node (`S{"Member enters"} -- "a date" --> …`).
- Short labels: ~30 characters per line, `<br/>` to wrap, quoted (`A["…"]`, `-- "…" -->`).
- Prefer `sequenceDiagram` for request/response or day-by-day stories; it grows downward.
  Keep it to 4–5 participants.
- Cyclic graphs (A↔B↔C with labelled edges) render wide. Unroll them into a vertical chain of
  distinct nodes that covers every edge once.
