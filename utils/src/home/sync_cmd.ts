import { MassargCommand } from 'massarg/command'
import { DF_DIR, HomeOpts } from './common'
import { massarg } from 'massarg'
import { getCommandOutput, runCommand } from '../common'

type SyncOpts = HomeOpts & {
  message?: string
}

async function getSubmodules(opts: SyncOpts) {
  const { output } = await getCommandOutput(opts, [
    `git -C "${DF_DIR}" submodule | awk '{ print $2 }'`,
  ])
  const submodules = output
    .split('\n')
    .map((s) => s.trim())
    .filter(Boolean)
  return submodules
}

const push = async (opts: SyncOpts) => {
  const { message } = opts
  console.log('Pushing submodules to origin')
  const submodules = await getSubmodules(opts)

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
    .flat()

  const msg = `[sync] ${submodules.join(', ')} (${syncDate})`

  const pushRoot = [
    `echo "Pushing dotfiles\n"`,
    `pushd ${DF_DIR}`,
    `git add ${submodules.join(' ')}`,
    `git commit -m "chore(submodules): ${msg}"`,
    `git push origin master`,
    `popd`,
  ]

  await runCommand(opts, [...pushSubmodule, ...pushRoot])
}

const pushCommand = new MassargCommand<HomeOpts>({
  name: 'push',
  aliases: ['p'],
  description: 'Push submodules',
  run: push,
})
const pullCommand = new MassargCommand<HomeOpts>({
  name: 'pull',
  aliases: ['l'],
  description: 'Pull submodules',
  run: async (opts: HomeOpts) => {
    console.log('Pulling submodules from origin')
    await runCommand(opts, [`pushd ${DF_DIR}; git submodule update --remote; popd`])
  },
})

export const syncCommand = massarg<HomeOpts>({
  name: 'submodules',
  aliases: ['S'],
  description: 'Manage Submodules',
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
