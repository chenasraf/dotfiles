import React from 'react'

export interface HTMLComponent<T extends HTMLElement>
  extends React.PropsWithChildren<React.HTMLProps<T>>,
    CustomComponent {
  //
}

export type CustomComponent<T = unknown> = T & {
  className?: string
}

export interface Option<T = unknown> {
  value: T
  label: string
}

export interface ReactOptions<T = unknown> extends Omit<Option<T>, 'label'> {
  label: React.ReactNode
}
