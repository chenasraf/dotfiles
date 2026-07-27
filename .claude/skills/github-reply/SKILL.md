---
name: github-reply
description: This skill should be used when generating replies, comments, or responses in chenasraf's voice for GitHub (issues, discussions, PRs, review comments) or similar developer forums. It captures chenasraf's authentic writing style and writes each draft to a .scratch/ markdown file for reliable copy-paste. Triggers when the user (github username chenasraf) asks to "draft a reply", "respond to this issue", "write a comment", "reply as me", etc.
---

# GitHub Reply

## Overview

Generate GitHub replies (issues, discussions, PRs, review threads, dev forums) that sound like
chenasraf actually wrote them, not like an LLM. The skill bundles a voice guide derived from
hundreds of his authentic pre-2025 comments, and always saves drafts to a `.scratch/` file because
copying multi-line markdown out of the terminal drops words and formatting.

## When to use

Use whenever the user asks to write, draft, or reply to something on GitHub or a similar platform
in his own name. Also use for editing/tightening a reply he already drafted so it matches his voice.

## Hard rules (never violate)

- **No em-dashes.** Use only regular hyphens (`-`) and colons (`:`). This is a user rule AND the
  strongest authenticity tell.
- **No LLM formatting.** No `### headers` inside a comment, no escaped lists (`1\.`), no
  `* **Bolded lead-ins:**`, no corporate filler ("incredibly helpful", "bringing this to my
  attention", "I hope this helps").
- **Always write drafts to a file** in `.scratch/`, never only inline in chat.

## Workflow

1. **Gather context.** Read the thread being replied to. If given a URL or issue/PR number, use the
   `gh` CLI to fetch it (`gh issue view`, `gh pr view`, `gh api ...`). Understand who is being
   addressed, whether chenasraf is the maintainer or the reporter here, and what outcome the reply
   needs (acknowledge a bug, ask for repro, announce a fix, decline a feature, thank someone, etc.).

2. **Load the voice guide.** Read `references/voice-guide.md` and apply it. Key points: warm and
   humble as a maintainer, terser as a reporter; `Hi @user,` greetings; heavy `:)` and `🙏🏼`;
   constant thanks and offers to keep helping; bimodal length (one-liner status vs. multi-paragraph
   help); recurring phrases like "Thanks for the report!", "I'll look into it", "sorry for the
   delay", "please let me know if it still causes issues".

3. **Draft to a scratch file.** Ensure `.scratch/` exists (see setup below), then write the reply
   to a new `.md` file there, e.g. `.scratch/reply-<short-slug>.md`. Put ONLY the reply body in the
   file so it can be copied verbatim. If asked for multiple options, write them to one file under
   clear `## Option 1` / `## Option 2` separators (those headers are file organization for the
   user, not part of any single reply).

4. **Report back.** Tell the user the file path and give a 1-line summary of the reply's angle. Keep
   the full reply in the file, not pasted back into chat (that defeats the purpose).

5. **Run the self-check** from the voice guide before delivering: no em-dashes, no LLM formatting,
   no filler, has a `:)`/thanks where natural, as short as it should be.

## .scratch setup

Drafts go in the current repository's `.scratch/` folder (chosen so terminal copy-paste of markdown
stays intact). Before writing the first draft in a repo:

1. Check whether `.scratch/` exists. If not, create it.
2. If it was just created, add it to the repo's **local git excludes** (`.git/info/exclude`), NOT
   `.gitignore` (keep it out of the tracked project). Append a `.scratch/` line if not already present.

Example:

```bash
mkdir -p .scratch
grep -qxF '.scratch/' .git/info/exclude 2>/dev/null || echo '.scratch/' >> .git/info/exclude
```

If not inside a git repository, still write to `.scratch/` in the working directory and mention that
git excludes were skipped.

## Notes on authenticity

His newer (2025-11 onward) comments show LLM hallmarks he wants avoided (section headers, escaped
lists, "incredibly helpful"). The voice guide is calibrated on his 2015-2024 writing, which is the
target. When unsure, err toward shorter, more casual, more human.

## Resources

- `references/voice-guide.md` - detailed style rules, recurring phrases, emoji/punctuation habits,
  how he says no, and a pre-delivery self-check. Load it every time before drafting.
