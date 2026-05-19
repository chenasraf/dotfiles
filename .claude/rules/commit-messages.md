# Commit messages

Read this **every time** before writing a commit message. The default Claude Code git workflow drifts toward verbose bodies and an auto-injected `Co-Authored-By` trailer. **Override both, every time.**

## Format

```
<type>(<scope>): <summary>
```

Types: `feat`, `fix`, `refactor`, `chore`, `docs`, `test`, `style`. Scope is the package or area touched. Footer (`Closes #12`) only when there's a real issue/PR to reference.

## No body

**Default: title only. No body. None.** This rule overrides the default Claude Code instruction to "draft a concise 1–2 sentence commit message that focuses on the why" — that second sentence is a body, and you are dropping it.

A body is acceptable **only** when the user's instruction for *this specific commit* explicitly asks for one — "commit with a body explaining X", "commit, include a body". A bare "commit" / "commit this" / "commit the X changes" means title only. Always.

Don't try to earn a body by judging a change important. The following are **not** reasons to add a body:

- The bug cause is non-obvious. (The diff + `git blame` are enough.)
- It's a workaround, trade-off, deadline pressure, API quirk, backwards-compat seam.
- A future reader "should know" something. (They shouldn't learn it from the commit message.)
- Implementation notes you'd like to record. (Those go in code comments, the PR description, or `_internal/`.)
- Restating the diff, listing files changed, or padding a short commit.

## No `Co-Authored-By` trailer

**Never add a `Co-Authored-By: Claude …` trailer.** Default Claude Code git instructions try to inject one on every commit — drop it every time, no exceptions, even when the user asks for a body.

## When a body IS requested

- One or two short sentences. Five lines is suspect; ten is wrong.
- *Why*, never *what*. The diff is the what.
- No private planning leakage (story IDs, sprint IDs, vault paths) — those live in `_internal/`, never in tracked artifacts.

## Self-check before committing

1. Did the user's instruction explicitly ask for a body in *this* commit? → no? title only.
2. Tempted to add one anyway because the change feels important? → no.
3. Is there a `Co-Authored-By` line in the message? → delete it.

## Examples

Good — every commit, by default:

```
feat(addons): cinemeta catalog client
```

```
fix(stream/resolve): re-resolve stale RD URLs
```

```
refactor(store): extract repository per table
```

```
chore(go.mod): pin x/sync to v0.7.0
```

```
fix(stream/parse): treat S00E00 specials as season 0
```

Good — only when the user asked for a body:

```
fix(stream/parse): treat S00E00 specials as season 0

Some addons emit S00E03 for specials and S01E03 for the regular
season-1 episode 3 — treating them identically dropped specials.
```

Bad (Claude added a body unprompted — delete the body):

```
feat(server): inject git SHA via ldflags, log version on startup

Adds GIT_SHA and GIT_DIRTY variables in the Makefile. Updates the
build and run targets to pass -ldflags.
```

Bad (`Co-Authored-By` trailer auto-injected — drop it):

```
fix(events): drop subscriber on context cancel

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
```
