import React from 'react'
import Box, { BoxProps } from '@mui/material/Box'
import { CustomComponent } from 'core/types'
import CircularProgress from '@mui/material/CircularProgress'
import { TOOLBAR_HEIGHT } from './MainAppBar'

// eslint-disable-next-line @typescript-eslint/no-empty-interface
export interface PageLoaderProps extends CustomComponent<BoxProps> {
  //
}

export const PageLoader: React.FC<PageLoaderProps> = ({ sx }) => {
  return (
    <Box
      position="absolute"
      top={TOOLBAR_HEIGHT}
      bottom={0}
      left={0}
      right={0}
      display="flex"
      alignItems="center"
      justifyContent="center"
      width="100%"
      height="calc(100vh - 90px)"
      sx={sx}
    >
      <CircularProgress size={64} />
    </Box>
  )
}
