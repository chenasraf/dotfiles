import { useTranslation } from 'next-i18next'
import React from 'react'

export function useNumberFormatter(options?: Intl.NumberFormatOptions): Intl.NumberFormat {
  const { i18n } = useTranslation()

  return React.useMemo(() => {
    return Intl.NumberFormat(i18n.language, options)
  }, [i18n.language, options])
}
export function useCurrencyFormatter(options?: Intl.NumberFormatOptions): Intl.NumberFormat {
  return useNumberFormatter({
    style: 'currency',
    currency: 'ILS',
    ...options,
  })
}
