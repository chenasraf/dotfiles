import { serverSideTranslations } from 'next-i18next/serverSideTranslations'

export async function getI18nProps(locale: string | undefined | null, namespaces: string[]) {
  return serverSideTranslations(
    locale ?? 'he',
    Array.from(new Set(['{{ hyphenCase name }}', ...namespaces])),
  )
}

// export async function getI18nPropsFn(namespaces: string[]) {
//   return async ({ locale }: NextPageContext) => {
//     return { props: await serverSideTranslations(locale ?? 'he', namespaces) }
//   }
// }
