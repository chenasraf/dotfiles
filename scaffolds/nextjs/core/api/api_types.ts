export type SingleResult<T, K extends string> = {
  [result in K]: T
} & {
  error: boolean
  msg: string
}
export type ListResult<T, K extends string> = {
  [result in K]?: T[]
} & {
  count: number
  error: boolean
  msg: string
}
