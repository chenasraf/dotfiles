import { MassargCommand } from 'massarg/command'
import { Opts, runCommand } from '../common'
import { getTmuxConfigFileInfo, throwNoConfigFound } from './utils'

export const editCmd = new MassargCommand<Opts & { local?: boolean }>({
  name: 'edit',
  aliases: ['e'],
  description: 'Edit the tmux configuration file',
  run: async (opts) => {
    const configs = await getTmuxConfigFileInfo()
    const config = opts.local ? configs.local : configs.global
    if (!config) {
      throwNoConfigFound()
      return
    }
    const { filepath } = config
    const editor = process.env.EDITOR || 'vim'
    await runCommand(opts, `${editor} ${filepath}`)
  },
}).flag({
  name: 'local',
  aliases: ['l'],
  description: 'Edit the local tmux config file',
})
