import { CosmiconfigResult, cosmiconfig } from 'cosmiconfig'
import * as path from 'node:path'
import * as os from 'node:os'
import * as fs from 'node:fs/promises'
import { Opts, getCommandOutput, runCommand } from '../common'
import { spawn } from 'node:child_process'

const searchDirs = [
  process.cwd(),
  __dirname,
  os.homedir(),
  path.join(os.homedir(), '.dotfiles'),
  process.env.APPDATA,
].filter(Boolean) as string[]

function searchPatterns(name: string) {
  return [`.${name}.yaml`, `.${name}.yml`, `.config/.${name}.yaml`, `.config/.${name}.yml`]
}

const globalExplorer = cosmiconfig('tmux', { searchPlaces: searchPatterns('tmux') })
const localExplorer = cosmiconfig('tmux_local', { searchPlaces: searchPatterns('tmux_local') })

export type TmuxConfigItemInput = {
  root: string
  name: string
  blank_window?: boolean
  windows: TmuxWindowInput[]
}

export type TmuxWindowInput = string | TmuxWindow

export type TmuxWindow = {
  name: string
  cwd: string
  layout?: TmuxLayoutInput
}

export type TmuxLayoutInput = string | string[] | TmuxPaneLayout

export type TmuxPane = {
  dir: string
  cmd?: string
}

export type ConfigFile = Record<string, TmuxConfigItemInput>

export type ParsedTmuxConfigItem = Omit<TmuxConfigItemInput, 'windows'> & {
  windows: ParsedTmuxWindow[]
}

export type ParsedTmuxWindow = Omit<TmuxWindow, 'layout'> & { layout: TmuxPaneLayout }

export type TmuxWindowLayout = {
  name: string
  cwd: string
  panes: TmuxPaneLayout[]
}

type TmuxSplitLayout = {
  direction: 'h' | 'v'
  child: TmuxPaneLayout
}

export type TmuxPaneLayout = {
  cwd: string
  cmd?: string
  zoom?: boolean
  split?: TmuxSplitLayout
}

const defaultEmptyPane: TmuxPaneLayout = {
  cwd: '.',
  cmd: '',
}

const defaultEmptyLayout: TmuxPaneLayout = {
  ...defaultEmptyPane,
  zoom: false,
  split: {
    direction: 'h',
    child: {
      cwd: '.',
      split: {
        direction: 'v',
        child: {
          cwd: '.',
        },
      },
    },
  },
}

export function transformCmdToTmuxKeys(cmd: string): string {
  if (!cmd.trim()) return ''
  let string = ''
  const map: Record<string, string> = {
    ' ': 'Space',
    '\n': 'Enter',
  }
  for (const letter of cmd.split('')) {
    string += map[letter] ? ` ${map[letter]} ` : letter
  }
  return string.toString()
}

export function parseConfig(key: string, item: TmuxConfigItemInput): ParsedTmuxConfigItem {
  const dirFix = (dir: string) => dir.replace('~', os.homedir())
  const root = dirFix(item.root)
  const name = item.name || key || path.basename(root)
  const _windows = item.windows || []
  if (!_windows.length || item.blank_window) {
    _windows.unshift({ ...defaultEmptyLayout, name: name, cwd: root })
  }
  const windows = _windows.map((w): ParsedTmuxWindow => {
    if (typeof w === 'string') {
      return {
        name: nameFix(path.basename(path.resolve(root, w))),
        cwd: dirFix(path.resolve(root, w)),
        layout: {
          ...parseLayout(defaultEmptyLayout, dirFix(path.resolve(root, w))),
          cwd: dirFix(path.resolve(root, w)),
        },
      }
    }
    return {
      name: w.name || nameFix(dirFix(path.basename(path.resolve(root, w.cwd)))),
      cwd: dirFix(path.resolve(root, w.cwd)),
      layout: parseLayout(w.layout, dirFix(path.resolve(root, w.cwd))),
    }
  })
  const tmuxConfig = {
    name,
    root,
    windows,
  }
  return tmuxConfig
}

export function nameFix(name: string) {
  return (name || '').includes('.') ? name.split('.').filter(Boolean)[0] : name
}

export type ConfigType = 'local' | 'global' | 'merged'

function mergeConfigs(...configs: ConfigFile[]): ConfigFile {
  const out: ConfigFile = {}
  for (const config of configs) {
    for (const key in config) {
      if (!out[key]) {
        out[key] = config[key]
      } else {
        out[key] = {
          ...out[key],
          ...config[key],
        }
      }
    }
  }
  return out
}

export async function getTmuxConfigFileInfo(): Promise<
  Record<Exclude<ConfigType, 'merged'>, CosmiconfigResult> & {
    merged: NonNullable<CosmiconfigResult>
  }
