import { massarg } from 'massarg'
import { cosmiconfig, getDefaultSearchPlaces } from 'cosmiconfig'
import * as path from 'node:path'
import * as os from 'node:os'
import { spawn } from 'node:child_process'
import { strConcat, format } from 'massarg/style'
import { MassargCommand } from 'massarg/command'
import { indent } from 'massarg/utils'

const explorer = cosmiconfig('tmux')

type TmuxConfigItem = {
  root: string
  name: string
  windows: TmuxWindowType[]
}

type TmuxWindowType = string | TmuxWindow

type TmuxWindow = {
  name?: string
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

const defaultPanes = [
  {
    dir: '.',
    cmd: 'nvim .',
  },
  { dir: '.' },
  { dir: '.' },
]

function log({ verbose }: Opts, ...content: any[]) {
  if (!verbose) return
  console.log(...content)
}

type Opts = {
  key: string
  verbose: boolean
  dry: boolean
}
async function main(opts: Opts) {
  const { key } = opts
  const config = await getTmuxConfig()
  const item = config[key]
  if (!item) {
    throw new Error(`tmux config item ${key} not found`)
  }

  const tmuxConfig = parseConfig(item)
  const { root, windows } = tmuxConfig
  log(opts, tmuxConfig)

  const commands: string[] = []

  let sessionName = nameFix(tmuxConfig.name) || key

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

async function runCommand(opts: Opts, command: string) {
  const [cmd, ...args] = command.split(' ')
  log(opts, '$ ' + command)
  if (opts.dry) return 0
  const proc = spawn(cmd, args, { stdio: 'inherit' })
  return new Promise((resolve, reject) => {
    proc.on('close', (code) => {
      if (code === 0) {
        resolve(code)
      } else {
        reject(code)
      }
    })
  })
}

async function getCommandOutput(
  opts: Opts,
  command: string,
): Promise<{ code: number; output: string }> {
  const [cmd, ...args] = command.split(' ')
  log(opts, '$ ' + command)
  if (opts.dry) return { code: 0, output: '' }
  const proc = spawn(cmd, args, { stdio: 'pipe' })
  return new Promise<{ code: number; output: string }>((resolve, reject) => {
    let output = ''
    proc.stdout.on('data', (data) => {
      output += data.toString()
    })
    proc.on('close', (code) => {
      if (code === 0) {
        resolve({ code, output })
      } else {
        reject(code)
      }
    })
  })
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
  const windows = item.windows.map((w) => {
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
    name: item.name,
    root,
    windows,
  }
  return tmuxConfig
}

function nameFix(name: string) {
  return (name || '').match(/^[^.].*[. ].*$/) ? name.split(/[. ]/).filter(Boolean)[0] : name
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
const args = Array.from(process.argv).slice(2)

massarg<Opts>({
  name: 'tmux',
  description: 'Generate layouts for tmux using presets or on-the-fly args.',
})
  .main(main)
  .command({
    name: 'list',
    aliases: ['ls'],
    description: 'List all tmux configurations and sessions',
    run: async (opts) => {
      const config = await getTmuxConfig()
      const sessions = await getCommandOutput(opts, 'tmux ls')
      console.log('tmux sessions:\n')
      console.log(indent(sessions.output))
      console.log('tmux configurations:\n')
      console.log(' - ' + Object.keys(config).join('\n - '))
    },
  })
  .command(
    new MassargCommand<{ key: string }>({
      name: 'show',
      aliases: ['s'],
      description: 'Show the tmux configuration file for a specific key',
      run: async (opts) => {
        const config = await getTmuxConfig()
        const { key } = opts
        const item = config[key]
        if (!item) {
          throw new Error(`tmux config item ${key} not found`)
        }
        console.log(item)
      },
    }).option({
      name: 'key',
      aliases: ['k'],
      description: 'The tmux session to show',
      isDefault: true,
      required: true,
    }),
  )
  .command({
    name: 'edit',
    aliases: ['e'],
    description: 'Edit the tmux configuration file',
    run: async (opts) => {
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
  .option({
    name: 'key',
    aliases: ['k'],
    description: 'The tmux session to open',
    isDefault: true,
    required: true,
  })
  .help({
    bindOption: true,
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
  .parse(args)

async function sessionExists(opts: Opts, sessionName: string): Promise<boolean> {
  try {
    const code = await runCommand({ ...opts, dry: false }, `tmux has-session -t ${sessionName}`)
    return code === 0
  } catch (error) {
    return false
  }
}
