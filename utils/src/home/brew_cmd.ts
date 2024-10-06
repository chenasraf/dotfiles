import * as os from 'node:os'
import { MassargCommand } from 'massarg/command'
import { DF_DIR, HomeOpts, checkGitChanges, getDeviceUID } from './common'
import { massarg } from 'massarg'
import { runCommand } from '../common'

export type BrewOpts = HomeOpts & { push: boolean; arch?: string }

async function backup(opts: BrewOpts) {
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
    ...(opts.push
      ? [
        `git add Brewfile`,
        `git commit -m "backup(brew): Update Brewfile for ${DEVICE_UID} (${syncDate})"`,
        `git push`,
      ]
      : []),
    `popd`,
  ])
}

async function restore(opts: BrewOpts) {
  const DEVICE_UID = await getDeviceUID()
  console.log(`Restoring Brewfile for ${DEVICE_UID} (${opts.arch})`)
  await runCommand(opts, [
    `pushd "${DF_DIR}/brew/${DEVICE_UID}"`,
    `${opts.arch === 'arm64' ? 'arch -arm64' : ''} brew bundle`,
    `popd`,
  ])
}

const backupCommand = new MassargCommand<BrewOpts>({
  name: 'backup',
  aliases: ['b', 'p'],
  description: 'Backup brew state to Brewfile',
  run: backup,
}).flag({
  name: 'push',
  aliases: ['p'],
  description: 'Push changes to git',
  defaultValue: true,
})
const restoreCommand = new MassargCommand<BrewOpts>({
  name: 'restore',
  aliases: ['r', 'l'],
  description: 'Restore brew state from Brewfile',
  run: restore,
}).option({
  name: 'arch',
  aliases: ['a'],
  defaultValue: 'arm64',
  description: 'Architecture to use',
})

export const brewCommand = massarg<BrewOpts>({
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
