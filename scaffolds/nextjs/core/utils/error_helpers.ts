import { useTranslation } from 'next-i18next'
import React from 'react'
import { FieldErrors } from 'react-hook-form'

export function useFormErrorText<T>(
  errors: FieldErrors<T>,
): (key: keyof T, error: string) => string | undefined {
  const fn = React.useCallback(
    (key: keyof T, error: string) => (errors?.[key] ? error : undefined),
    [errors],
  )

  return fn
}
