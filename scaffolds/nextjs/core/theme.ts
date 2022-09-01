import { alpha } from '@mui/material/styles'
import createTheme, { Theme } from '@mui/material/styles/createTheme'

const colors = {
  primary: '#638DB3',
  link: '#0066FF',
  primaryGradientTop: '#7EACD6',
  primaryGradientBottom: '#6089AF',
  disabledBackground: '#bdbdbd',
  disabled: '#DCDCDC',
}

const shadows = {
  input: `0 2px 10px ${alpha('#000000', 0.25)}`,
  card: `0 1px 9px ${alpha('#000000', 0.25)}`,
  likedCard: `0 1px 9px 1px ${alpha('#0FA639', 0.5)}`,
  dislikedCard: `0 1px 9px 1px ${alpha('#E22F29', 0.5)}`,
  mutualCard: `0 1px 9px 1px ${alpha('#0C77DF', 0.5)}`,
  matchButton: `0 2px 9px 0 ${alpha('#000000', 0.25)}`,
  avatar: `0 4px 11px ${alpha('#000000', 0.38)}`,
}

export const lightTheme = createTheme({
  boxShadows: shadows,
  typography: {
    fontFamily: 'Assistant, Roboto, Helvetica, sans-serif',
  },
  palette: {
    mode: 'light',
    primary: {
      main: colors.primary,
    },
    link: {
      main: colors.link,
    },
    disabled: {
      main: colors.disabled,
    },
    disabledBackground: {
      main: colors.disabledBackground,
    },
  },
  components: {
    MuiLink: {
      styleOverrides: {
        root: {
          color: colors.link,
          textDecoration: 'none',
        },
      },
    },
    MuiButton: {
      styleOverrides: {
        root: {
          fontSize: '24px',
          fontWeight: 600,
          borderRadius: '2em',
          minWidth: '200',
          '&.Mui-disabled': {
            background: colors.disabledBackground,
          },
        },
        containedPrimary: {
          background: `linear-gradient(180deg, ${colors.primaryGradientTop}, ${colors.primaryGradientBottom})`,
        },
      },
    },
    MuiTextField: {
      styleOverrides: {
        root: {
          fontSize: '20',
        },
      },
    },
    MuiInputBase: {
      styleOverrides: {
        multiline: {
          borderRadius: '0 !important',
        },
      },
    },
    MuiSelect: {
      defaultProps: {
        variant: 'outlined',
      },
    },
    MuiOutlinedInput: {
      styleOverrides: {
        root: {
          borderRadius: '2em',
          boxShadow: shadows.input,
          outline: 'none',
        },
        notchedOutline: {
          border: '0',
        },
      },
    },
    MuiTypography: {
      styleOverrides: {
        h5: {
          fontSize: 22,
        },
      },
    },
  },
})

export function themeDir(theme: Theme, direction: 'ltr' | 'rtl'): Theme {
  return { ...theme, direction }
}
