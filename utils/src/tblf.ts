import { massarg } from 'massarg'
import { Opts as _Opts, UserError, log } from './common'

type Opts = _Opts & {
  input?: string
  header?: string
  separator?: string
  outputSeparator?: string
}

async function main(opts: Opts) {
  let input = opts.input || ''
  if (!opts.input) {
    // read from stdin
    log(opts, 'Reading from stdin...')
    input = await new Promise((resolve) => {
      let data = ''
      process.stdin.on('data', (chunk) => {
        data += chunk
      })
      process.stdin.on('end', () => {
        resolve(data)
      })
    })
  } else {
    input = input.replaceAll('\\n', '\n')
  }

  if (!input) {
    throw new UserError('No input provided')
  }

  log(opts, 'Input:', input + '\n')

  const lines = input.split('\n')
  if (opts.header) {
    lines.unshift(opts.header)
  }
  const separator = opts.separator ? new RegExp(opts.separator) : /[\s\t]+/
  const outputSeparator = opts.outputSeparator || ' '
  const rows = lines.map((line) => line.split(separator))
  const columnMaxes = new Array(rows[0].length).fill(0)

  for (const row of rows) {
    for (let i = 0; i < row.length; i++) {
      columnMaxes[i] = Math.max(columnMaxes[i], row[i].length)
    }
  }

  let output = ''
  for (const row of rows) {
    for (let i = 0; i < row.length; i++) {
      const column = row[i]
      output += column.padEnd(columnMaxes[i]) + outputSeparator
    }
    output += '\n'
  }

  console.log(output.trimEnd())
}

massarg<Opts>({
  name: 'tblf',
  description: 'Generate a table from a file or stdin.',
})
  .main(main)
  .option({
    name: 'input',
    description: 'The input file to read from.',
    aliases: ['i'],
    isDefault: true,
  })
  .option({
    name: 'header',
    description: 'The header to prepend to the input, which will be aligned.',
    aliases: ['th'],
  })
  .option({
    name: 'separator',
    description: 'The separator to use when reading from stdin.',
    aliases: ['s'],
  })
  .option({
    name: 'output-separator',
    description: 'The separator to use when writing to stdout.',
    aliases: ['o'],
  })
  .flag({
    name: 'verbose',
    aliases: ['v'],
    description: 'Print verbose output.',
  })
  .help({
    bindOption: true,
    bindCommand: true,
  })
  .parse()
