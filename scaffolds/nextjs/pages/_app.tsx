import React from 'react'
import type { AppProps } from 'next/app'
import CssBaseline from '@mui/material/CssBaseline'
import ThemeProvider from '@mui/material/styles/ThemeProvider'
import { lightTheme, themeDir } from 'core/theme'
import { CacheProvider, EmotionCache } from '@emotion/react'
import { createEmotionCache } from 'core/emotion'
import { enableStaticRendering } from 'mobx-react-lite'
import { appWithTranslation, useTranslation } from 'next-i18next'
import nextI18nConfig from '../next-i18next.config'
import { QueryClientProvider, QueryClient } from 'react-query'
import { ENV } from 'core/env'
import { useSilentLoginFlow } from 'core/stores/user_store'

export interface {{ pascalCase name }}AppProps extends AppProps {
  emotionCache?: EmotionCache
}

let windowInit = false

const clientSideEmotionCache = createEmotionCache()
const isBrowserLoaded = ENV.BROWSER_LOADED
enableStaticRendering(!isBrowserLoaded)

const _{{ pascalCase name }}App: React.FC<{{ pascalCase name }}AppProps> = (props) => {
  const { Component, pageProps, emotionCache = clientSideEmotionCache } = props
  const queryClient = new QueryClient({
    defaultOptions: {
      queries: {
        staleTime: Infinity,
        refetchOnMount: false,
        refetchOnReconnect: false,
        refetchOnWindowFocus: false,
      },
    },
  })

  const { i18n } = useTranslation()
  const themeWithDirection = React.useMemo(
    () => themeDir(lightTheme, i18n.dir(i18n.language)),
    [i18n],
  )
  const silentLogin = useSilentLoginFlow()

  React.useEffect(() => {
    if (!windowInit && typeof window !== 'undefined') {
      windowInit = true
      silentLogin()
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [typeof window])

  return (
    <QueryClientProvider client={queryClient}>
      <CacheProvider value={emotionCache}>
        <ThemeProvider theme={themeWithDirection}>
          <CssBaseline />
          <Component {...pageProps} />
        </ThemeProvider>
      </CacheProvider>
    </QueryClientProvider>
  )
}

const {{ pascalCase name }}App = appWithTranslation(_{{ pascalCase name }}App, nextI18nConfig)

export default {{ pascalCase name }}App
