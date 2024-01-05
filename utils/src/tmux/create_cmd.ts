import * as path from 'node:path'
import { Opts, log } from '../common'
import { MassargCommand } from 'massarg/command'
import { attachToSession, nameFix, parseConfig, sessionExists } from './utils'
import { addSimpleConfigToFile, createFromConfig } from './command_builder'

export type CreateOpts = Opts & {
  rootDir?: string
  window?: string[]
  save?: boolean
  saveOnly?: boolean
  local?: boolean
}

export const createCmd = new MassargCommand<CreateOpts>({
  name: 'create',
  aliases: ['c'],
  description: 'Create a new tmux session (temporary)',
  run: async (opts) => {
    log(opts, 'Options:', opts)
    const config = parseConfig({
      name: nameFix(path.basename(opts.rootDir ?? process.cwd())),
      root: opts.rootDir ?? process.cwd(),
      windows: opts.window ?? ['.'],
    })

    if (await sessionExists(opts, config.name)) {
      log(opts, 'Session already exists, attaching')
      return attachToSession(opts, config.name)
    }

    if (opts.save || opts.saveOnly) {
      addSimpleConfigToFile(opts, config)
    }
    if (opts.saveOnly) {
      return
    }
    createFromConfig(opts, config)
  },
})
  .option({
    name: 'root-dir',
    aliases: ['r'],
    description: 'The root directory to create the tmux session in',
  })
  .option({
    name: 'window',
    aliases: ['w'],
    description: 'Add a window with the given directory, relative to root',
    array: true,
  })
  .flag({
    name: 'save',
    aliases: ['s'],
    description: 'Save the tmux session to the config file',
  })
  .flag({
    name: 'save-only',
    aliases: ['S'],
    description: 'Save the tmux session to the config file without creating it',
  })
  .flag({
    name: 'verbose',
    aliases: ['v'],
    description: 'Verbose logs',
  })
  .flag({
    name: 'dry',
    aliases: ['d'],
    description: 'Dry run',
  })
  .flag({
    name: 'local',
    aliases: ['l'],
    description: 'Save the tmux session to the local config file',
  })
  .help({ bindOption: true, bindCommand: true })