> {
  const out: Record<'local' | 'global', CosmiconfigResult> = {
    local: null,
    global: null,
  }

  for (const dir of searchDirs) {
    const result = await globalExplorer.search(dir)
    if (result) {
      out.global = result
      break
    }
  }

  for (const dir of searchDirs) {
    const result = await localExplorer.search(dir)
    if (result) {
      out.local = result
      break
    }
  }

  const merged = mergeConfigs(out.global?.config, out.local?.config)
  if (!out.global && !out.local) {
    throwNoConfigFound()
  }
  return {
    ...out,
    merged: {
      config: merged,
      filepath: 'merged',
    },
  }
  // return results
}

export function throwNoConfigFound() {
  throw new Error(
    [
      'tmux config file not found, searched in:',
      '\t' +
        searchDirs
          .map((x) =>
            searchPatterns('tmux')
              .map((y) => path.join(x, y))
              .join('\n\t'),
          )
          .join('\n\t'),
      '\t' +
        searchDirs
          .map((x) =>
            searchPatterns('tmux_local')
              .map((y) => path.join(x, y))
              .join('\n\t'),
          )
          .join('\n\t'),
      // searchInFor('tmux').map(x => path.join(d)).join('\n\t'),
      // searchInFor('tmux_local').join('\n\t'),
    ].join('\n'),
  )
}

export async function getTmuxConfig(): Promise<ConfigFile> {
  const files = await getTmuxConfigFileInfo()
  return files.merged.config
}

export async function sessionExists(opts: Opts, sessionName: string): Promise<boolean> {
  try {
    const { code } = await getCommandOutput(
      { ...opts, dry: false },
      `tmux has-session -t ${sessionName}`,
    )
    return code === 0
  } catch (error) {
    return false
  }
}

export type FzfOptions = {
  allowCustom?: boolean
}

export async function fzf(
  _opts: Opts,
  inputs: string[],
  fzfOpts: FzfOptions = {},
): Promise<string> {
  let cmd = `echo "${inputs.join('\n')}" | fzf`
  if (fzfOpts.allowCustom) {
    cmd += ' --print-query | tail -1'
  }
  const fzf = spawn(cmd, {
    stdio: ['inherit', 'pipe', 'inherit'],
    shell: true,
  })

  fzf.stdout.setEncoding('utf-8')

  return new Promise((resolve, reject) => {
    fzf.stdout.on('readable', function () {
      const value = fzf.stdout.read()

      if (value !== null) {
        resolve(value.toString().trim())
        return
      }
      reject(new Error('fzf cancelled or encountered an error'))
    })

    fzf.on('exit', (code) => {
      if (code === 1) {
        reject(new Error('fzf cancelled or encountered an error'))
      }
    })
  })
}

export async function attachToSession(opts: Opts, sessionName: string): Promise<void> {
  if (process.env.TMUX) {
    await runCommand(opts, `tmux switch-client -t ${sessionName}`)
    return
  }
  await runCommand(opts, `tmux attach -t ${sessionName}`)
  return
}

function parseLayout(layoutInput: TmuxLayoutInput | undefined, root: string): TmuxPaneLayout {
  const layout = layoutInput as TmuxPaneLayout
  if (!layout) {
    return {
      ...defaultEmptyLayout,
      cwd: path.resolve(root, '.'),
    }
  }
  if (typeof layoutInput === 'string') {
    return {
      ...defaultEmptyPane,
      cwd: path.resolve(root, layoutInput),
    }
  }
  if (Array.isArray(layoutInput)) {
    return {
      ...parseLayout(defaultEmptyLayout, root),
      split: layoutInput.reduceRight(
        (acc, cwd) => {
          return {
            direction: 'h',
            child: {
              cwd: path.resolve(root, cwd),
              split: acc,
            },
          }
        },
        undefined as unknown as TmuxSplitLayout,
      ),
    }
  }
  return {
    cwd: path.resolve(root, layout.cwd),
    cmd: layout.cmd,
    zoom: layout.zoom,
    split: layout.split
      ? ({
          direction:
            typeof layout.split === 'string' ? layout.split : layout.split.direction || 'h',
          child: parseLayout(layout.split.child, path.resolve(root, layout.cwd)),
        } as TmuxSplitLayout)
      : undefined,
  }
}

export async function pathExists(path: string) {
  return fs.stat(path).catch(() => false)
}

export async function isDirectory(path: string) {
  return fs
    .stat(path)
    .then((stat) => stat.isDirectory())
    .catch(() => false)
}

export async function isFile(path: string) {
  return fs
    .stat(path)
    .then((stat) => stat.isFile())
    .catch(() => false)
}
