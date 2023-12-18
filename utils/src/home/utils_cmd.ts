import { MassargCommand } from 'massarg/command'
import { DF_DIR, HomeOpts } from './common'
import { massarg } from 'massarg'
import { runCommand } from '../common'

const install = async (opts: HomeOpts) => {
  await runCommand(opts, [
    `pushd ${DF_DIR}/utils`,
    'pnpm install && pnpm build && pnpm ginst',
    'popd',
  ])
}
const installCommand = new MassargCommand<HomeOpts>({
  name: 'install',
  aliases: ['i'],
  description: 'Install utilities',
  run: install,
})

const editCommand = new MassargCommand<HomeOpts>({
  name: 'edit',
  aliases: ['e'],
  description: 'Edit utilities',
  run: async (opts: HomeOpts) => {
    await runCommand(opts, [`pushd ${DF_DIR}/utils`, 'nvim .', 'popd'])
  },
})

export const utilsCommand = massarg<HomeOpts>({
  name: 'utils',
  aliases: ['u'],
  description: 'Manage utilities',
})
  .main(install)
  .command(installCommand)
  .command(editCommand)
  .help({
    bindCommand: true,
    bindOption: true,
  })
