---
name: release
description:
  Ship a Pantry version everywhere in the right order — merge the server's release PR and publish
  the docs website, then merge the app's, check the app version has a published server release, then upload to Google Play (phone),
  the App Store and the Mac App Store, and park the Wear OS upload until the phone build is live.
  Picks up where a previous run stopped. This skill should be used when the user runs /release,
  /release wear or /release status in pantry-flutter, or asks to release, ship or publish a Pantry
  version to the stores.
argument-hint: '[version] | wear | status'
---

# Pantry release

The request: **$ARGUMENTS**

A release runs in one order, and each step is checked before the next:

1. The server (`chenasraf/nextcloud-pantry`) is released first. Merging its release PR publishes to
   the Nextcloud App Store within minutes, so the merge is always confirmed first.
2. The docs website is published from the server's master, so the docs for what the web app just
   shipped go live with it.
3. The app version must match a published server release, or nothing reaches a store.
4. The app (`chenasraf/pantry-flutter`) is released; CI builds the GitHub release assets, and
   F-Droid, Linux and Windows go out from the tag on their own.
5. Phone, iOS and macOS upload in one run.
6. Wear OS uploads separately, after the user confirms the phone build is live. Uploading Wear with
   the phone puts both in the same Play review, which holds the phone release up for days.

Run everything from the pantry-flutter checkout. This skill's scripts are in `scripts/` next to this
file; `$SKILL` below means this skill's directory.

## Progress

`.scratch/release/<version>.json`, managed by `$SKILL/scripts/progress.sh`:

```bash
"$SKILL/scripts/progress.sh" list                        # versions with a progress file, and their next step
"$SKILL/scripts/progress.sh" <version> show
"$SKILL/scripts/progress.sh" <version> next              # first step not done
"$SKILL/scripts/progress.sh" <version> done <step> [note]
"$SKILL/scripts/progress.sh" <version> fail <step> <note>
```

Steps, in order: `server-merged`, `server-released`, `website`, `parity`, `app-merged`, `app-released`,
`notes`, `play`, `ios`, `macos`, `wear`. Record each step the moment it is done or fails, never
in a batch at the end: a closed session resumes from this file.

## Arguments

