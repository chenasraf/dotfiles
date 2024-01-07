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

  const commands: string[] = []

  let sessionName = nameFix(tmuxConfig.name)

  log(opts, 'Session name:', sessionName)

  if (await sessionExists(opts, sessionName)) {
    log(opts, `tmux session ${sessionName} already exists, attaching...`)
    await runCommand(opts, `tmux attach -t ${sessionName}`)
    return
  }

  log(opts, `tmux session ${sessionName} does not exist, creating...`)

  // Main window split
  commands.push(
    `tmux -f ~/.config/.tmux.conf new-session -d -s ${sessionName} -n general -c ${root}; sleep 1`,
  )
  commands.push(`tmux split-window -h -t ${sessionName} -c ${root}`)
  commands.push(`tmux select-pane -t 0`)

  // Create all other windows
  for (const window of windows) {
    const dir = window.cwd
    const windowName = window.name || nameFix(path.basename(dir))

    const paneCommands: string[] = getPaneCommands(window.layout, { windowName, sessionName })
    commands.push(...paneCommands)
    commands.push(`tmux select-pane -t 0`)
    commands.push(`tmux resize-pane -Z`)
  }

  commands.push(`tmux select-window -t ${sessionName}:1`)

  for (const command of commands) {
    await runCommand(opts, command)
  }

  await attachToSession(opts, sessionName)
}

function getPaneCommands(
  pane: TmuxPaneLayout,
  { windowName, sessionName }: { windowName: string; sessionName: string },
): string[] {
  const commands: string[] = []
  const cmd = pane.cmd ? transformCmdToTmuxKeys(pane.cmd) : ''
  if (cmd) {
    commands.push(`tmux send-keys -t ${sessionName}:${windowName} ${cmd} Enter`)
  }
  if (pane.split) {
    commands.push(
      `tmux split-window ${pane.split.direction || 'h'}` +
      ` -t ${sessionName}:${windowName} -c ${pane.cwd} ${cmd}`.trim(),
    )
    if (pane.split.child) {
      commands.push(
        ...getPaneCommands(pane.split.child, {
          windowName,
          sessionName,
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
