---
name: name-availability
description: Verify availability of a candidate name (project, product, package, brand) across GitHub, domains, package registries, social handles, trademarks, and existing-product collisions. Use when the user asks "is X taken?", wants to check a name, or is brainstorming names — including proactively before they get attached to a candidate.
---

# Name Availability

Verify a candidate name systematically across all the axes that matter, using deterministic checks (WHOIS, DNS, registry APIs) before reporting anything as taken. **Hallucinated ownership claims are the #1 failure mode of this kind of research** — the procedure below exists to prevent them.

## When to invoke

- "Is `X` taken?" / "Check availability of `X`."
- "Can I use `X` as a project name?"
- "Verify name availability for `X`."
- User proposes a new project/product/package name — run this proactively to validate before they commit emotionally.

## Inputs to extract

Required:
- **Candidate name** (or several to compare in parallel).

Required-by-inference — extract from project context, or ask once if unclear:
- **Space / industry** — drives TLD selection, trademark class, and competitor search.
- **Stack** — drives package registry selection.

Optional:
- **Geographic scope** for trademark (default: USPTO + EUIPO; add JPO/CIPO/etc. if project has specific markets).

## Customizing TLDs and registries per invocation

The script defaults are a baseline (`com dev app io org co tv` for TLDs; `npm pub.dev crates.io pypi` for registries). **Always extend them based on what the project is** — defaults exist only so the script runs without arguments, not as a recommendation.

### TLD mapping by space

| Space | Add these TLDs |
|---|---|
| Streaming / media / entertainment / video | `tv` (already in default), `co` (already in default) — defaults sufficient |
| Developer tools / DX / CLI | `sh`, `dev` (already in default) |
| AI / ML / data | `ai` |
| Gaming | `gg`, `games` |
| Fintech / payments / banking | `finance`, `money` |
| Health / medical | `health`, `care` |
| Open source / community | `org` (already in default) — defaults sufficient |
| Hardware / IoT / robotics | `io` (already in default) — defaults sufficient |
| Generic SaaS / web app | defaults sufficient |

If the project targets specific countries, also add the relevant ccTLDs (e.g. `de` for Germany, `co.uk` for UK, `jp` for Japan).

### Registry mapping by stack

| Stack | Add these registries |
|---|---|
| Go (especially CLI tools) | `homebrew` |
| Flutter / Dart | `pub.dev` (already in default) |
| JS / TS / Node | `npm` (already in default) |
| Rust | `crates.io` (already in default), `homebrew` |
| Python | `pypi` (already in default) |
| Ruby | `rubygems` |
| PHP | `packagist` |
| C / C++ / native CLI | `homebrew` |
| Java / Kotlin | (Maven Central — not in script; check manually) |
| Mixed / unknown | defaults are fine |

### Example invocations

```bash
# Streaming media app (Go + Flutter):
check.sh kamerie --tlds "com dev app io org co tv" --registries "pub.dev crates.io pypi homebrew"

# AI/ML developer tool (Python):
check.sh foo --tlds "com dev app io org ai sh" --registries "pypi npm homebrew"

# Mobile-first gaming app (mixed stack):
check.sh bar --tlds "com app io gg games co" --registries "npm pub.dev"
```

### Required workflow step

Before running the script, **announce the chosen TLDs and registries** to the user with one-line reasoning ("Adding `.tv` because the project is media/streaming"). This lets the user override before the lookup runs, and documents why specific TLDs were chosen in the eventual report.

## Procedure

### 1. Run the deterministic helper script

```
bash ~/.claude/skills/name-availability/scripts/check.sh <name> \
  [--tlds "com dev app"] \
  [--registries "npm pub.dev crates.io pypi"]
```

Output format (one line per axis):

```
axis|status|detail
```

Status values: `available`, `unregistered`, `exists`, `registered`, `unknown`, `manual-check`.

