import * as os from 'node:os'
import { MassargCommand } from 'massarg/command'
import { HomeOpts } from './common'
import { massarg } from 'massarg'
import { runCommand, yellow } from '../common'

const home = os.homedir()
const mushdir = `${home}/Library/Application Support/CrossOver/Bottles/MushClient/drive_c/users/crossover/MUSHclient`
const syncedDir = `${home}/Nextcloud/synced`
const backupDir = `${syncedDir}/MUSHclient`

const backup = async (opts: HomeOpts) => {
  await runCommand(opts, [
    `rsync -vtr "${mushdir}" "${syncedDir}"`,
    `echo "${yellow('Copied Mushclient profile to synced folder.')}"`,
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
      `rsync -vtr --exclude .git "${backupDir}" "${mushdir}/"`,
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
      `pushd "${mushdir}"`,
      `echo "${yellow(`Renaming ${dest} to ${bk}`)}"`,
      `mv "${dest}" "${bk}"`,
      `echo "${yellow(`Copying ${mushdir}/db_backups/${src} to ${mushdir}/${dest}`)}"`,
      `cp "db_backups/${src}" "${mushdir}/${dest}"`,
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
