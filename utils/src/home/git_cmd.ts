import { CommandConfig, MassargCommand } from 'massarg/command'
import { DF_DIR, HomeOpts } from './common'
import { runCommand } from '../common'

type PushOpts = HomeOpts & {
  message?: string
}

type GitOpts = HomeOpts & {
  args: string[]
}

function createGitCommand<O extends HomeOpts>(
  name: string,
  commands?: (opts: O) => string[],
  config?: Partial<CommandConfig<O>>,
): MassargCommand<O> {
  return new MassargCommand<O>({
    name,
    description: `Run git ${name}`,
    aliases: [name[0].toLowerCase()],
    run: async (opts) => {
      if (commands) {
        for (const command of commands(opts)) {
          await runCommand(opts, `git -C ${DF_DIR} ${command}`)
        }
      } else {
        runCommand(opts, `git -C ${DF_DIR} ${name}`)
      }
    },
    ...config,
  })
}
export const gitCommand = createGitCommand<GitOpts>(
  'git',
  (opts) => [opts.args.map((e) => (e.includes(' ') ? JSON.stringify(e) : e)).join(' ')],
  { description: 'Run git command' },
).option({
  name: 'args',
  description: 'Arguments to pass to git',
  aliases: ['a'],
  array: true,
  isDefault: true,
  required: true,
})

export const pushCommand = new MassargCommand<PushOpts>({
  name: 'push',
  run: async (opts) => {
    const code = await runCommand(opts, `git -C ${DF_DIR} diff --quiet`)
    if (code !== 0) {
      await runCommand(opts, `git -C ${DF_DIR} add .`)
      await runCommand(
        opts,
        `git -C ${DF_DIR} commit ${opts.message ? `-m "${opts.message}"` : ''}`,
      )
    }
    await runCommand(opts, `git -C ${DF_DIR} push`)
  },
  description: 'Push all (incl. uncommitted) changes to remote',
}).option({
  name: 'message',
  description: 'Commit message',
  aliases: ['m'],
})

export const pullCommand = createGitCommand('pull', undefined, { aliases: ['l'] })

export const statusCommand = createGitCommand('status', undefined, {
  description: 'Show git status',
})
