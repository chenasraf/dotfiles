import { massarg } from 'massarg'
import { cosmiconfig, getDefaultSearchPlaces } from 'cosmiconfig'
import * as path from 'node:path'
import * as os from 'node:os'
import { strConcat, format } from 'massarg/style'
import { MassargCommand } from 'massarg/command'
import { indent } from 'massarg/utils'
import * as util from 'node:util'
import * as fs from 'node:fs/promises'
import { Opts, getCommandOutput, log, runCommand } from './common'

const explorer = cosmiconfig('tmux')

type TmuxConfigItem = {
  root: string
  name: string
  windows: TmuxWindowType[]
}

type TmuxWindowType = string | TmuxWindow

type TmuxWindow = {
  name: string
  dir: string
  layout?: 'default'
  panes: TmuxPaneType[]
}

type TmuxPaneType = string | TmuxPane

type TmuxPane = {
  dir: string
  cmd?: string
}

type ConfigFile = Record<string, TmuxConfigItem>

type ParsedTmuxConfigItem = Omit<TmuxConfigItem, 'windows'> & { windows: ParsedTmuxWindow[] }

type ParsedTmuxWindow = Omit<TmuxWindow, 'panes'> & { panes: TmuxPane[] }

const defaultLayout: TmuxLayout = {
  type: 'row',
  zoom: true,
  children: [
    {
      type: 'column',
      children: [{ type: 'pane' }, { type: 'pane' }],
    },
  ],
}

type TmuxLayoutType = 'row' | 'column' | 'pane'

type TmuxLayout =
  | {
    type: Exclude<TmuxLayoutType, 'pane'>
    children: TmuxLayout[]
    zoom?: boolean
  }
  | {
    type: 'pane'
    zoom?: boolean
  }

const defaultPanes = [
  {
    dir: '.',
    cmd: 'nvim .',
  },
  { dir: '.' },
  { dir: '.' },
]

async function main(opts: Opts) {
  const { key } = opts
  const config = await getTmuxConfig()
  const item = config[key]
  if (!item) {
    throw new Error(`tmux config item ${key} not found`)
  }

  const tmuxConfig = parseConfig(item)
  createFromConfig(opts, tmuxConfig)
}

async function createFromConfig(opts: Opts, tmuxConfig: ParsedTmuxConfigItem) {
  const { root, windows } = tmuxConfig
  log(opts, 'Config:', tmuxConfig)

  const commands: string[] = []

  let sessionName = tmuxConfig.name

  log(opts, 'Session name:', sessionName)

  if (await sessionExists(opts, sessionName)) {
    log(opts, `tmux session ${sessionName} already exists, attaching...`)
    await runCommand(opts, `tmux attach -t ${sessionName}`)
    return
  }

  log(opts, `tmux session ${sessionName} does not exist, creating...`)

  commands.push(
    `tmux -f ~/.config/.tmux.conf new-session -d -s ${sessionName} -n general -c ${root}`,
  )
  commands.push(`tmux split-window -h -t ${sessionName} -c ${root}`)
  commands.push(`tmux select-pane -t 0`)
  for (const window of windows) {
    const dir = window.dir
    const windowName = window.name || nameFix(path.basename(dir))
    const [firstPane, ...restPanes] = window.panes

    log(opts, 'Window name:', windowName)

    const cmd = firstPane.cmd ? transformCmdToTmuxKeys(firstPane.cmd) : null
    commands.push(`tmux new-window -n ${windowName} -c ${dir}`)
    if (cmd) {
      commands.push(`tmux send-keys -t ${sessionName}:${windowName} ${cmd} Enter`)
    }

    let direction = '-h'
    for (const pane of restPanes) {
      const cmd = pane.cmd ? transformCmdToTmuxKeys(pane.cmd) : ''
      commands.push(
        `tmux split-window ${direction} -t ${sessionName}:${windowName} -c ${dir} ${cmd}`.trim(),
      )
      direction = '-v'
    }
    commands.push(`tmux select-pane -t 0`)
    commands.push(`tmux resize-pane -Z`)
  }

  commands.push(`tmux select-window -t ${sessionName}:1`)

  for (const command of commands) {
    await runCommand(opts, command)
  }

  await runCommand(opts, `tmux attach -t ${sessionName}`)
}

function transformCmdToTmuxKeys(cmd: string): string {
  let string = ''
  const map: Record<string, string> = {
    ' ': 'Space',
    '\n': 'Enter',
  }
  for (const letter of cmd.split('')) {
    string += map[letter] ? ` ${map[letter]} ` : letter
  }
  return string.toString()
}

