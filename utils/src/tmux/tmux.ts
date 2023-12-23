import { Opts, getCommandOutput } from '../common'
import { TmuxLayout, fzf, getTmuxConfig, getTmuxConfigFileInfo, parseConfig } from './utils'
import { createFromConfig } from './command_builder'

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

  const tmuxConfig = parseConfig(item)
  createFromConfig(opts, tmuxConfig)
}
