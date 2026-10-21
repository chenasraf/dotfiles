---
name: design-review
description: Build an interlinked Obsidian review folder from a project's recorded design decisions (ADRs, tracker/Deck card resolutions, glossary), with one page per decision, top-to-bottom mermaid flow pages, worked-example stories, a glossary, a coverage matrix and an Open Questions page of gaps, plus a `#review` comment protocol the user annotates and Claude answers. This skill should be used when the user asks to review, walk through or "go over" the decisions made on a feature/map/epic, wants decisions and flows laid out to read and comment on, or says "check review comments" / "answer my review comments" on an existing review folder.
---

# Design Review

Turn a batch of design decisions into a reading-and-commenting space in the user's Obsidian vault.
It has two modes:

- **Build**: gather the decisions, then write the folder.
- **Comment loop**: answer the `#review` comments the user leaves in it.

The folder is a **reading copy**. The ADRs, tracker cards and glossary stay the source of truth.
A change agreed in review goes into the source first, then into the pages.

## Build mode

### 1. Gather every decision, not just the ADRs

Decisions are usually split across several places. Read all of them in full before writing:

- **ADRs** for the feature (e.g. `.scratch/docs/adr/`, `docs/adr/`).
- **Glossary / domain doc** (e.g. `CONTEXT.md`).
- **Tracker cards.** If there's a parent "map"/epic card, read its description: it often holds a
  "decisions so far" list, codebase facts, out-of-scope items, and the child card ids. Then read each
  child card's **comments**. Cheap-to-reverse decisions are often settled in a "Resolution:"
  comment with no ADR, and those pages matter as much as the ADR-backed ones.
- **Research / prior-art** notes the decisions cite.
- Child cards still **open** on the map: these become Open Questions, not decisions.

Large tracker listings overflow tool output. Save to a file and filter with `jq` by id range or
parent.

### 2. Settle location and scope

The default location is the project's folder in the vault, e.g.
`~/Nextcloud/Notes/Projects/<Project>/<Feature> Review/`. Read the vault's `CLAUDE.md` (or a
sibling note) for frontmatter and tag conventions. Check `.obsidian/plugins` for `dataview`.

Obsidian resolves links by note name across the whole vault. Before writing, check that generic page
names (`Glossary`, `Open Questions`, `Prior Art`, `Out of Scope`, `Coverage Matrix`,
`00 Start Here`) aren't already used elsewhere, e.g. `find <vault> -name "Glossary.md"`. If one is
taken, prefix the folder's generic pages (e.g. `Stock Glossary`).

If the location or scope (which decisions are in or out) isn't clear from the request, ask. Ask one
question at a time, with lettered options and a recommendation.

### 3. Plan the page set

```
<Feature> Review/
├── 00 Start Here.md      how to review, open-comment + sign-off dashboards, decision map, index
├── Glossary.md           one heading per term → [[Glossary#Term]]
├── Coverage Matrix.md    decisions × flows, stories × flows, what no story walks
├── Open Questions.md     open tracker items + gaps found while writing (with leans)
├── Prior Art.md          only if research exists
├── Out of Scope.md       only if anything was ruled out
├── Decisions/D01 … Dnn   one per decision, in dependency order
├── Flows/F01 … Fnn       one per behaviour the user or the data goes through
└── Stories/S01 … Snn     3–5 scenarios with real values that together touch every flow
```

**Derive the flows from behaviour, not from decisions.** List the moments a user or the system goes
through (setup, the automatic sync, the main action, undo, recovery, time-based jobs, hand edits,
conversions). A flow usually combines several decisions, and a decision usually shapes several flows.
The coverage matrix is where that many-to-many shows. Every decision should be central to at least
one flow; every flow should be walked by at least one story.

### 4. Write the pages

Follow `references/page-templates.md` for each page type and for the **mermaid rules**. Diagrams must
be top-to-bottom: the user reads on narrow screens and horizontal scroll makes them unusable.

Writing rules:
- **Faithful first.** Every claim on a decision page must trace to a source. Keep the source's
  section numbering (§1, §2…) so comments can cite it. Keep every rejected option: reviewers
  re-argue those.
