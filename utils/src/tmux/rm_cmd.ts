import * as fs from 'node:fs/promises'
import { Opts, log } from '../common'
import { MassargCommand } from 'massarg/command'
import { getTmuxConfig, getTmuxConfigFileInfo } from './utils'

export type ConfigFileOpts = Opts & {
  local?: boolean
}
export const rmCmd = new MassargCommand<ConfigFileOpts>({
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
