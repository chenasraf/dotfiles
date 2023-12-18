import { massarg } from 'massarg'
import { Opts, runCommand, withDefaultOpts } from '../common'
import { gitCommand, pullCommand, pushCommand, statusCommand } from './git_cmd'
import { DF_DIR, HomeOpts } from './common'
import { utilsCommand } from './utils_cmd'

async function sourceRun(opts: Opts, cmd: string | string[]) {
  return runCommand(opts, [`source "${DF_DIR}/.zshrc" -q`, ...(Array.isArray(cmd) ? cmd : [cmd])])
}

withDefaultOpts(
  massarg<HomeOpts>({
    name: 'home',
    description: 'Dotfiles management',
  }),
)
  .command(gitCommand)
  .command(statusCommand)
  .command(pushCommand)
  .command(pullCommand)
  .command(utilsCommand)
  .command({
    name: 'install',
    aliases: ['i'],
    description: 'Install dotfiles',
    run: async (opts) => {
      const vOpts = { ...opts, verbose: true }
      await sourceRun(vOpts, `source "${DF_DIR}/install.sh"`)
    },
  })
  .parse()
