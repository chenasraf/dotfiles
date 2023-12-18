import * as path from 'node:path'
import * as os from 'node:os'
import { Opts } from '../common'

export type HomeOpts = Opts

export const DF_DIR = path.join(os.homedir(), '/.dotfiles')
