import React from 'react'
import { NextPage, NextPageContext } from 'next'
import { useRouter } from 'next/router'
import { getI18nProps } from '../../core/i18n'
import { useTranslation } from 'next-i18next'
import Box from '@mui/material/Box'
import { PageWrapper } from '../../components/atoms/PageWrapper'

// NOTE
// This page mights need to be SSRed using `getStaticProps`. If that's the case,
// we will need to use `getStaticPaths` to generate the routes.

export const {{pascalCase name}}: NextPage = () => {
  const router = useRouter()
  const params = router.query
  const { t } = useTranslation('{{snakeCase name}}')

  return (
    <PageWrapper pageTitle="{{ startCase name }}" htmlTitle="{{ pascalCase name }}" htmlDescription="{{ pascalCase name }} App">
      <Box>
        {{ pascalCase name }} Page
      </Box>
    </PageWrapper>
  )
}

export async function getServerSideProps({ locale }: NextPageContext) {
  return {
    props: await getI18nProps(locale, ['{{snakeCase name}}']),
  }
}

export default {{pascalCase name}}
