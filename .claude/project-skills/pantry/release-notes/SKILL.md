---
name: release-notes
description:
  Write and publish Pantry's curated release notes — the per-change fragments in
  `release-notes/next/`, and the per-store notes in `release-notes/<version>/` that the release PR
  is gated on. This skill should be used when committing a `feat`/`fix` in a Pantry repo (to add its
  fragment), when the user runs /release-notes, when a release PR's `release-notes` check fails, or
  when the user asks to write or fix the notes for a release.
argument-hint: '[fragment | release] [version]'
---

# Pantry release notes

The request: **$ARGUMENTS**

Every Pantry store shows notes written for people, not the commit log. Two jobs:

- **Fragment**: one file per change people will notice, committed together with its `feat`/`fix`.
- **Release pass**: once the release PR is open, turn the fragments into notes for every
  destination, within each one's limit. The release PR's `release-notes` check stays red until this
  is done, and a release pushed without it is not tagged (app) or published (server).

Everything repo-specific is in the repo's `release-notes/config.yml`: the version file, the
destinations and their limits, the `platforms:` map (which platforms reach which destination), the
full-notes link, and the paired repo. Read it first; never hard-code those here.

## Fragments

`release-notes/next/<area>-<short-kebab-slug>.md`, in the same commit as its `feat`/`fix`. Never on
the release-please branch: release-please force-pushes it on every master push.

```md
---
kind: feat # feat | fix
area: shopping # grouping key: shopping, inventory, notes, photos, items, watch, translations, …
platforms: [all] # keys of config.yml `platforms:`
weight: notable # headline | notable | minor
onboarding: no # yes | no | maybe
onboarding_reason: # required when onboarding is yes: which rubric point, in a sentence
---

Full, friendly description: what people can do now and why it's worth trying, never what the code
does. Present tense, second person, no jargon (no API, sync, cache, endpoint, component names).
```

- **Body**: start from the card's `## Release highlight` when it has one, otherwise from the card's
  description, rewritten for someone who has never seen the code. One to three sentences.
- **platforms**: the commit's platform scope (`fix(wear): …` → `[wear]`); a feature-area scope means
  `[all]`. Check whether the change sits behind a `PlatformInfo` branch.
- **weight**: `headline` — something people would update the app for, at most a few per release;
  `notable` — worth its own line; `minor` — small fixes and polish.
- **onboarding**: see the rubric below. `yes` needs `onboarding_reason` and makes the weight at least
  `notable`.
- `chore`/`refactor`/`test`/`docs` commits get no fragment.
- **Paired repo**: when the card's `## Commit message` is the same for both repos, write a matching
  fragment in the paired repo (config.yml `paired-repo.path`) for its commit too, with the platforms
  that repo's config knows (the server uses `all`).

## Release pass

1. **Find the release.** Open release PR:
   `gh pr list --state open --search 'head:release-please--' --json number,headRefName`. Its version
   is in config.yml's `version.file` on that branch (`git fetch origin <branch>` then
   `git show origin/<branch>:<file>`). The last release is the newest tag with config.yml's
   `tag-prefix`. Work on an up-to-date master.
2. **Gather.** The fragments in `release-notes/next/`, and every commit since the last tag
   (`git log <tag>..origin/master --format='%h %s'`). Each `feat`/`fix` commit should have a
   fragment; for one that doesn't, find its ✅ Done card on the Deck board (match the commit title
   against the cards' `## Commit message`) and write the fragment from it. Ask when a commit has
   neither a card nor an obvious meaning.
3. **Translations.** Commits since the tag that only update translations (app:
   `lib/messages_*.i18n.yaml`; server: `l10n/`, "Update translations from Transifex") fold into one
   fragment: `kind: fix`, `area: translations`, `weight: minor`, `platforms: [all]`, body "Updated
   translations." Add it when missing. A language whose file was added since the tag
   (`git diff --diff-filter=A --name-only <tag>..origin/master`) gets its own `notable` fragment:
   "Pantry is now available in Norwegian."