function parseConfig(item: TmuxConfigItem): ParsedTmuxConfigItem {
  const dirFix = (dir: string) => dir.replace('~', os.homedir())
  const root = dirFix(item.root)
  const windows = (item.windows || []).map((w) => {
    if (typeof w === 'string') {
      return {
        name: nameFix(path.basename(path.resolve(root, w))),
        dir: dirFix(path.resolve(root, w)),
        panes: defaultPanes,
      }
    }
    return {
      name: nameFix(w.name || dirFix(path.basename(path.resolve(root, w.dir)))),
      dir: path.resolve(root, w.dir),
      panes: w.panes
        ? w.panes.map((p) => {
          if (typeof p === 'string') {
            return {
              dir: dirFix(path.resolve(root, w.dir, p)),
            }
          }
          return {
            dir: dirFix(path.resolve(root, w.dir, p.dir)),
            cmd: p.cmd,
          }
        })
        : defaultPanes,
    }
  })
  const tmuxConfig = {
    name: item.name || path.basename(root),
    root,
    windows,
  }
  return tmuxConfig
}

function nameFix(name: string) {
  return (name || '').includes('.') ? name.split('.').filter(Boolean)[0] : name
}

async function getTmuxConfig() {
  const searchIn = [process.cwd(), os.homedir()]
  for (const dir of searchIn) {
    const result = await explorer.search(dir)
    if (result) {
      return result.config as ConfigFile
    }
  }
  throw new Error('tmux config file not found')
}

async function sessionExists(opts: Opts, sessionName: string): Promise<boolean> {
  try {
    const { code } = await getCommandOutput(
      { ...opts, dry: false },
      `tmux has-session -t ${sessionName}`,
    )
    return code === 0
  } catch (error) {
    return false
  }
}

async function addSimpleConfigToFile(opts: CreateOpts, config: ParsedTmuxConfigItem) {
  const file = await explorer.search()
  if (!file) {
    throw new Error('tmux config file not found')
  }
  const { filepath } = file
  const existingConfig = await getTmuxConfig()
  if (existingConfig[config.name] && !opts.dry) {
    throw new Error(`tmux config item ${config.name} already exists`)
  }

  // dump config as yaml
  const contents = `
${config.name}:
  root: ${config.root}
  windows:
${config.windows.map((w) => `    - ${w.dir.replace(config.root, './')}`).join('\n')}
`
  if (opts.dry) {
    if (existingConfig[config.name]) {
      log(opts, 'Config item already exists, not saving')
    }
    log(opts, 'Dry run, not saving config')
    log(opts, 'Would have saved config to', filepath)
    log(opts, 'Contents:')
    log(opts, contents)
    return
  }
  await fs.appendFile(filepath, contents)
}

// ================================================================================
// Commands
// ================================================================================
const mainCmd = massarg<Opts>({
  name: 'tmux',
  description: 'Generate layouts for tmux using presets or on-the-fly args.',
})
  .main(main)
  .flag({
    name: 'verbose',
    aliases: ['v'],
    description: 'Verbose logs',
  })
  .flag({
    name: 'dry',
    aliases: ['d'],
    description: 'Dry run',
  })
  .option({
    name: 'key',
    aliases: ['k'],
    description: 'The tmux session to open',
    isDefault: true,
    required: true,
  })
  .help({
    bindOption: true,
    bindCommand: true,
    usageText: strConcat(
      [
        format('tmux', { color: 'yellow' }),
        format('[options]', { color: 'gray' }),
        format('[-k] <tmux session name>', { color: 'green' }),
      ].join(' '),
      [format('tmux', { color: 'yellow' }), format('<command> [options]', { color: 'gray' })].join(
        ' ',
      ),
    ),
  })

const showCmd = new MassargCommand<Opts>({
  name: 'show',
  aliases: ['s'],
  description: 'Show the tmux configuration file for a specific key',
  run: async (opts) => {
    const config = await getTmuxConfig()
    const { key } = opts
    const item = parseConfig(config[key])
    if (!item) {
      throw new Error(`tmux config item ${key} not found`)
    }
    console.log(util.inspect(item, { depth: Infinity, colors: true }))
  },
})
  .option({
    name: 'key',
    aliases: ['k'],
    description: 'The tmux session to show',
    isDefault: true,
    required: true,
  })
  .help({ bindOption: true, bindCommand: true })

const listCmd = {
  name: 'list',
  aliases: ['ls'],
  description: 'List all tmux configurations and sessions',
  run: async (opts: Opts) => {
    const rawConfig = await getTmuxConfig()
    const config = Object.fromEntries(
      Object.entries(rawConfig).map(([key, item]) => [key, parseConfig(item)]),
    )
    const sessions = await getCommandOutput(opts, 'tmux ls')
    console.log('tmux sessions:\n')
    console.log(indent(sessions.output))
    console.log('tmux configurations:\n')
    console.log(' - ' + Object.keys(config).join('\n - '))
  },
}

