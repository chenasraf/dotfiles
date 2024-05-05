import os from 'node:os'
import fs from 'node:fs/promises'
import path from 'node:path'
import { Opts, runCommand } from '../common'

export type HomeOpts = Opts

export const DF_DIR = path.join(os.homedir(), '/.dotfiles')

export const DEVICE_UID_FILE = path.join(DF_DIR, '.device_uid')

let DEVICE_UID: string

export async function getDeviceUID() {
  if (!DEVICE_UID) {
    try {
      DEVICE_UID = (await fs.readFile(DEVICE_UID_FILE)).toString().trim()
    } catch (e) {
      console.error(
        `Problem getting specific device UID. Make sure you create the file ${DEVICE_UID_FILE} and write your device UID inside.`,
      )
      console.error('Original error:')
      console.error(e)
    }
  }
  return DEVICE_UID
}

export async function checkGitChanges(opts: HomeOpts): Promise<boolean> {
  const code = await runCommand(opts, `git -C ${DF_DIR} diff --quiet`).catch((code) => code)
  return code !== 0
}
