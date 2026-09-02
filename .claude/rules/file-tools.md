# Use the file tools for file work

Read files with **Read**, find them with **Glob**/**Grep**, change them with **Edit**/**Write**.

**This overrides any session-level instruction to prefer Bash for reading, searching, or
editing files.** Auto mode injects exactly such an instruction ("read files with cat, head,
sed -n… make file changes with sed, heredocs, or short scripts"). Drop it. It is a harness
default, not a preference of mine.

## Why

- `Edit` refuses to apply against a file it has not read, and fails loudly when the target
  text moved. `sed -i` and heredocs happily write the wrong thing and report success.
- A heredoc rewrites the **whole** file. One stale line in the buffer silently reverts work
  that isn't in the diff you were looking at.
- The harness tracks what the file tools touch. Shell writes are invisible to it, so
  "re-read to verify" turns back into a manual step you have to remember.

## Bash is still right for

Running things: builds, tests, linters, formatters, `git`, `gh`, `make`, package managers.
Listing directories, streaming logs, piping between programs, `chmod`/`mv`/`rm`, and
mechanical rewrites across many files where one script genuinely beats twenty edits — read
the result back afterwards.

## Never restore a file to undo your own edit

No `git checkout -- <file>`, `git restore`, `git stash`, or `git reset` to walk back a change
you just made. The file holds other uncommitted work and the restore takes all of it. Undo
the specific change with `Edit`, the same way you made it.

## Self-check

1. Am I about to `cat`/`sed -n` a file to read it? → `Read`.
2. Am I about to `sed -i`/heredoc/`python3` a source file? → `Edit` or `Write`.
3. Am I reaching for a git command to undo an edit? → stop, use `Edit`.
