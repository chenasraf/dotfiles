import { MassargCommand } from 'massarg/command'
import { DF_DIR, HomeOpts } from './common'
import { massarg } from 'massarg'
import { getCommandOutput, runCommand } from '../common'

// message: synced 2024-01-06T12:29:00.000Z
const DEFAULT_MSG = `sync ${new Date().toISOString()}`

type SyncOpts = HomeOpts & {
  message?: string
}

const push = async (opts: SyncOpts) => {
  const { message } = opts
  console.log('Pushing submodules to origin')
  const { output } = await getCommandOutput(opts, [
    `git -C "${DF_DIR}" submodule | awk '{ print $2 }'`,
  ])
  const submodules = output
    .split('\n')
    .map((s) => s.trim())
    .filter(Boolean)

  console.log('Submodules:', submodules, '\n')
  const syncDate = new Date().toISOString()

  const pushSubmodule = submodules
    .map((sub) => {
      const defaultMessage = `[sync] ${syncDate}`

      return [
        `echo "Pushing submodule: ${sub}\n"`,
        `pushd ${DF_DIR}/${sub}`,
        `git add .`,
        `git commit -m "chore: ${message || defaultMessage}"`,
        `git push origin master`,
        `[[ $? -ne 0 ]] && exit 1`,
        `popd`,
        `echo`,
      ]
    })
    .flat() as any[]

  const msg = `[sync] ${submodules.join(', ')} (${syncDate})`

  const pushRoot = [
    `echo "Pushing dotfiles\n"`,
    `pushd ${DF_DIR}`,
    `git add ${submodules.join(' ')}`,
    `git commit -m "chore(submodules): ${msg}"`,
    `git push origin master`,
    `popd`,
  ] as any[]

  await runCommand(opts, [...pushSubmodule, ...pushRoot])
}

const pushCommand = new MassargCommand<HomeOpts>({
  name: 'push',
  aliases: ['p'],
  description: 'Backup (push) synced files',
  run: push,
})
const pullCommand = new MassargCommand<HomeOpts>({
  name: 'pull',
  aliases: ['l'],
  description: 'Update (pull) synced files',
  run: async (opts: HomeOpts) => {
    console.log('Pulling submodules from origin')
    await runCommand(opts, [`pushd ${DF_DIR}; git submodule update --remote; popd`])
  },
})

export const syncCommand = massarg<HomeOpts>({
  name: 'synced',
  aliases: ['S'],
  description: 'Manage Synced Files',
})
  .main(push)
  .command(pushCommand)
  .command(pullCommand)
  .flag({
    name: 'dry',
    aliases: ['d'],
    description: 'Dry run',
  })
  .help({
    bindCommand: true,
    bindOption: true,
  })
