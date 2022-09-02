import { alpha } from '@mui/material/styles'
import createTheme, { Theme } from '@mui/material/styles/createTheme'

const colors = {
  primary: '#000000',
}

const shadows = {
  input: `0 2px 10px ${alpha('#000000', 0.25)}`,
  card: `0 1px 9px ${alpha('#000000', 0.25)}`,
}

export const lightTheme = createTheme({
  boxShadows: shadows,
  typography: {
    fontFamily: 'Roboto, Helvetica, sans-serif',
  },
  palette: {
    mode: 'light',
  },
  components: {
    MuiSelect: {
      defaultProps: {
        variant: 'outlined',
      },
    },
  },
})

export function themeDir(theme: Theme, direction: 'ltr' | 'rtl'): Theme {
  return { ...theme, direction }
}