- **`status`**: `progress.sh list`, then `show` for each version that isn't released. Nothing else.
- **`wear`**: see [Wear](#wear).
- **A version**: release that version.
- **Nothing**: a version from `progress.sh list` whose next step isn't `wear` or `released` comes
  first (ask when there are several). Otherwise, the open app release PR's version:
  `gh pr list --repo chenasraf/pantry-flutter --state open --search 'head:release-please--' --json number,title`
  — the title is `chore(master): release <version>`. Neither → print `progress.sh list` and what's
  left (a version waiting on `/release wear` says so), and stop.

Start at `progress.sh <version> next` and go down the steps from there.

## Steps

### server-merged

- `gh release view v<version> --repo chenasraf/nextcloud-pantry` succeeds → record
  `server-merged` and `server-released` done, go to `website`.
- Otherwise find the open server release PR titled `chore(master): release <version>`
  (`gh pr list --repo chenasraf/nextcloud-pantry --state open --search 'head:release-please--' --json number,title,url`).
  None, or one for another version → stop: the app waits for a server release of the same version.
- `gh pr checks <n> --repo chenasraf/nextcloud-pantry`:
  - `release-notes / check` failing → stop, and point at `/release-notes` in
    `~/Dev/nextcloud-apps/pantry`.
  - Any check pending → say which, and wait for it (poll as in [Waiting](#waiting)).
  - Another check failing → show it and ask whether to go on.
- Show the PR link and its `release-notes/<version>/appstore.md` (from the PR branch:
  `gh api repos/chenasraf/nextcloud-pantry/contents/release-notes/<version>/appstore.md?ref=<branch> --jq .content | base64 -d`),
  and ask "Merge the server release PR? It publishes to the Nextcloud App Store." with
  AskUserQuestion. Only a yes merges: `gh pr merge <n> --repo chenasraf/nextcloud-pantry --rebase`.
  Record `server-merged` with the PR number.

### server-released

Wait for the `Release` workflow run on the merge commit
(`gh run list --repo chenasraf/nextcloud-pantry --workflow release.yml --commit <sha> --event push`)
to finish, then check that `gh release view v<version>` exists and the run's
`Release to Nextcloud Apps` job succeeded (`gh run view <id> --json jobs`). A failed job → record
`fail` with the job's URL and stop.

### website

Publish the docs website, so the docs for what this server release shipped on the web go live with
it. The website lives in the server repo and never deploys on a push, so docs merged since the last
deploy are waiting for this. No confirmation needed: it only rebuilds the site from master.

- `gh workflow run deploy-website.yml --repo chenasraf/nextcloud-pantry --ref master`, with no
  `app_version`: the download links resolve to the latest published app release, which is still
  the previous one. The app's own release dispatches the website again once its assets are up, so
  the links move to the new version then.
- Find the run it started
  (`gh run list --repo chenasraf/nextcloud-pantry --workflow deploy-website.yml --event workflow_dispatch --limit 1 --json databaseId,status,createdAt`)
  and wait for it (see [Waiting](#waiting), capped at 15 minutes).
- Success → record `website` done with the run URL. Failure → record `fail` with the run URL, show
  the failed job, and ask whether to go on to the app. A broken docs deploy doesn't block the app.

### parity

`gh release view v<version> --repo chenasraf/nextcloud-pantry --json tagName,isDraft` exists and
isn't a draft. Missing → stop; never go on to the app without it. This is a version match only: no
feature-gate analysis.

### app-merged

The same as `server-merged`, on `chenasraf/pantry-flutter`:

- Tag `v<version>` already exists (`gh release view v<version> --repo chenasraf/pantry-flutter`)
  → record done, go to `app-released`.
- Open release PR for this version, `release-notes / check` green (red → `/release-notes` here),
  other checks as above.
- Show the PR link and the four store notes from the PR branch
  (`release-notes/<version>/{play,wear,ios,macos}.txt`), ask "Merge the app release PR?", and only on
  a yes `gh pr merge <n> --repo chenasraf/pantry-flutter --rebase`.

### app-released

Wait for the `CI/CD` run (`release.yml`) on the merge commit to finish, then
`"$SKILL/scripts/assets.sh" <version>`. Missing assets → show the failed jobs of the run and ask
whether to rebuild them with
`gh workflow run release.yml --repo chenasraf/pantry-flutter -f release_tag=v<version> -f targets=<platforms>`
(the workflow's own vocabulary: android, wear, fdroid, macos, linux, windows) or to go on without.
Record done once the assets are there or the user chose to go on (note which are missing).

### Check out the tag

The store lanes build from the working tree, so it has to be the tagged commit:

- `git status --porcelain` must be empty (ignored files like `.scratch/` and signing keys don't
  count). Otherwise stop and say what's uncommitted; never stash or discard it.
- `git fetch --tags origin && git switch --detach v<version>`, then check `pubspec.yaml`'s version
  is `<version>`.
- When the run ends (done, failed or stopped), `git switch master`.

### notes

`.claude/skills/release-notes/scripts/check.sh "$PWD" <version>` — the same rules as
`release-notes-check`, against the tagged tree. A failure → stop and point at `/release-notes`.

### play, ios, macos

Show the plan once and confirm it with AskUserQuestion:

```
Pantry <version> from tag v<version>:
  1. Google Play phone, production   make android-deploy
  2. App Store, submit for review    make ios-deploy DEST=appstore STATUS=completed
  3. Mac App Store, submit for review make macos-deploy DEST=appstore STATUS=completed
Wear OS waits for /release wear.
```

When the release has nothing for the watch — every item in `release-notes/<version>/full.md` is
marked with platforms that don't reach `wear` in `release-notes/config.yml`, and
`git diff --name-only v<last>..v<version> -- packages/pantry_wear` lists only `pubspec.lock` — the
plan's last line is `Wear OS: skipped, nothing changes on the watch.` instead. Once the user
confirms the plan, record `progress.sh <version> done wear 'skipped: nothing for the watch'` and
skip [Park Wear](#park-wear) entirely.

Leave out the steps already done. Then run them one at a time, in that order, each with
`run_in_background: true` (a build takes many minutes) and its output through `tee`:

```bash
set -o pipefail; make android-deploy 2>&1 | tee .scratch/release/<version>-play.log
```

Wait for each to finish before starting the next. Success → `progress.sh done <step>`. Failure →
read the log, `progress.sh fail <step> '<one-line cause>'`, stop the run, and report it.

Re-running a step is safe: the iOS and macOS lanes skip a binary App Store Connect already has.
Google Play instead rejects the upload with "Version code … has already been used": that means the
phone build from the earlier run went through, so record `play` done with that note.

Never use `make deploy-production`: it uploads Wear with the phone.

### Park Wear

Switch back to master, then schedule two reminders with `ntfy-remind` (see the `ntfy` skill), one
hour and two hours after the phone upload. Play review of a phone build usually takes that long,
and the session is likely closed by then, so they fire from the machine on their own:

```bash
R="$HOME/.dotfiles/.local/bin/ntfy-remind"
for when in 1h 2h; do
  "$R" add --in "$when" -T 'Pantry <version> Wear' \
    'Pantry <version>: check the phone build is live on Google Play, then run /release wear in pantry-flutter'
done
```

The title `Pantry <version> Wear` is how [Wear](#wear) finds them again, so keep it exact.

End with what shipped, where, what's left, and the two reminder ids and times `add` printed.

## Wear

`/release wear [version]`:

1. The version: the one from `progress.sh list` whose next step is `wear` (ask when there are
   several, or use the one given). `play` must be done; otherwise refuse and say which step is next.
2. Ask one yes/no with AskUserQuestion: "Is Pantry <version> live on Google Play for phones?" Neither
   the public listing nor the Play API shows review state, so the answer is the user's. No → stop
   and record nothing.
3. Check out the tag and run `notes` as above, then, in the background,
   `set -o pipefail; make wear-deploy 2>&1 | tee .scratch/release/<version>-wear.log`. The
   "Version code … has already been used" rule applies here too.
4. Record `wear`, switch back to master, and send a done notification (`white_check_mark`).
5. Remove the Wear reminders that haven't fired yet, with `R` as in [Park Wear](#park-wear):
   `"$R" list --json | jq -r '.[] | select(.title == "Pantry <version> Wear") | .id'`, then
   `"$R" rm` those ids. None left is fine.

## Waiting

For a PR check or a workflow run, poll in a background Bash command that sends the ntfy itself when
it finishes or gives up, as the `ntfy` skill describes (30 s interval, capped at an hour for the
server and two hours for the app's build run). Carry on with the next step when its notification
arrives.

## Rules

- No merge without a yes for that PR in this run. Never `--admin`, never merge a PR with a red
  `release-notes / check`.
- Release PRs merge with `--rebase`, never `--squash`.
- A red `release-notes / check` whose notes are already on master ran before they landed:
  release-please doesn't push its branch for a `chore` commit, and re-running the job reuses the
  old merge commit. Wait until the PR's `merge_commit_sha` (`gh api repos/<repo>/pulls/<n>`) sits
  on the current master, then close and reopen the PR to start a fresh run.
- Server before app, parity before any store, phone before Wear: never reorder or skip a step, even
  when asked to "just upload". The one exception is Wear in a release with nothing for the watch
  (see [play, ios, macos](#play-ios-macos)).
- Linux, Windows and F-Droid are built and published by CI and F-Droid from the tag; this skill only
  checks their assets exist.
- Never stash, reset or discard changes in either repo; a dirty tree stops the run.
