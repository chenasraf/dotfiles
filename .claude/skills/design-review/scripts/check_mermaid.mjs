// Parse every ```mermaid block under a folder and flag left-to-right layouts.
// Run through check_mermaid.sh, which provides the mermaid + jsdom dependencies.
import { JSDOM } from 'jsdom'
import fs from 'node:fs'
import path from 'node:path'

// mermaid.parse needs a DOM (DOMPurify) even though nothing is rendered.
const dom = new JSDOM('<!doctype html><html><body></body></html>')
globalThis.window = dom.window
globalThis.document = dom.window.document
globalThis.DOMParser = dom.window.DOMParser
const { default: mermaid } = await import('mermaid')
mermaid.initialize({ startOnLoad: false })

const root = process.argv[2]
if (!root) {
  console.error('usage: check_mermaid.mjs <folder>')
  process.exit(2)
}

const walk = (dir) =>
  fs.readdirSync(dir, { withFileTypes: true }).flatMap((e) =>
    e.isDirectory() ? walk(path.join(dir, e.name)) : e.name.endsWith('.md') ? [path.join(dir, e.name)] : [],
  )

const horizontal = /^\s*(flowchart|graph)\s+(LR|RL)\b|^\s*direction\s+(LR|RL)\b|^\s*gantt\b|^\s*timeline\b/m

let total = 0
let failed = 0
for (const file of walk(root)) {
  const text = fs.readFileSync(file, 'utf8')
  for (const m of text.matchAll(/```mermaid\n([\s\S]*?)```/g)) {
    total++
    const rel = path.relative(root, file)
    if (horizontal.test(m[1])) {
      failed++
      console.log(`${rel}: horizontal layout (use flowchart TB / direction TB)`)
    }
    try {
      await mermaid.parse(m[1])
    } catch (e) {
      failed++
      console.log(`${rel}:\n  ${String(e.message).split('\n').slice(0, 4).join('\n  ')}`)
    }
  }
}
console.log(`${total} diagrams, ${failed} problems`)
process.exit(failed ? 1 : 0)
