import { spawn } from 'node:child_process'

export function log({ verbose, dry }: Opts, ...content: any[]) {
  if (!verbose && !dry) return
  console.log(...content)
}

export type Opts = {
  key: string
  verbose: boolean
  dry: boolean
}

export async function runCommand(opts: Opts, command: string) {
  const [cmd, ...args] = command.split(' ')
  log(opts, '$ ' + command)
  if (opts.dry) return 0
  const proc = spawn(cmd, args, { stdio: 'inherit' })
  return new Promise((resolve, reject) => {
    proc.on('close', (code) => {
      if (code === 0) {
        resolve(code)
      } else {
        reject(code)
      }
    })
  })
}

export async function getCommandOutput(
  opts: Opts,
  command: string,
): Promise<{ code: number; output: string }> {
  const [cmd, ...args] = command.split(' ')
  log(opts, '$ ' + command)
  if (opts.dry) return { code: 0, output: '' }
  const proc = spawn(cmd, args, { stdio: 'pipe' })
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
