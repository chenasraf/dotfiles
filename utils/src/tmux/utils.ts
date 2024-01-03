import { CosmiconfigResult, cosmiconfig } from 'cosmiconfig'
import * as path from 'node:path'
import * as os from 'node:os'
import { Opts, getCommandOutput } from '../common'
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

export type TmuxConfigItem = {
  root: string
  name: string
  windows: TmuxWindowType[]
}

export type TmuxWindowType = string | TmuxWindow

export type TmuxWindow = {
  name: string
  dir: string
  layout?: 'default'
  panes: TmuxPaneType[]
}

export type TmuxPaneType = string | TmuxPane

export type TmuxPane = {
  dir: string
  cmd?: string
}

export type ConfigFile = Record<string, TmuxConfigItem>

export type ParsedTmuxConfigItem = Omit<TmuxConfigItem, 'windows'> & { windows: ParsedTmuxWindow[] }

export type ParsedTmuxWindow = Omit<TmuxWindow, 'panes'> & { panes: TmuxPane[] }
export type TmuxLayoutType = 'row' | 'column' | 'pane'

export type TmuxLayout =
  | {
    type: Exclude<TmuxLayoutType, 'pane'>
    children: TmuxLayout[]
    zoom?: boolean
  }
  | {
    type: 'pane'
    zoom?: boolean
  }

const defaultPanes = [
  {
    dir: '.',
    cmd: 'nvim .',
  },
  { dir: '.' },
  { dir: '.' },
]

export function transformCmdToTmuxKeys(cmd: string): string {
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

export function parseConfig(item: TmuxConfigItem): ParsedTmuxConfigItem {
  const dirFix = (dir: string) => dir.replace('~', os.homedir())
  const root = dirFix(item.root)
  const windows = (item.windows || []).map((w) => {
    if (typeof w === 'string') {
      return {
        name: nameFix(path.basename(path.resolve(root, w))),
        dir: dirFix(path.resolve(root, w)),
        panes: defaultPanes,
      }
    }
    return {
      name: nameFix(w.name || dirFix(path.basename(path.resolve(root, w.dir)))),
      dir: path.resolve(root, w.dir),
      panes: w.panes
        ? w.panes.map((p) => {
          if (typeof p === 'string') {
            return {
              dir: dirFix(path.resolve(root, w.dir, p)),
            }
          }
          return {
            dir: dirFix(path.resolve(root, w.dir, p.dir)),
            cmd: p.cmd,
          }
        })
        : defaultPanes,
    }
  })
  const tmuxConfig = {
    name: item.name || path.basename(root),
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

export async function fzf(opts: Opts, inputs: string[]): Promise<string> {
  const fzf = spawn(`echo "${inputs.join('\n')}" | fzf`, {
    stdio: ['inherit', 'pipe', 'inherit'],
    shell: true,
  })

  fzf.stdout.setEncoding('utf-8')

  return new Promise((resolve, reject) => {
    fzf.stdout.on('readable', function() {
      const value = fzf.stdout.read()

      if (value !== null) {
        resolve(value.toString().trim())
        return
      }
      reject()
    })
  })
}