The script handles: domains (WHOIS + DNS), GitHub org/user, package registries (npm/pub.dev/crates.io/PyPI/RubyGems/Packagist/Homebrew), Mastodon, Bluesky.

### 2. Cross-check anything reported as taken

- **Domain registered with no NS records** = parked or expired-but-not-released. Note this — these sometimes drop and become available later.
- **GitHub org exists** → fetch `https://api.github.com/orgs/<name>` for repo count + creation date + last activity. **A dormant org from years ago may belong to the user themselves.** Ask before treating as a collision.
- **Package exists** → check last-publish date and reverse dependencies. An abandoned 5-year-old single-publish package is very different from an actively used one.

### 3. Run the LLM-judgment axes

Web search for:
- `"<name>"` (bare term in quotes) — find what dominates SEO for the bare term.
- `"<name>" <space>` — space-specific collisions.
- `"<name>" trademark` — surface registered marks if any are indexed.

Note any active personal brand, podcast, influencer, or company that will share the SEO real estate even without formal collision. They affect bare-name search ranking forever.

### 4. Trademark — flag as user action

Trademark databases aren't reliably scrapable from a sandbox. **Always tell the user to do a 5-minute manual check at:**
- USPTO: <https://tmsearch.uspto.gov> (default classes: 9 software, 41 entertainment, 42 SaaS — adjust to project space)
- EUIPO TMView: <https://www.tmdn.org/tmview>

Don't claim trademark status you can't directly verify.

### 5. Linguistic / pronunciation

For non-English-origin names, check pronunciation, embarrassing meanings, and adjacent-word confusion in major languages (English, Spanish, French, German, Hebrew, Arabic, Mandarin, Japanese — plus markets specific to the project). Note phonetic distance and stress pattern, not just visual similarity.

## How to report

Output a markdown scorecard:

```
| Axis | Status | Detail |
|---|---|---|
| GitHub org `github.com/<name>` | ✅/⚠️/❌ | one-line evidence |
| Domains | ✅/⚠️/❌ | which TLDs available, which taken |
| Package registries | ✅/⚠️/❌ | per-registry result |
| Social handles | ✅/⚠️/❓ | per-platform result |
| Trademark | ❓ | "5-min manual check at <links>" |
| Existing companies/products | ✅/⚠️/❌ | active personal brand? competitor in space? |
| Linguistic / pronunciation | ✅/⚠️ | brief note |
```

Then:
- **Recommendation:** ✅ proceed · ⚠️ proceed-with-caveats · ❌ pick-different-name — with one-paragraph reasoning.
- **Still unverified:** explicit bulleted list of items the user should manually check.
- **Sources:** linked.

## Pitfalls to avoid (lessons learned the hard way)

1. **Don't trust web-search snippets as evidence of domain ownership.** A snippet saying "Person X has a podcast" doesn't prove Person X owns the .com. **Always verify with `whois -h whois.verisign-grs.com <domain>` or NS lookup.** This is the #1 hallucination this skill exists to prevent.
2. **macOS default `whois` returns TLD-level boilerplate** instead of registrar-specific data. Use `whois -h whois.verisign-grs.com` for `.com`/`.net` to get authoritative answers — the helper script does this automatically.
3. **Reddit / X / Instagram return 200 OK or redirects for non-existent handles** (anti-bot). Mark `❓ couldn't verify` rather than `✅ available`.
4. **PyPI web pages return 200 for many paths** (anti-scrape). Use the JSON API (`pypi.org/pypi/<name>/json`) — clean 404s.
5. **An existing GitHub org might be the user's own old project.** A dormant org with zero stars and old repos is suspicious — confirm before treating as a collision.
6. **Be honest about ❓ vs ❌.** Conflating them produces false negatives that lead users to abandon viable names.

## Proactive use

When the user proposes a project name without explicitly asking to check it, run this skill anyway. Ten minutes of verification beats six months of building under a name that's trademark-conflicted or already SEO-dominated by an active personal brand.
