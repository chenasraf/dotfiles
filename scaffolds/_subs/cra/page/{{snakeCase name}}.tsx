import React from 'react'
import { useHistory } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import Box from '@mui/material/Box'
import { PageWrapper } from 'components/atoms/PageWrapper'

// NOTE
// This page mights need to be SSRed using `getStaticProps`. If that's the case,
// we will need to use `getStaticPaths` to generate the routes.

export const {{pascalCase name}}: React.FC = () => {
  const router = useHistory()
  const params = router.query
  const { t } = useTranslation('{{snakeCase name}}')

  return (
    <PageWrapper pageTitle="{{ startCase name }}">
      <Box>
        {{ pascalCase name }} Page
      </Box>
    </PageWrapper>
  )
}

export default {{pascalCase name}}
