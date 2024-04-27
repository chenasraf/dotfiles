import * as os from 'node:os'
import { MassargCommand } from 'massarg/command'
import { DF_DIR, HomeOpts } from './common'
import { massarg } from 'massarg'
import { runCommand } from '../common'

async function backup(opts: HomeOpts) {
  const isMacOS = os.platform() === 'darwin'
  if (!isMacOS) {
    console.log('Not on MacOS, skipping backup.')
    return
  }
  const syncDate = new Date().toISOString()
  await runCommand(opts, [
    `pushd "${DF_DIR}"`,
    `git diff --quiet`,
    `[[ $? -ne 0 ]] && echo "There are other changes waiting to be pushed" && exit 1`,
    `brew bundle dump -f --describe`,
    `git add Brewfile`,
    `git commit -m "backup(brew): Update Brewfile (${syncDate})"`,
    `git push`,
    `popd`,
  ])
}

async function restore(opts: HomeOpts) {
  await runCommand(opts, [`pushd "${DF_DIR}"`, `brew bundle`, `popd`])
}

const backupCommand = new MassargCommand<HomeOpts>({
  name: 'backup',
  aliases: ['b', 'p'],
  description: 'Backup brew state to Brewfile',
  run: backup,
})
const restoreCommand = new MassargCommand<HomeOpts>({
  name: 'restore',
  aliases: ['r', 'l'],
  description: 'Restore brew state from Brewfile',
  run: restore,
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
