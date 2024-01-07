import { Opts, getCommandOutput } from '../common'
import { indent } from 'massarg/utils'
import { MassargCommand } from 'massarg/command'
import { getTmuxConfig, getTmuxConfigFileInfo, parseConfig } from './utils'

export const listCmd = new MassargCommand<Opts & { bare?: boolean; sessions?: boolean }>({
  name: 'list',
  aliases: ['ls'],
  description: 'List all tmux configurations and sessions',
  run: async (opts) => {
    const configs = await getTmuxConfigFileInfo()
    const rawConfig = await getTmuxConfig()
    const config = Object.fromEntries(
      Object.entries(rawConfig).map(([key, item]) => [key, parseConfig(key, item)]),
    )
    const keys = Object.keys(config).sort((a, b) => a.toLowerCase().localeCompare(b.toLowerCase()))
    if (opts.bare) {
      console.log(keys.join('\n'))
      return
    }
    const sessionsOutput = await getCommandOutput(opts, 'tmux ls')
    let sessions = sessionsOutput.output.replace(/\(created ([^)]+)\)/g, '$1')
    sessions = sessions
      .split('\n')
      .map((line) => line.replace(/^([^:]+):/, '$1').trim())
      .join('\n')
    const tbl = await getCommandOutput(
      opts,
      `echo ${JSON.stringify(
        sessions,
      )} | tblf -th "Name # Windows DDD MMM DD HH:MM:SS YYYY Status"`,
    )
    if (opts.sessions) {
      console.log(tbl.output)
      return
    }
    console.log('tmux sessions:\n')
    console.log(indent(tbl.output))
    console.log('tmux config files:\n')
    console.log(
      ' - ' +
      Object.entries(configs)
        .map(([key, config]) =>
          config && key !== 'merged' ? key + ': ' + config.filepath : undefined,
        )
        .filter(Boolean)
        .join('\n - ') +
      '\n',
    )
    console.log('tmux configurations:\n')
    console.log(' - ' + keys.join('\n - '))
  },
})
  .flag({
    name: 'verbose',
    aliases: ['v'],
    description: 'Verbose logs',
  })
  .flag({
    name: 'bare',
    aliases: ['b'],
    description:
      'Show only the tmux configuration names, without the sessions or formatting (useful for scripting)',
  })
  .flag({
    name: 'sessions',
    aliases: ['s'],
    description: 'Show only the tmux sessions',
  })
  .help({ bindOption: true, bindCommand: true })
