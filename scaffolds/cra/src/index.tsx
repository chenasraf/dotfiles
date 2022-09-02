import React from 'react';
import ReactDOM from 'react-dom/client';
import CssBaseline from '@mui/material/CssBaseline'
import ThemeProvider from '@mui/material/styles/ThemeProvider'
import { lightTheme, themeDir } from 'theme'
import { useTranslation } from 'react-i18next'
import { QueryClientProvider, QueryClient } from 'react-query'
import { useSilentLoginFlow } from 'stores/user_store'
import reportWebVitals from './reportWebVitals'
import App from './App'

let windowInit = false

const _{{ pascalCase name }}App: React.FC = () => {
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
      <ThemeProvider theme={themeWithDirection}>
        <CssBaseline />
        <App />
      </ThemeProvider>
    </QueryClientProvider>
  )
}

const root = ReactDOM.createRoot(
  document.getElementById('root') as HTMLElement
)

root.render(
  <React.StrictMode>
    <_{{ pascalCase name }}App />
  </React.StrictMode>
)

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
