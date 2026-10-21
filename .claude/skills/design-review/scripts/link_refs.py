#!/usr/bin/env python3
"""Find (and optionally link) bare page-id references such as "D08", "F06 §2" or "S02".

Usage: link_refs.py <review-folder> [--fix]

A page id is the prefix of a note named "<letter><two digits> <title>" (D08 Low-stock sync,
F06 …, S02 …). Every mention of an id in prose should be a link. Without --fix, bare mentions
are reported and the exit code is 1 when any exist. With --fix they are rewritten in place:

    D08          -> [[D08 Low-stock sync|D08]]
    D08 §4       -> [[D08 Low-stock sync#4 · Quantity|D08 §4]]   (when a heading "4 · …" or "4 …" exists)
    (in tables)  -> the alias pipe is escaped as \\|

Skipped: frontmatter, headings, fenced code (incl. mermaid), inline code, existing [[links]],
and any line containing #review (the reviewer's own comments are never edited).
"""
import glob
import os
import re
import sys

# A "/" right after a word char is a path (adr/D01); after "]]" or a space it separates ids (D08/D09).
ID_RE = re.compile(r"(?<![\w\[#|])(?<!\w/)([A-Z]\d{2})(?:\s*§\s*(\d+)((?:[–-]\d+)?))?(?![\w])")
# A page link followed by a bare section: [[D10 Expiry date]] §9 → link the section itself.
PAGE_THEN_SECTION_RE = re.compile(
    r"\[\[([A-Z]\d{2} [^\]|#\\]+)(?:\\?\|([^\]]*))?\]\]\s*§\s*(\d+)((?:[–-]\d+)?)"
)
SKIP_SPANS = re.compile(r"\[\[.*?\]\]|`[^`\n]*`|\]\([^)\s]*\)")
UNRESOLVED = []


def load_notes(root):
    notes, headings = {}, {}
    for path in glob.glob(os.path.join(root, "**", "*.md"), recursive=True):
        name = os.path.splitext(os.path.basename(path))[0]
        m = re.match(r"([A-Z]\d{2}) ", name)
        if m:
            notes[m.group(1)] = name
        with open(path, encoding="utf-8") as fh:
            headings[name] = [h.strip() for h in re.findall(r"^#+\s+(.*)$", fh.read(), re.M)]
    return notes, headings


def section_heading(headings, note, num):
    """The heading for section `num`: "4 · …", or a range heading like "2–3 · …"."""
    n = int(num)
    for h in headings.get(note, []):
        m = re.match(r"(\d+)(?:[–-](\d+))?\s*·", h)
        if m and int(m.group(1)) <= n <= int(m.group(2) or m.group(1)):
            return h
    return None


def link_segment(seg, notes, headings, in_table, found):
    def repl(m):
        pid, sec, rng = m.group(1), m.group(2), m.group(3) or ""
        note = notes.get(pid)
        if not note:
            return m.group(0)
        found.append(m.group(0))
        pipe = "\\|" if in_table else "|"
        label = m.group(0)
        target = note
        if sec:
            h = section_heading(headings, note, sec)
            if h:
                target = f"{note}#{h}"
            else:
                # No matching heading: link the page, keep the § text outside the link.
                UNRESOLVED.append(f"{note}: no heading for §{sec} ({m.group(0)})")
                return f"[[{note}{pipe}{pid}]] §{sec}{rng}"
        return f"[[{target}{pipe}{label}]]"

    return ID_RE.sub(repl, seg)


def process(path, notes, headings, fix):
    with open(path, encoding="utf-8") as fh:
        lines = fh.read().split("\n")
    out, hits = [], []
    in_front = lines[:1] == ["---"]
    in_fence = False
    for i, line in enumerate(lines):
        if in_front:
            out.append(line)
            if i > 0 and line == "---":
                in_front = False
            continue
        if line.lstrip().startswith("```"):
            in_fence = not in_fence
            out.append(line)
            continue
        if in_fence or line.startswith("#") or "#review" in line:
            out.append(line)
            continue
        in_table = line.lstrip().startswith("|")
        found = []

        def page_section(m):
            note, alias, sec, rng = m.group(1), m.group(2), m.group(3), m.group(4) or ""
            h = section_heading(headings, note, sec)
            if not h:
                UNRESOLVED.append(f"{os.path.basename(path)}:{i + 1}: {m.group(0)}")
                return m.group(0)
            found.append(m.group(0))
            pipe = "\\|" if in_table else "|"
            return f"[[{note}#{h}{pipe}{alias or note} §{sec}{rng}]]"

        line = PAGE_THEN_SECTION_RE.sub(page_section, line)
        pieces, last = [], 0
        for m in SKIP_SPANS.finditer(line):
            pieces.append(link_segment(line[last:m.start()], notes, headings, in_table, found))
            pieces.append(m.group(0))
            last = m.end()
        pieces.append(link_segment(line[last:], notes, headings, in_table, found))
        if found:
            hits.append((i + 1, found))
        out.append("".join(pieces))
    if fix and hits:
        with open(path, "w", encoding="utf-8") as fh:
            fh.write("\n".join(out))
    return hits


def main(root, fix):
    notes, headings = load_notes(root)
    total = 0
    for path in sorted(glob.glob(os.path.join(root, "**", "*.md"), recursive=True)):
        for lineno, found in process(path, notes, headings, fix):
            total += len(found)
            print(f"{os.path.relpath(path, root)}:{lineno}: {', '.join(found)}")
    verb = "linked" if fix else "bare"
    print(f"{total} {verb} references")
    for w in UNRESOLVED:
        print(f"unresolved section: {w}")
    if UNRESOLVED:
        print(f"{len(UNRESOLVED)} section references have no matching 'N · …' heading")
    return 0 if (fix or total == 0) and not UNRESOLVED else 1


if __name__ == "__main__":
    args = [a for a in sys.argv[1:] if a != "--fix"]
    if len(args) != 1:
        sys.exit(__doc__)
    sys.exit(main(args[0], "--fix" in sys.argv))
