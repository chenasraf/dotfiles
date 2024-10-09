import * as os from 'node:os'
import { MassargCommand } from 'massarg/command'
import { HomeOpts } from './common'
import { massarg } from 'massarg'
import { runCommand, yellow } from '../common'

const home = os.homedir()
const mushBaseDir = `${home}/Library/Application Support/CrossOver/Bottles/MushClient/drive_c/users/crossover`
const mushDir = `${mushBaseDir}/MUSHclient`
const syncedDir = `${home}/Nextcloud/synced`
const backupDir = `${syncedDir}/MUSHclient`

const backup = async (opts: HomeOpts) => {
  await runCommand(opts, [
    `echo "${yellow(`Copying "${mushDir}" to "${syncedDir}"`)}"`,
    `rsync -vtr "${mushDir}" "${syncedDir}"`,
    `echo "${yellow(`Backed up "${mushDir}" to "${syncedDir}"`)}"`,
  ])
}
const backupCommand = new MassargCommand<HomeOpts>({
  name: 'backup',
  aliases: ['b', 'p'],
  description: 'Backup Mushclient profile',
  run: backup,
})
const restoreCommand = new MassargCommand<HomeOpts>({
  name: 'restore',
  aliases: ['r', 'l'],
  description: 'Restore Mushclient profile',
  run: async (opts: HomeOpts) => {
    await runCommand(opts, [
      `echo "${yellow(`Copying "${backupDir}" to "${mushBaseDir}"`)}"`,
      `rsync -vtr --exclude .git "${backupDir}" "${mushBaseDir}/"`,
      `echo "${yellow(`Restored "${backupDir}" to "${mushBaseDir}"`)}"`,
    ])
  },
})
const mapRestoreCommand = new MassargCommand<HomeOpts>({
  name: 'map-restore',
  aliases: ['mr', 'm'],
  description: 'Restore Mushclient map database',
  run: async (opts: HomeOpts) => {
    const src = 'Aardwolf.db.Backup_Manual'
    const bk = 'Aardwolf.db.bk'
    const dest = 'Aardwolf.db'

    await runCommand(opts, [
      `pushd "${mushBaseDir}"`,
      `echo "${yellow(`Renaming ${dest} to ${bk}`)}"`,
      `mv "${dest}" "${bk}"`,
      `echo "${yellow(`Copying ${mushBaseDir}/db_backups/${src} to ${mushBaseDir}/${dest}`)}"`,
      `cp "db_backups/${src}" "${mushBaseDir}/${dest}"`,
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
