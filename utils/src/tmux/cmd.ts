import * as path from 'node:path'
import * as util from 'node:util'
import * as fs from 'node:fs/promises'
// ================================================================================
// Commands

import { massarg } from 'massarg'
import { Opts, getCommandOutput, log, runCommand } from '../common'
import { indent, strConcat } from 'massarg/utils'
import { format } from 'massarg/style'
import { MassargCommand } from 'massarg/command'
import {
  getTmuxConfig,
  getTmuxConfigFileInfo,
  nameFix,
  parseConfig,
  sessionExists,
  throwNoConfigFound,
} from './utils'
import { addSimpleConfigToFile, createFromConfig } from './command_builder'
import { main } from './tmux'

// ================================================================================
const mainCmd = massarg<Opts>({
  name: 'tmux',
  description: 'Generate layouts for tmux using presets or on-the-fly args.',
})
  .main(main)
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
  .option({
    name: 'key',
    aliases: ['k'],
    description: 'The tmux session to open',
    isDefault: true,
    required: true,
  })
  .help({
    bindOption: true,
    bindCommand: true,
    usageText: strConcat(
      [
        format('tmux', { color: 'yellow' }),
        format('[options]', { color: 'gray' }),
        format('[-k] <tmux session name>', { color: 'green' }),
      ].join(' '),
      [format('tmux', { color: 'yellow' }), format('<command> [options]', { color: 'gray' })].join(
        ' ',
      ),
    ),
  })

const showCmd = new MassargCommand<Opts>({
  name: 'show',
  aliases: ['s'],
  description: 'Show the tmux configuration file for a specific key',
  run: async (opts) => {
    const config = await getTmuxConfig()
    const { key } = opts
    const item = parseConfig(config[key])
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
    required: true,
  })
  .help({ bindOption: true, bindCommand: true })

const listCmd = {
  name: 'list',
  aliases: ['ls'],
  description: 'List all tmux configurations and sessions',
  run: async (opts: Opts) => {
    const rawConfig = await getTmuxConfig()
    const config = Object.fromEntries(
      Object.entries(rawConfig).map(([key, item]) => [key, parseConfig(item)]),
    )
    const sessions = await getCommandOutput(opts, 'tmux ls')
    const keys = Object.keys(config).sort((a, b) => a.toLowerCase().localeCompare(b.toLowerCase()))
    console.log('tmux sessions:\n')
    console.log(indent(sessions.output))
    console.log('tmux configurations:\n')
    console.log(' - ' + keys.join('\n - '))
  },
}

export type ConfigFileOpts = Opts & {
  local?: boolean
}

const editCmd = new MassargCommand<Opts & { local?: boolean }>({
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

const rmCmd = new MassargCommand<ConfigFileOpts>({
  name: 'remove',
  aliases: ['rm'],
  description: 'Remove a tmux workspace from the config file',
  run: async (opts) => {
    const { key } = opts
    const configFiles = await getTmuxConfigFileInfo()
    const allConfigs = await getTmuxConfig()
    const configFile = opts.local ? configFiles.local : configFiles.global
    if (!configFile) {
      throw new Error('tmux config file not found')
    }
    if (!allConfigs[key]) {
      throw new Error(`tmux config item ${key} not found`)
    }
    const strContents = await fs.readFile(configFile.filepath, 'utf-8')
    const contents = strContents.split('\n')
    const index = contents.findIndex((line) => line.startsWith(key + ':'))
    log(opts, 'Index:', index)
    if (index === -1) {
      throw new Error(`tmux config item ${key} not found`)
    }
    let endIndex = contents.slice(index + 1).findIndex((line) => line.match(/^\S/))
    log(opts, 'End index:', endIndex)
    if (endIndex === -1) {
      endIndex = contents.length - index
      log(opts, 'End index set to end:', endIndex)
    }

    const newContents = contents
      .slice(0, index)
      .concat(contents.slice(index + endIndex))
      .join('\n')
      .trimEnd()

    log(opts, 'New contents:', newContents)
    log(opts, 'Filepath:', configFile.filepath)

    await fs.writeFile(configFile.filepath, newContents)
    console.log(`Removed tmux config item ${key}`)
  },
})
  .option({
    name: 'key',
    aliases: ['k'],
    description: 'The tmux session to remove',
    isDefault: true,
    required: true,
  })
  .option({
    name: 'verbose',
    aliases: ['v'],
    description: 'Verbose logs',
  })
  .flag({
    name: 'local',
    aliases: ['l'],
    description: 'Remove from the local tmux config file',
  })
  .help({
    bindOption: true,
    bindCommand: true,
  })

const attachCmd = new MassargCommand<Opts>({
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
      await runCommand(opts, `tmux attach -t ${sessionName}`)
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

export type CreateOpts = Opts & {
  rootDir?: string
  window?: string[]
  save?: boolean
  saveOnly?: boolean
  local?: boolean
}

const createCmd = new MassargCommand<CreateOpts>({
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

mainCmd
  .command(listCmd)
  .command(showCmd)
  .command(editCmd)
  .command(rmCmd)
  .command(createCmd)
  .command(attachCmd)
  .parse()
