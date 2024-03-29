import * as util from 'node:util'
import { Opts } from '../common'
import { MassargCommand } from 'massarg/command'
import { fzf, getTmuxConfig, parseConfig } from './utils'

export const showCmd = new MassargCommand<Opts>({
  name: 'show',
  aliases: ['s'],
  description: 'Show the tmux configuration file for a specific key',
  run: async (opts) => {
    const config = await getTmuxConfig()
    let { key } = opts
    if (!key) {
      key = await fzf(opts, Object.keys(config))
    }
    const item = parseConfig(key, config[key])
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
  })
  .help({ bindOption: true, bindCommand: true })