- **Worked examples with real numbers** on flows and stories ("target 12, on-hand 4 → row says
  8"). Check the arithmetic, because a wrong number in an example looks like a design bug.
- **Mark readings.** Where the sources leave something unsaid and an example needs an answer, pick
  the most plausible reading, state it in the page, and add it to Open Questions. Never present
  inference as decided.
- **Link densely**: terms to `[[Glossary#Term]]`, steps to `[[Dnn …#Heading]]`, related flows and
  stories to each other. Every page gets the prev / start / next footer.
- **Every page id is a link, every time.** Never write a bare `D08`, `F06`, `S02` or `D08 §4` in
  prose or tables. Write `[[D08 Low-stock sync|D08]]`, or point a section reference at its heading:
  `[[D08 Low-stock sync#4 · Quantity|D08 §4]]`. Inside tables, escape the alias pipe (`\|`).
  `[[D08 Low-stock sync]] §4` with the § outside the link counts as unlinked too.
- **Number decision sub-headings after the source sections** (`### 4 · Quantity`, a range as
  `### 2–3 · The API is per kind`) so every `§N` has a heading to link to. Keep quotes, backticks
  and pipes out of headings, because they break Obsidian anchors.
- **Never leave angle brackets bare.** Obsidian reads `Duplicate as <kind>` as an HTML tag or
  autolink, and all formatting after it on the page breaks. Put any text holding `<…>` in inline
  code, e.g. `"Duplicate as <kind>"`, in prose, tables and replies alike. This doesn't apply inside
  mermaid blocks, where `<br/>` is fine.
- Write files with the Write tool, one page per call, batching independent pages in parallel.

### 5. Hunt for gaps: the highest-value part

While writing the flows, look for and record in Open Questions:

- **Conflicts:** two decisions that give different answers for the same case, or later decisions
  that make an earlier one's wording stale.
- **Silences:** an order, boundary or tie-break no decision defines (inclusive vs exclusive day
  boundaries, "first" by what ordering, empty or zero values).
- **Loops:** an action whose side effect immediately re-triggers it (e.g. a renewal that lands
  straight back inside a warning window).
- **Bypass paths:** bulk operations, background jobs or alternative entry points that skip the
  hook the main path runs.
- **Lifecycle holes:** the referenced thing being deleted, archived, moved or permission-restricted.
- **Attribution and permissions** for writes the system makes on someone's behalf.
- **Unhandled enum values** in conversions (a status with no mapping).

Each gap gets a concrete failure scenario and a **Lean:** suggestion. When reporting back, name the
3–5 gaps most likely to change a decision.

### 6. Validate

```bash
python3 <skill>/scripts/link_refs.py "<folder>" --fix  # link bare D08 / F06 / S02 / "D08 §4" references
python3 <skill>/scripts/link_refs.py "<folder>"        # must report 0 bare, 0 unresolved sections
python3 <skill>/scripts/check_links.py "<folder>"      # every [[note]] / [[note#heading]] resolves; no bare <…> outside code
bash    <skill>/scripts/check_mermaid.sh "<folder>"    # every diagram parses; flags LR/RL/gantt/timeline
```

- `link_refs.py --fix` rewrites bare ids in place and points `§N` at the matching `N · …` heading. It
  never touches frontmatter, headings, code, diagrams or lines containing `#review`. An "unresolved
  section" means the target decision has no `N · …` heading for that number: add the numbered
  heading, then rerun.
- `check_mermaid.sh` installs `mermaid` + `jsdom` once into `~/.cache/design-review-mermaid`.

Fix everything the scripts report before handing over. **Rerun all of them after every edit pass**,
including comment-loop changes.

### 7. Hand over

- Tell the user where the folder is and which page to start on.
- Explain the comment syntax in one line.
- Name the most important open questions.
- Save a project memory recording the folder path and that "check review comments" means this
  skill's comment loop, so a later session can pick it up.

## Comment loop mode

Triggered by "check review comments" (or similar) on an existing review folder.

1. **Collect** unchecked review tasks:
   `grep -rn -- "- \[ \] .*#review" "<folder>"`. Read each one in context: the heading and
   paragraph it sits under say what it's about.
2. **Classify each comment**:
   - **Question**: answer it.
   - **Pushback or proposed change**: if it's clear-cut, make the change. If it reopens a real
     trade-off, put it to the user (one question at a time, lettered options, a recommendation) and
     wait before editing.
   - **Error in the page** (it misstates the source): fix the page.
3. **Reply** by inserting a nested bullet directly under the task, indented one level: `- 🤖 <answer>`.
   Keep it short and cite the source (ADR §, card). For a change, say what changed and where.
4. **Change in order**: source first (ADR, glossary, card comment), then every review page that
   repeats the point. Use grep, because the same rule usually appears in the decision page, one or
   more flows, a story and the glossary. Then rerun the validators from step 6.
5. **Tick** (`- [x]`) only comments that are fully resolved by a change. Leave answered questions
   open for the user to tick. Never delete a comment.
6. When a comment settles an Open Questions gap, rewrite that entry as resolved, linking to where
   the decision now lives, and update the decision's `review:` status only if the user says so.
   A comment on a flow or story that changes behaviour is fixed in the decision it comes from. If
   that decision was `approved`, say so in the report instead of changing its status.
7. Report a short list: each comment → answered / changed (with the file) / waiting on the user.

## Notes

- The folder is private notes, so tracker ids, card links and ADR numbers belong in it. Don't copy
  its pages into tracked repo docs.
- If the user prefers a website over Obsidian, the same page set and rules apply. Comments then live
  in the site's own comment mechanism instead of `#review` tasks.
