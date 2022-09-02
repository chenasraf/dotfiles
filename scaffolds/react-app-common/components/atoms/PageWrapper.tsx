import React from 'react'
import Box, { BoxProps } from '@mui/material/Box'
import { sxc } from 'core/utils/object_utils'
import { CustomComponent } from 'core/types'
import { MainAppBar, TOOLBAR_HEIGHT } from './MainAppBar'
import Toolbar from '@mui/material/Toolbar'
import { PageLoader } from './PageLoader'
import Typography from '@mui/material/Typography'
{{#if pageWrapperHead}}
import Head from 'next/head'
{{/if}}

export interface PageWrapperProps extends CustomComponent<BoxProps> {
  fixedMaxWidth?: boolean
  loading?: boolean
  pageTitle?: React.ReactNode
  {{#if pageWrapperHead}}
  htmlTitle?: string
  htmlDescription?: string
  {{/if}}
  render?: (props: PageWrapperProps) => React.ReactNode
}

export const PageWrapper: React.FC<PageWrapperProps> = (props) => {
  const {
    sx,
    children,
    loading,
    fixedMaxWidth = true,
    {{#if pageWrapperHead}}
    htmlTitle,
    htmlDescription,
    {{/if}}
    pageTitle,
    render,
  } = props
  return (
    <Box
      sx={sxc(
        {
          padding: (theme) => theme.spacing(3, 2),
          margin: '0 auto',
        },
        fixedMaxWidth && {
          maxWidth: 600,
        },
        sx,
      )}
    >
      {{#if pageWrapperHead}}
      {htmlTitle || htmlDescription ? (
        <Head>
          <title>{htmlTitle}</title>
          <meta name="description" content={htmlDescription} />
        </Head>
      ) : null}
      {{/if}}
      {/* App Bar */}
      <MainAppBar />
      {/* Empty toolbar - to save space for fixed app bar */}
      <Toolbar sx={ { height: `${TOOLBAR_HEIGHT}px` } } />
      {pageTitle ? (
        <Typography fontWeight={600} variant="h5">
          {pageTitle}
        </Typography>
      ) : null}
      {loading ? <PageLoader /> : render?.(props) ?? children}
    </Box>
  )
}
