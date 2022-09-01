import { useTranslation } from 'next-i18next'

export function useLocaleDirection(): 'ltr' | 'rtl' {
  const { i18n } = useTranslation()
  return i18n.dir(i18n.language)
}
