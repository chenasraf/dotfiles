import React from 'react'
import debounce from 'lodash/debounce'
import { DebouncedFunc } from 'lodash'
import { ENV } from '../env'

export interface UseWindowSizeOptions {
  type: 'inner' | 'outer'
  delay?: number
}
export function useWindowSize({
  type = 'inner',
  delay = 100,
}: Partial<UseWindowSizeOptions> = {}): {
  width: number
  height: number
} {
  const wKey: keyof Window = React.useMemo(() => `${type}Width` as keyof Window, [type])
  const hKey: keyof Window = React.useMemo(() => `${type}Height` as keyof Window, [type])

  const [windowSize, setWindowSize] = React.useState({
    {{#if nextComponents}}
    width: ENV.BROWSER_LOADED ? window[wKey] : 0,
    height: ENV.BROWSER_LOADED ? window[hKey] : 0,
    {{else}}
    width: window[wKey],
    height: window[hKey],
    {{/if}}
  })

  const handleResize = useDebounce(
    (): void => setWindowSize({ width: window?.[wKey] ?? 0, height: window?.[hKey] ?? 0 }),
    delay,
    [hKey, wKey, delay],
  )

  React.useEffect(() => {
    window.addEventListener('resize', handleResize)
    return () => window.removeEventListener('resize', handleResize)
  }, [hKey, handleResize, wKey])

  return windowSize
}

export function useDebounce<T extends (...any: unknown[]) => unknown>(
  fn: T,
  delay: number | undefined = undefined,
  deps: unknown[] = [],
): DebouncedFunc<T> {
  const cb = React.useMemo(() => debounce(fn, delay), [fn, delay])
  return React.useCallback(cb, [cb, ...deps])
}

export function preventDefault<
  T extends React.SyntheticEvent,
  Cb extends (e: T, ...args: unknown[]) => void = (e: T, ...args: unknown[]) => void,
>(cb: Cb): Cb {
  return ((e: T, ...args: unknown[]): void => {
    e.preventDefault()
    e.stopPropagation()
    cb(e, ...args)
  }) as unknown as Cb
}
