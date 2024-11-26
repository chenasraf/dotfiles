import * as os from 'node:os'
import { MassargCommand } from 'massarg/command'
import { HomeOpts } from './common'
import { massarg } from 'massarg'
import { runCommand, yellow } from '../common'

const home = os.homedir()
const localBaseDir = `${home}/Library/Application Support/CrossOver/Bottles/MushClient/drive_c/users/crossover`
const localDir = `${localBaseDir}/MUSHclient`
const syncedDir = `${home}/Nextcloud/synced`
const syncedBackupDir = `${syncedDir}/MUSHclient`

const backup = async (opts: HomeOpts) => {
  await runCommand(opts, [
    `echo "${yellow(`Dumping "Aardwolf.db" to "Aardwolf.dump.sql"`)}"`,
    `sqlite3 "${syncedBackupDir}/Aardwolf.db" .dump > "${localDir}/Aardwolf.dump.sql"`,
    `echo "${yellow(`Copying to sync dir...`)}"`,
    `rsync -vtr "${localDir}" "${syncedDir}"`,
    `echo "${yellow(`Backed up "${localDir}" to "${syncedDir}"`)}"`,
  ])
}

// NOTE backup
const backupCommand = new MassargCommand<HomeOpts>({
  name: 'backup',
  aliases: ['b', 'p'],
  description: 'Backup Mushclient profile',
  run: backup,
})

// NOTE restore
const restoreCommand = new MassargCommand<HomeOpts>({
  name: 'restore',
  aliases: ['r', 'l'],
  description: 'Restore Mushclient profile',
  run: async (opts: HomeOpts) => {
    await runCommand(opts, [
      `echo "${yellow(`Copying "${syncedBackupDir}" to "${localBaseDir}"`)}"`,
      `rsync -vtr --exclude .git "${syncedBackupDir}" "${localBaseDir}/"`,
      `echo "${yellow(`Restored "${syncedBackupDir}" to "${localBaseDir}"`)}"`,
    ])
  },
})

// NOTE map-restore
const mapRestoreCommand = new MassargCommand<HomeOpts>({
  name: 'map-restore',
  aliases: ['mr', 'm'],
  description: 'Restore Mushclient map database',
  run: async (opts: HomeOpts) => {
    const src = 'Aardwolf.db.Backup_Manual'
    const bk = `Aardwolf.db.${new Date().toISOString().replace(/:/g, '-')}.bk`
    const dest = 'Aardwolf.db'

    await runCommand(opts, [
      `pushd "${localBaseDir}"`,
      `echo "${yellow(`Renaming ${dest} to ${bk}`)}"`,
      `mv "${dest}" "${bk}"`,
      `echo "${yellow(`Copying ${localBaseDir}/db_backups/${src} to ${localBaseDir}/${dest}`)}"`,
      `cp "db_backups/${src}" "${localBaseDir}/${dest}"`,
      `echo "${yellow('Done.')}"`,
      'popd',
    ])
  },
})

// NOTE main
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
