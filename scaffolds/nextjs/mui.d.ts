import { PaletteOptions, PaletteColorOptions } from '@mui/material/styles/createPalette'

declare module '@mui/material/styles/createTheme' {
  type Shadows =
    | 'input'
    | 'card'
    
  interface ThemeOptions {
    boxShadows: Record<Shadows, string>
  }

  interface Theme {
    boxShadows: Record<Shadows, string>
  }
}
declare module '@mui/material/styles/createPalette' {
  export interface PaletteOptions {
    link?: PaletteColorOptions
    disabled?: PaletteColorOptions
    disabledBackground?: PaletteColorOptions
  }
}
