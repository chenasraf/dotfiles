import NextLink, { LinkProps as NextLinkProps } from 'next/link'
import MUILink, { LinkProps as MUILinkProps } from '@mui/material/Link'

export const LinkBehavior: React.FC<MUILinkProps> = (props) => {
  const { href, children, ...rest } = props
  return (
    <NextLink passHref href={href!}>
      <MUILink {...rest}>{children}</MUILink>
    </NextLink>
  )
}

export default LinkBehavior