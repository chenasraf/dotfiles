import { Opts, log, runCommand } from '../common'
import { MassargCommand } from 'massarg/command'
import { attachToSession, getTmuxConfig, parseConfig, sessionExists } from './utils'

export const attachCmd = new MassargCommand<Opts>({
  name: 'attach',
  aliases: ['a'],
  description: 'Attach to a tmux session',
  run: async (opts) => {
    const { key } = opts

    if (key) {
      const allConfigs = await getTmuxConfig()
      const config = parseConfig(allConfigs[key])
      const sessionName = parseConfig(config).name
      if (!(await sessionExists(opts, sessionName))) {
        throw new Error(`tmux session ${sessionName} does not exist`)
      }
      return attachToSession(opts, sessionName)
    }

    if (process.env.TMUX) {
      log(opts, 'Already in tmux and no key specified, not attaching')
      return
    }

    await runCommand(opts, `tmux attach`)
  },
})
  .option({
    name: 'key',
    aliases: ['k'],
    description: 'The tmux session to attach to',
    isDefault: true,
  })
  .help({ bindOption: true, bindCommand: true })
