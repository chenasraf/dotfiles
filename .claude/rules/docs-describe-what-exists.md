# Docs & comments describe what exists

Applies to everything a reader sees: code comments, docstrings, README, docs,
website copy, error messages.

## Never leak the plan

Readers of the code are users too, and users don't care about the plan. Never write:

- Which phase / sprint / PR implements what, or what is planned next
- **Planning units** — *MVP*, *POC*, *prototype*, *phase*, *stage*, *sprint*,
  *milestone*, *iteration*, *epic*, *roadmap*, *backlog*, *scope* / *out of scope* /
  *non-goal*, ticket and issue numbers
- **Deferral** — *for now*, *currently*, *initially*, *at this point*, *first pass*,
  *interim*, *stopgap*, *temporary*, *placeholder*, *stub*, *minimal*, *basic*,
  *not yet*, *eventually*, *later*, *future work*, *coming soon*, *planned*,
  *deferred*, *TODO* in prose
- **History and novelty** — *new*, *improved*, *rewritten*, *refactored*,
  *migrated from*, *legacy*, *old*, *previously*, *used to*, *no longer*,
  *now uses*, *as of writing*

Each word is banned only in the work sense: a state machine may have *phases*, a
buffer may be *temporary*, a system you integrate with may genuinely be *legacy*.

Describe only what exists, in the present tense, as if it had always been this way.
Plans live where plans live (issues, the PR description, `_internal/`) — never in
tracked artifacts.

## Why, not how

The code already says *how*, and prose that restates it rots. Write a comment only
when the code can't speak for itself: a decision that looks counter-intuitive
without its reason, a constraint, a workaround and what forced it.

## Self-check

1. Does this reference work not yet done, or the order work happened in? → delete it.
2. Does it restate the lines below it? → delete it.
3. Does it explain why something surprising is the way it is? → keep it.
