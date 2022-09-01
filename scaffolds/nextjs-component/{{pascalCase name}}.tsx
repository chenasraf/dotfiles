import React from 'react'
import Box, { BoxProps } from '@mui/material/Box'
import { sxc } from '../nextjs/core/utils/object_utils'
import { CustomComponent } from '../nextjs/core/types'

export interface {{pascalCase name}}Props extends CustomComponent<BoxProps> {
  //
}

export const {{pascalCase name}}: React.FC<{{pascalCase name}}Props> = ({ sx, children }) => {
  return <Box sx={sxc({}, sx)}>{children}</Box>
}
