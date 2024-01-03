import * as os from 'node:os'
import { MassargCommand } from 'massarg/command'
import { DF_DIR, HomeOpts } from './common'
import { massarg } from 'massarg'
import { runCommand } from '../common'

const backup = async (opts: HomeOpts) => {
  const isMacOS = os.platform() === 'darwin'
  if (!isMacOS) {
    console.log('Not on MacOS, skipping backup.')
    return
  }
  await runCommand(opts, [`pushd "${DF_DIR}"`, `brew bundle dump -f --describe`, `popd`])
}
const backupCommand = new MassargCommand<HomeOpts>({
  name: 'backup',
  aliases: ['b'],
  description: 'Backup brew state to Brewfile',
  run: backup,
})
const restoreCommand = new MassargCommand<HomeOpts>({
  name: 'restore',
  aliases: ['r'],
  description: 'Restore brew state from Brewfile',
  run: async (opts: HomeOpts) => {
    await runCommand(opts, [`pushd "${DF_DIR}"`, `brew bundle`])
  },
})

export const brewCommand = massarg<HomeOpts>({
  name: 'brew',
  aliases: ['b'],
  description: 'Manage Brewfile',
})
  .main(backup)
  .command(backupCommand)
  .command(restoreCommand)
  .help({
    bindCommand: true,
    bindOption: true,
  })
