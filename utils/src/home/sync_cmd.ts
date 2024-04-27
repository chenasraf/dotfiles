import { MassargCommand } from 'massarg/command'
import { DF_DIR, HomeOpts } from './common'
import { massarg } from 'massarg'
import { getCommandOutput, runCommand } from '../common'

type SyncOpts = HomeOpts & {
  message?: string
}

async function getSubmoduleNames(opts: SyncOpts) {
  const { output } = await getCommandOutput(opts, [
    `git -C "${DF_DIR}" submodule | awk '{ print $2 }'`,
  ])
  const submodules = output
    .split('\n')
    .map((s) => s.trim())
    .filter(Boolean)
  return submodules
}

async function withSubmodule(fn: (sub: string) => Promise<void>, opts: SyncOpts) {
  const submodules = await getSubmoduleNames(opts)
  for (const sub of submodules) {
    await fn(sub)
  }
}

const yellow = (s: string) => `\x1b[33m${s}\x1b[0m`

const push = async (opts: SyncOpts) => {
  const { message } = opts
  console.log('Pushing submodules to origin')
  const submodules = await getSubmoduleNames(opts)

  console.log('Submodules:', submodules, '\n')
  const syncDate = new Date().toISOString()

  const pushSubmodule = submodules
    .map((sub) => {
      const defaultMessage = `[sync] ${syncDate}`

      return [
        `echo "${yellow('Pushing submodule: ${sub}\n')}"`,
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

  const msg = `Update submodules: ${submodules.join(', ')} (${syncDate})`

  const pushRoot = [
    `echo "${yellow('Pushing dotfiles\n')}"`,
    `pushd ${DF_DIR}`,
    `git add ${submodules.join(' ')}`,
    `git commit -m "backup(submodules): ${msg}"`,
    `git push origin master`,
    `popd`,
  ]

  await runCommand(opts, [...pushSubmodule, ...pushRoot])
}

const statusCommand = new MassargCommand<HomeOpts>({
  name: 'status',
  aliases: ['s'],
  description: 'Show submodule status',
  run: async (opts: HomeOpts) => {
    const { output } = await getCommandOutput(opts, [`git -C "${DF_DIR}" submodule status`])
    console.log(output)
  },
})

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
    console.log(yellow('Pulling submodules from origin'))
    for (const sub of await getSubmoduleNames(opts)) {
      await runCommand(opts, [`pushd ${DF_DIR}/${sub}; git pull; popd`])
    }
  },
})

export const syncCommand = massarg<HomeOpts>({
  name: 'submodules',
  aliases: ['S'],
  description: 'Manage Submodules',
})
  .main(push)
  .command(statusCommand)
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
