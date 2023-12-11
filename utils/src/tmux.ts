import { massarg } from 'massarg'
import { cosmiconfig } from 'cosmiconfig'
import * as path from 'node:path'
import * as os from 'node:os'
import { spawn } from 'node:child_process'

const explorer = cosmiconfig('tmux')

type TmuxConfigItem = {
  root: string
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

  let sessionName = key
  commands.push(
    `tmux -f ~/.config/.tmux.conf new-session -d -s ${sessionName} -n general -c ${root}`,
  )
  for (const window of windows) {
    const dir = window.dir
    const windowName = window.name || path.basename(dir).replaceAll(/[^a-z0-9_\-]+/i, '_')
    const [firstPane, ...restPanes] = window.panes
    commands.push(`tmux new-window -n ${windowName} -c ${dir}`)
    const cmd = firstPane.cmd ? transformCmdToTmuxKeys(firstPane.cmd) : null
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
        name: w,
        dir: dirFix(path.resolve(root, w)),
        panes: defaultPanes,
      }
    }
    return {
      name: w.name,
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
    root,
    windows,
  }
  return tmuxConfig
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

massarg<Opts>({ name: 'utils', description: 'RTFM' })
  .main(main)
  .flag({
    name: 'verbose',
    aliases: ['v'],
    description: 'Verbose logs',
    negatable: true,
  })
  .option({
    name: 'key',
    aliases: ['k'],
    description: 'The tmux session to open',
    isDefault: true,
    required: true,
  })
  .parse(process.argv.slice(2))
