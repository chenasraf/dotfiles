import { Opts } from '../common'
import {
  TmuxLayout,
  TmuxPaneLayout,
  attachToSession,
  fzf,
  getTmuxConfig,
  getTmuxConfigFileInfo,
  parseConfig,
  sessionExists,
} from './utils'
import { createFromConfig } from './command_builder'

export async function main(opts: Opts) {
  let { key } = opts
  if (!key) {
    const {
      merged: { config },
    } = await getTmuxConfigFileInfo()
    const output = await fzf(opts, Object.keys(config))
    if (!output || !(output in config)) {
      throw new Error('tmux config item not found')
    }
    key = output
  }
  const config = await getTmuxConfig()
  const item = config[key]
  if (!item) {
    throw new Error(`tmux config item ${key} not found`)
  }

  const parsed = parseConfig(key, item)
  if (await sessionExists(opts, parsed.name)) {
    return attachToSession(opts, parsed.name)
  }
  return createFromConfig(opts, parsed)
}
