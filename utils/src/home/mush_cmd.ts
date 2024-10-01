import * as os from 'node:os'
import { MassargCommand } from 'massarg/command'
import { DF_DIR, HomeOpts } from './common'
import { massarg } from 'massarg'
import { runCommand, yellow } from '../common'

const mushdir = `${os.homedir()}/Library/Application Support/CrossOver/Bottles/MushClient/drive_c/users/crossover/MUSHclient`

const backup = async (opts: HomeOpts) => {
  const sub = 'synced'
  await runCommand(opts, [
    `rsync -vtr "${mushdir}" "${DF_DIR}/synced/"`,
    `echo "${yellow('Copied Mushclient profile to synced folder.')}"`,
    `pushd "${DF_DIR}/${sub}"`,
    `git add MUSHclient`,
    `git commit -m "backup: mushclient"`,
    `git push`,
    `echo "${yellow('Backup complete.')}"`,
    `echo "${yellow('Syncing repository with submodule changes\n')}"`,
    `popd`,
    `pushd ${DF_DIR}`,
    `git add ${sub}`,
    `git status`,
    `git commit -m "backup: mushclient"`,
    `git push origin master`,
    `popd`,
  ])
}
const backupCommand = new MassargCommand<HomeOpts>({
  name: 'backup',
  aliases: ['b'],
  description: 'Backup Mushclient profile',
  run: backup,
})
const restoreCommand = new MassargCommand<HomeOpts>({
  name: 'restore',
  aliases: ['r'],
  description: 'Restore Mushclient profile',
  run: async (opts: HomeOpts) => {
    await runCommand(opts, [
      `rsync -vtr "${DF_DIR}/synced/MUSHclient/" "${mushdir}/"`,
      `echo "${yellow('Restored Mushclient profile from synced folder.')}"`,
    ])
  },
})
const mapRestoreCommand = new MassargCommand<HomeOpts>({
  name: 'map-restore',
  aliases: ['mr'],
  description: 'Restore Mushclient map database',
  run: async (opts: HomeOpts) => {
    const src = 'Aardwolf.db.Backup_Manual'
    const bk = 'Aardwolf.db.bk'
    const dest = 'Aardwolf.db'

    await runCommand(opts, [
      `echo "${yellow(`Renaming ${dest} to ${bk}`)}"`,
      `pushd "${mushdir}"`,
      `mv "${dest}" "${bk}"`,
      `echo "${yellow(`Copying ${mushdir}/db_backups/${src} to ${mushdir}/${dest}`)}"`,
      `cp "db_backups/${src}" "${DF_DIR}/synced/MUSHclient/${dest}"`,
      `echo "${yellow('Done.')}"`,
      'popd',
    ])
  },
})

export const mushCommand = massarg<HomeOpts>({
  name: 'mush',
  aliases: ['m'],
  description: 'Backup/restore Mushclient profile',
})
  .main(backup)
  .command(backupCommand)
  .command(restoreCommand)
  .command(mapRestoreCommand)
  .help({
    bindCommand: true,
    bindOption: true,
  })
