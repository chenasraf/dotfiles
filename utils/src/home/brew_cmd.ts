import * as os from 'node:os'
import { MassargCommand } from 'massarg/command'
import { DF_DIR, HomeOpts, checkGitChanges, getDeviceUID } from './common'
import { massarg } from 'massarg'
import { runCommand } from '../common'

async function backup(opts: HomeOpts) {
  const isMacOS = os.platform() === 'darwin'
  if (!isMacOS) {
    console.log('Not on MacOS, skipping backup.')
    return
  }
  const syncDate = new Date().toISOString()
  const DEVICE_UID = await getDeviceUID()
  const gitChanges = await checkGitChanges(opts)
  if (gitChanges) {
    console.error('There are other changes waiting to be pushed')
    process.exit(1)
  }
  await runCommand(opts, [
    `mkdir -p "${DF_DIR}/brew/${DEVICE_UID}"`,
    `pushd "${DF_DIR}/brew/${DEVICE_UID}"`,
    `brew bundle dump --formula --cask --tap --describe --force`,
    `git add Brewfile`,
    `git commit -m "backup(brew): Update Brewfile (${syncDate})"`,
    `git push`,
    `popd`,
  ])
}

async function restore(opts: HomeOpts) {
  const DEVICE_UID = await getDeviceUID()
  await runCommand(opts, [`pushd "${DF_DIR}/brew/${DEVICE_UID}"`, `brew bundle`, `popd`])
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