const editCmd = {
  name: 'edit',
  aliases: ['e'],
  description: 'Edit the tmux configuration file',
  run: async (opts: Opts) => {
    const config = await explorer.search()
    if (!config) {
      throw new Error(
        'tmux config file not found, create one in one of:\n' +
        getDefaultSearchPlaces('tmux').join('\n'),
      )
    }
    const { filepath } = config
    const editor = process.env.EDITOR || 'vim'
    await runCommand(opts, `${editor} ${filepath}`)
  },
}

const rmCmd = new MassargCommand<Opts>({
  name: 'remove',
  aliases: ['rm'],
  description: 'Remove a tmux workspace from the config file',
  run: async (opts: Opts) => {
    const { key } = opts
    const allConfigs = await getTmuxConfig()
    const configFile = await explorer.search()

    if (!configFile) {
      throw new Error('tmux config file not found')
    }
    if (!allConfigs[key]) {
      throw new Error(`tmux config item ${key} not found`)
    }
    const strContents = await fs.readFile(configFile.filepath, 'utf-8')
    const contents = strContents.split('\n')
    const index = contents.findIndex((line) => line.startsWith(key + ':'))
    log(opts, 'Index:', index)
    if (index === -1) {
      throw new Error(`tmux config item ${key} not found`)
    }
    let endIndex = contents.slice(index + 1).findIndex((line) => line.match(/^\S/))
    log(opts, 'End index:', endIndex)
    if (endIndex === -1) {
      endIndex = contents.length - index
      log(opts, 'End index set to end:', endIndex)
    }

    const newContents = contents
      .slice(0, index)
      .concat(contents.slice(index + endIndex))
      .join('\n')
      .trimEnd()

    log(opts, 'New contents:', newContents)
    log(opts, 'Filepath:', configFile.filepath)

    await fs.writeFile(configFile.filepath, newContents)
    console.log(`Removed tmux config item ${key}`)
  },
})
  .option({
    name: 'key',
    aliases: ['k'],
    description: 'The tmux session to remove',
    isDefault: true,
    required: true,
  })
  .option({
    name: 'verbose',
    aliases: ['v'],
    description: 'Verbose logs',
  })
  .help({
    bindOption: true,
    bindCommand: true,
  })

const attachCmd = new MassargCommand<Opts>({
  name: 'attach',
  aliases: ['a'],
  description: 'Attach to a tmux session',
  run: async (opts) => {
    const { key } = opts

    if (key) {
      const allConfigs = await getTmuxConfig()
      const config = parseConfig(allConfigs[key])
      const sessionName = parseConfig(config).name
      if (!(await sessionExists(opts, sessionName))) {
        throw new Error(`tmux session ${sessionName} does not exist`)
      }
      await runCommand(opts, `tmux attach -t ${sessionName}`)
      return
    }

    await runCommand(opts, `tmux attach`)
  },
})
  .option({
    name: 'key',
    aliases: ['k'],
    description: 'The tmux session to attach to',
    isDefault: true,
  })
  .help({ bindOption: true, bindCommand: true })

type CreateOpts = Opts & {
  rootDir?: string
  window?: string[]
  save?: boolean
  saveOnly?: boolean
}

const createCmd = new MassargCommand<CreateOpts>({
  name: 'create',
  aliases: ['c'],
  description: 'Create a new tmux session (temporary)',
  run: async (opts) => {
    log(opts, 'Options:', opts)
    const config = parseConfig({
      name: nameFix(path.basename(opts.rootDir ?? process.cwd())),
      root: opts.rootDir ?? process.cwd(),
      windows: opts.window ?? ['.'],
    })
    if (opts.save || opts.saveOnly) {
      addSimpleConfigToFile(opts, config)
    }
    if (opts.saveOnly) {
      return
    }
    createFromConfig(opts, config)
  },
})
  .option({
    name: 'root-dir',
    aliases: ['r'],
    description: 'The root directory to create the tmux session in',
  })
  .option({
    name: 'window',
    aliases: ['w'],
    description: 'Add a window with the given directory, relative to root',
    array: true,
  })
  .flag({
    name: 'save',
    aliases: ['s'],
    description: 'Save the tmux session to the config file',
  })
  .flag({
    name: 'save-only',
    aliases: ['S'],
    description: 'Save the tmux session to the config file without creating it',
  })
  .flag({
    name: 'verbose',
    aliases: ['v'],
    description: 'Verbose logs',
  })
  .flag({
    name: 'dry',
    aliases: ['d'],
    description: 'Dry run',
  })
  .help({ bindOption: true, bindCommand: true })

mainCmd
  .command(listCmd)
  .command(showCmd)
  .command(editCmd)
  .command(rmCmd)
  .command(createCmd)
  .command(attachCmd)
  .parse()
