import ChevronLeft from '@mui/icons-material/ChevronLeft'
import MenuIcon from '@mui/icons-material/Menu'
import Notifications from '@mui/icons-material/Notifications'
import Toolbar from '@mui/material/Toolbar'
import AppBar from '@mui/material/AppBar'
import React from 'react'
import IconButton from '@mui/material/IconButton'
import Box from '@mui/material/Box'
import { Routes, usePushRoute } from 'core/routes'
import { useTranslation } from '{{#if nextComponents}}next-i18next{{else}}react-i18next{{/if}}'
import Menu from '@mui/material/Menu'
import MenuItem from '@mui/material/MenuItem'

export const TOOLBAR_HEIGHT = 68

export const MainAppBar: React.FC = React.memo(function MainAppBar() {
  const [menuRef, setMenuRef] = React.useState<HTMLButtonElement | null>(null)
  const goTo = usePushRoute()
  const { t } = useTranslation('{{ hyphenCase name }}')

  const handleMenuClick = React.useCallback((e: React.MouseEvent<HTMLButtonElement>) => {
    setMenuRef(e.currentTarget)
  }, [])

  const handleMenuClose = React.useCallback(() => {
    setMenuRef(null)
  }, [])

  return (
    <>
      <AppBar color="inherit">
        <Toolbar sx={ { height: `${TOOLBAR_HEIGHT}px` } }>
          <IconButton onClick={handleMenuClick} color="inherit">
            <MenuIcon />
          </IconButton>
          <IconButton color="inherit" onClick={() => goTo(Routes.Notifications)}>
            <Notifications />
          </IconButton>
          <Box display="flex" flexGrow={1} alignItems="center" justifyContent="center">
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img src="/logo.svg" alt="{{ pascalCase name }}" width={115} height={25} />
          </Box>
          <IconButton color="inherit">
            <ChevronLeft />
          </IconButton>
        </Toolbar>
      </AppBar>

      <Menu anchorEl={menuRef} open={!!menuRef} onClose={handleMenuClose}>
        <MenuItem onClick={() => goTo(Routes.Home)}>
          {t('app_bar.menu.home')}
        </MenuItem>
      </Menu>
    </>
  )
})
