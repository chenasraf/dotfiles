import { Opts, UserError, log, runCommand } from '../common'
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
      if (!allConfigs[key]) {
        throw new UserError(`tmux config item '${key}' not found`)
      }
      const config = parseConfig(key, allConfigs[key])
      if (!(await sessionExists(opts, config.name))) {
        throw new UserError(`tmux session '${config.name}' does not exist`)
      }
      return attachToSession(opts, config.name)
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
