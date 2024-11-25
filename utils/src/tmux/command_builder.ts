import * as path from 'node:path'
import * as fs from 'node:fs/promises'
import * as os from 'node:os'
import { Opts, log, runCommand } from '../common'
import {
  ParsedTmuxConfigItem,
  TmuxPaneLayout,
  attachToSession,
  getTmuxConfig,
  getTmuxConfigFileInfo,
  nameFix,
  sessionExists,
  transformCmdToTmuxKeys,
} from './utils'
import { CreateOpts } from './create_cmd'

export async function createFromConfig(opts: Opts, tmuxConfig: ParsedTmuxConfigItem) {
  const { root, windows: windows } = tmuxConfig
  log(opts, 'Config:', tmuxConfig)

  const sessionName = nameFix(tmuxConfig.name)

  log(opts, 'Session name:', sessionName)

  if (await sessionExists(opts, sessionName)) {
    log(opts, `tmux session ${sessionName} already exists, attaching...`)
    await attachToSession(opts, sessionName)
    return
  }

  log(opts, `tmux session ${sessionName} does not exist, creating...`)

  const commands: string[] = []
  commands.push(
    `tmux -f ~/.config/tmux/conf.tmux new-session -d -s ${sessionName} -n general -c ${root}; sleep 1`,
  )

  // Create all windows
  for (let i = 0; i < windows.length; i++) {
    const window = windows[i]
    const dir = window.cwd
    const windowName = window.name || nameFix(path.basename(dir))
    log(opts, 'Creating window:', windowName)
    commands.push(`tmux new-window -a -t ${sessionName} -n ${windowName} -c ${dir}`)
    const paneCommands: string[] = getPaneCommands(opts, window.layout, {
      rootDir: root,
      windowName,
      sessionName,
    })
    commands.push(...paneCommands)
    commands.push(`tmux select-pane -t ${sessionName}.0`)
    commands.push(`tmux resize-pane -t ${sessionName} -Z`)
  }

  commands.push(`tmux select-window -t ${sessionName}:1`)

  for (const command of commands) {
    await runCommand(opts, command)
  }

  await attachToSession(opts, sessionName)
}

function getPaneCommands(
  opts: Opts,
  pane: TmuxPaneLayout,
  {
    windowName,
    sessionName,
    rootDir,
  }: { windowName: string; sessionName: string; rootDir: string },
): string[] {
  const commands: string[] = []
  const cmd = pane.cmd ? transformCmdToTmuxKeys(pane.cmd) : ''
  if (cmd) {
    log(opts, 'Sending keys:', JSON.stringify(cmd))
    commands.push(`tmux send-keys -t ${sessionName}:${windowName} ${cmd} Enter`)
  }
  if (pane.split) {
    log(
      opts,
      'Splitting pane:',
      pane.split,
      'with cmd:',
      cmd,
      'in session:window:',
      `${sessionName}:${windowName}`,
      'direction:',
      pane.split.direction || 'h',
    )
    commands.push(
      `tmux split-window -${pane.split.direction || 'h'} ` +
      ` -t ${sessionName}:${windowName} -c ${pane.cwd || rootDir}`.trim(),
    )

    if (pane.split.child) {
      log(opts, 'Handling child pane:', pane.split.child)
      // commands.push(`tmux select-pane -t ${sessionName}:${windowName}.0`)
      commands.push(
        ...getPaneCommands(opts, pane.split.child, {
          windowName,
          sessionName,
          rootDir,
        }),
      )
    }
  }
  return commands
}

export async function addSimpleConfigToFile(opts: CreateOpts, config: ParsedTmuxConfigItem) {
  const files = await getTmuxConfigFileInfo()
  const file = opts.local ? files.local : files.global
  if (!file) {
    throw new Error('tmux config file not found')
  }
  const { filepath } = file
  const existingConfig = await getTmuxConfig()
  if (existingConfig[config.name] && !opts.dry) {
    throw new Error(`tmux config item ${config.name} already exists`)
  }

  const dirFix = (dir: string) => dir.replace(config.root, './').replace(os.homedir(), '~')

  // dump config as yaml
  const contents = `
${config.name}:
  root: ${config.root}
  windows:
${config.windows.map((w) => `    - ${dirFix(w.cwd)}`).join('\n')}
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
