import { MassargCommand } from 'massarg/command'
import { spawn } from 'node:child_process'

// Custom error class for user-friendly errors
export class UserError extends Error {
  constructor(message: string) {
    super(message)
    this.name = 'UserError'
  }
}

export type Opts = {
  key: string
  verbose: boolean
  dry: boolean
}

export function withDefaultOpts<T extends Opts, OT extends object = object>(
  command: MassargCommand<OT>,
): MassargCommand<OT & T> {
  return (command as MassargCommand<OT & T>)
    .flag({
      name: 'verbose',
      description: 'Verbose output',
      aliases: ['v'],
    })
    .flag({
      name: 'dry',
      description: 'Dry run',
      aliases: ['d'],
    })
    .help({
      bindOption: true,
      bindCommand: true,
    })
}

export function log({ verbose, dry }: Opts, ...content: unknown[]) {
  if (!verbose && !dry) return
  console.log(...content)
}

export async function runCommand(
  opts: Opts,
  command: string | (string | false | number | null | undefined)[],
): Promise<number> {
  if (Array.isArray(command)) {
    command = command.filter(Boolean).join('; ')
  }
  const [cmd, ...args] = command.split(' ')
  log(opts, '$ ' + command)
  if (opts.dry) return 0
  const proc = spawn(cmd, args, { stdio: 'inherit', shell: '/bin/zsh' })
  return new Promise((resolve, reject) => {
    proc.on('close', (code) => {
      if (code === 0 || code == null) {
        resolve(code ?? 0)
      } else {
        reject(new Error(`Command: \`${cmd} ${args.join(' ')}\` exited with code: ${code}`))
      }
    })
  })
}

export async function getCommandOutput(
  opts: Opts,
  command: string | string[],
): Promise<{ code: number; output: string }> {
  if (Array.isArray(command)) {
    command = command.join('; ')
  }
  const [cmd, ...args] = command.split(' ')
  log(opts, '$ ' + command)
  if (opts.dry) return { code: 0, output: '' }
  const proc = spawn(cmd, args, { stdio: 'pipe', shell: '/bin/zsh' })
  return new Promise<{ code: number; output: string }>((resolve, reject) => {
    let output = ''
    proc.stdout.on('data', (data) => {
      output += data.toString()
    })
    proc.on('close', (code) => {
      if (code === 0) {
        resolve({ code, output })
      } else {
        reject(code)
      }
    })
  })
}

export const yellow = (s: string) => `\x1b[33m${s}\x1b[0m`