4. **Render** each destination in config.yml into `release-notes/<version>/<file>`, using only the
   fragments whose `platforms` reach it (through the `platforms:` map):
   - **Long text (limit ≥ 4000, Apple) and markdown (Nextcloud App Store)**: each headline as its
     own short paragraph; notable items as a list; minor items folded per area ("Shopping trips:
     three smaller fixes."). Text destinations are plain text: no markdown syntax, `• ` for list
     items. Markdown destinations use paragraphs and lists only, never headings: `make appstore`
     adds the `## <version>` heading.
   - **Short (limit 500, Play and Wear)**: at most 2–3 headlines — one is a sentence, more than one
     a `• ` list, one line each — then the notable features as a
     `More features:` list (`• ` items, a few words each), then one `Also: fixes for …` line: the
     notable fixes named, the minor ones collapsed into "and N smaller ones". End with the full-notes link
     (config.yml `full-notes-url`). Rewrite until it fits; never cut mid-sentence.
   - **Nothing for the watch**: when no fragment reaches `wear` and `packages/pantry_wear` changed
     only in `pubspec.lock` since the tag, `wear.txt` still has to exist for the check: say that
     nothing changes on the watch, sum up the phone's headlines in a sentence, and link the full
     notes. Tell the owner the Wear upload can be skipped for this release (`/release` skips it).
   - Word each destination afresh: the fragments are the source, not a template to concatenate.
5. **full.md**: every fragment of the release, in full, grouped as `## Highlights`, `## New`,
   `## Fixes`, then by area, with each item's platforms in parentheses when it isn't `all`. Then
   delete the fragments from `next/` (keep `next/.gitkeep`).
6. **Check** with `scripts/check.sh <repo> <version>` (this skill's directory): the same rules as CI
   — every destination file plus `full.md`, non-empty, within its limit, no `<!--`, and no
   fragments left in `next/`.
7. **Onboarding.** List the fragments marked `onboarding: yes` or `maybe` against the rubric and the
   budget, and ask the owner which get a page. File each approved page as a card on the Deck board
   (see the repo's `.scratch/docs/agents/issue-tracker.md`); the pass doesn't write pages.
8. **Show and commit.** Show every rendered file with its length, then commit to master as
   `chore(release): add release notes for <version>` (`update` on a re-run) once the owner
   approves, and push when they say so. The push updates the release PR and its check goes green; in the app, CI also copies
   `play.txt` into F-Droid's changelog on the PR.
9. **Paired repo.** If the paired repo has an open release PR too, offer to run the pass there.

### Re-running for the same version

Work that lands after the pass adds fragments to `next/`, and the `release-notes` check fails until
they are in the notes. To re-run, keep `release-notes/<version>/` as the starting point:

- `full.md` holds every fragment already rendered. Add the new fragments to it in their groups, then
  delete them from `next/`.
- Re-render every destination from the whole `full.md`, not only the new items: a new headline can
  push an older one into "Also:", and the short notes still have to fit.
- Keep the owner's own edits in the rendered files (`git log -p release-notes/<version>/` shows
  them): reword around them rather than over them, and ask before dropping one.
- Run the onboarding step for the new fragments only; earlier approvals stand.

When the release PR's version changes (a breaking change bumps it further), `git mv` the folder to
the new version before re-running.

## Onboarding rubric

A change gets a page only when at least one holds:

1. **Not discoverable from the screen**: a gesture, long-press, swipe, hidden menu, or a mode
   to enter.
2. **Changes a habit**: something people already do moved, was renamed, or behaves differently.
3. **A new place**: a new tab, view or flow that needs a reason to visit.

Never: fixes, speed or reliability, settings toggles that explain themselves, clearly labelled
buttons where people would look anyway. At most **2 upgrader pages per release per platform**; extras wait
for a later release or share a page. The new-user tour grows only for the core loop it already
covers (lists, adding, scanning, shopping, watch). The app keeps the same rubric on
`kAppOnboardingPages` in `lib/views/onboarding/onboarding_pages.dart`.
