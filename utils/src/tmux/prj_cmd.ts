import * as path from 'node:path'
import * as os from 'node:os'
import * as fs from 'node:fs/promises'
import { Opts, log } from '../common'
import { MassargCommand } from 'massarg/command'
import { fzf, isDirectory, nameFix, parseConfig, pathExists } from './utils'
import { createFromConfig } from './command_builder'
import { format } from 'massarg/style'

export type CreateOpts = Opts & {
  name?: string
}

export const prjCmd = new MassargCommand<CreateOpts>({
  name: 'prj',
  aliases: ['p'],
  description: 'Create a new tmux session (temporary) from project folder',
  run: async (opts) => {
    try {
      const devProjects = await getProjects(opts)
      const output = opts.name || (await fzf(opts, devProjects, { allowCustom: true }))
      if (!output) {
        throw new Error('No selection')
      }
      const projectDir = path.join(os.homedir(), 'Dev', output)
      const exists = await pathExists(projectDir)
      if (!exists) {
        log(opts, `Creating dir: ${projectDir}`)
        await fs.mkdir(projectDir, { recursive: true })
      }
      const config = parseConfig(output, {
        name: nameFix(output),
        root: projectDir,
        windows: ['.'],
      })
      return createFromConfig(opts, config)
    } catch (error) {
      console.log(format(error?.toString() ?? 'Unknown error', { color: 'red' }))
    }
  },
})
  .option({
    name: 'name',
    aliases: ['n'],
    description: 'Name of the directory to open as session',
    isDefault: true,
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
  .help({ bindOption: true, bindCommand: true })

async function getProjects(_opts: Opts) {
  const devDir = path.join(os.homedir(), 'Dev')

  const devFiles = await fs.readdir(devDir)
  let devProjects = [] as string[]

  for (const file of devFiles) {
    if (await isDirectory(path.join(devDir, file))) {
      devProjects.push(file)
    }
  }
  return devProjects
}
