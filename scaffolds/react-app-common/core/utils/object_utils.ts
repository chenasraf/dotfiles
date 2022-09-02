import { SxProps } from '@mui/material/styles'
import { Theme } from '@mui/material/styles/createTheme'
import { SystemCssProperties } from '@mui/system/styleFunctionSx'
import { Option } from '../types'
import { asArray } from './array_utils'

export function uniqueKeyFromObj<T>(object: T, keys?: Array<keyof T>): string {
  if (!keys) {
    keys = Object.keys(object) as Array<keyof T>
  }
  return keys.map((key) => String(object[key]).replaceAll(/[^a-z0-9]+/gi, '_')).join('-')
}

export function uniqueKeyFrom(...array: Array<any>): string {
  return array.map((item) => String(item).replaceAll(/[^a-z0-9]+/gi, '_')).join('-')
}

/**
 * Combines `sx` props easily
 * @param sx sx prop for this component
 * @param rest passed sx props from parent
 * @returns sx compatible props combined
 */
export function sxc(
  sx: SxProps<Theme>,
  ...rest: Array<SxProps<Theme> | SystemCssProperties<Theme> | undefined | false>
): SxProps<Theme> {
  return [...asArray(sx), ...asArray(rest)]
}

export function optionFrom(value: string): Option<string> {
  return { label: value, value }
}
