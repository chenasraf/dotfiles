import React from 'react'
import Box, { BoxProps } from '@mui/material/Box'
import { sxc } from 'core/utils/object_utils'
import { CustomComponent } from 'core/types'
import Image from '{{ imageImport }}'
import { apiFallbackImageUrl } from 'core/utils/image_utils'

export interface AvatarProps extends CustomComponent<BoxProps> {
  src: string
  size?: number
  padding?: number
}

export const Avatar: React.FC<AvatarProps> = ({ sx, size = 160, src, padding = 8 }) => {
  return (
    <Box
      sx={sxc(
        {
          width: size,
          height: size,
          borderRadius: '50%',
          overflow: 'hidden',
          boxShadow: (theme) => theme.boxShadows.avatar,
          padding: `${padding}px`,
        },
        sx,
      )}
    >
      <Box
        sx={ {
          width: size - padding * 2,
          height: size - padding * 2,
          borderRadius: '50%',
          overflow: 'hidden',
        } }
      >
        <Image
          src={apiFallbackImageUrl(src)}
          objectFit="cover"
          width={size}
          height={size}
          alt={src}
        />
      </Box>
    </Box>
  )
}
