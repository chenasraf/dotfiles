import Box, { BoxProps } from '@mui/material/Box'
import { CustomComponent, HTMLComponent } from 'core/types'

export type ImageProps = CustomComponent<BoxProps> & HTMLComponent<HTMLImageElement>
export const Image: React.FC<ImageProps> = (props) => {
  return <Box component="img" {...props} />
}

export default Image
