import React from 'react'
import { useQuery, UseQueryOptions, UseQueryResult } from 'react-query'
import { ListResult } from '../api/api_types'

export function useRerender(): () => void {
  const [, rerender] = React.useState(0)
  return React.useCallback(() => rerender((r) => r + 1), [rerender])
}

type MaybeKey<K extends string> = `maybe${Capitalize<K>}`

export type EnhancedQueryResponse<T, K extends keyof T> = UseQueryResult<T> & {
  [key in MaybeKey<Exclude<K, number | symbol>>]: T[K] | undefined
} & {
  [key in K]: T[K]
}

type EnhancedQueryHook<T, K extends keyof T> = (
  options?: RequiredQueryOptions<T>,
) => EnhancedQueryResponse<T, K>

export type RequiredQueryOptions<T> = Omit<UseQueryOptions<T>, 'queryKey' | 'queryFn'>

type StateUpdater<T> = T extends unknown[]
  ? {
      add: (item: T[number]) => void
      update: (item: T[number]) => void
      remove: (item: T[number]) => void
    }
  : {
      set: (item: T) => void
    }

type EnhancedQueryOptions<
  K extends Exclude<keyof T, number | symbol>,
  T,
  IKey extends keyof (T[K] extends unknown[] ? T[K][number] : never),
> = {
  cacheKey: string
  responseKey: K
  innerKey?: IKey
  defaultOptions?: RequiredQueryOptions<T>
  // objectId?: (a: never) => unknown
  // objectId?: (a: SingleGetter<T, K, IKey>) => unknown
}

type InnerObjTest<T, K extends keyof T> = T[K] extends unknown[] ? T[K][number] : never

type SingleGetter<
  T,
  K extends keyof T,
  IKey extends keyof InnerObjTest<T, K>,
> = T[K] extends unknown[]
  ? IKey extends keyof T[K][number]
    ? T[K][number][IKey]
    : T[K][number]
  : IKey extends keyof T[K]
  ? T[K][IKey]
  : T[K]

export function createUseApi<
  T,
  K extends Exclude<keyof T, number | symbol>,
  IKey extends keyof (T[K] extends unknown[] ? T[K][number] : never),
>(
  api: () => Promise<T>,
  { cacheKey, responseKey, defaultOptions }: EnhancedQueryOptions<K, T, IKey>,
): EnhancedQueryHook<T, K> {
  return (options): EnhancedQueryResponse<T, K> => {
    const [cache, setCache] = React.useState<T[K]>()

    const { data = {} as T, ...rest } = useQuery([cacheKey], api, {
      ...defaultOptions,
      ...options,
      onSuccess: (data) => {
        setCache(data[responseKey])
        options?.onSuccess?.(data)
      },
    } as Omit<UseQueryOptions<T>, 'queryKey' | 'queryFn'>)
    const ent = data[responseKey]!

    const response: EnhancedQueryResponse<T, K> = {
      ...(rest as UseQueryResult<T>),
      [responseKey]: ent,
      ['maybe' + responseKey[0].toUpperCase() + responseKey.slice(1)]: ent,
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      data: cache as never,
    }
    console.log(cacheKey, 'response', response.data, response)
    return response
  }
}
