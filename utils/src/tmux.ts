import { cosmiconfig } from 'cosmiconfig'
import * as path from 'node:path'
import * as os from 'node:os'
import { spawn } from 'node:child_process'
import { promisify } from 'node:util'

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

async function main() {
  const config = await getTmuxConfig()
  const key = process.argv[2]
  const item = config[key]
  if (!item) {
    throw new Error(`tmux config item ${key} not found`)
  }

  const tmuxConfig = parseConfig(item)
  const { root, windows } = tmuxConfig
  console.log(tmuxConfig)

  const commands: string[] = []

  let sessionName = key
  commands.push(
    `tmux -f ~/.config/.tmux.conf new-session -d -s ${sessionName} -n general -c ${root}`,
  )
  for (const window of windows) {
    const dir = window.dir
    const windowName = window.name || path.basename(dir)
    const [firstPane, ...restPanes] = window.panes
    commands.push(`tmux new-window -n ${windowName} -c ${dir}`)
    if (firstPane.cmd) {
      commands.push(`tmux send-keys -t ${sessionName}:${windowName} "${firstPane.cmd}"  Enter`)
    }
    let direction = '-h'
    for (const pane of restPanes) {
      const cmd = pane.cmd ? `"${pane.cmd}"` : ''
      commands.push(
        `tmux split-window ${direction} -t ${sessionName}:${windowName} -c ${dir} ${cmd}`.trim(),
      )
      direction = '-v'
    }
    commands.push(`tmux select-pane -t 0`)
    commands.push(`tmux resize-pane -Z`)
  }

  commands.push(`tmux select-window -t ${sessionName}:1`)
  commands.push(`tmux attach`)

  for (const command of commands) {
    await runCommand(command)
  }
}

async function runCommand(command: string) {
  const [cmd, ...args] = command.split(' ')
  console.log('$ ' + command)
  const proc = spawn(cmd, args, { stdio: 'overlapped' })
  proc.stdout.pipe(process.stdout)
  proc.stderr.pipe(process.stderr)
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

main()
