import { Opts } from '../common'
import { TmuxLayout, getTmuxConfig, parseConfig } from './utils'
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
  const { key } = opts
  const config = await getTmuxConfig()
  const item = config[key]
  if (!item) {
    throw new Error(`tmux config item ${key} not found`)
  }

  const tmuxConfig = parseConfig(item)
  createFromConfig(opts, tmuxConfig)
}
