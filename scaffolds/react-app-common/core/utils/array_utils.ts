export function asArray<T extends any[]>(value: T | T[0]): T {
  if (value === null || value === undefined) return [] as any
  return Array.isArray(value) ? value : ([value] as any)
}
