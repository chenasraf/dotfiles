import React from 'react'
import type { NextPage } from 'next'
import Head from 'next/head'
import { Routes, usePushRoute } from '../core/routes'

const Home: NextPage = () => {
  const goTo = usePushRoute()

  React.useEffect(() => {
    goTo(Routes.Signup)
  }, [goTo])

  return (
    <div>
      <Head>
        {/* TODO update */}
        <title>{{ pascalCase name }}</title>
        <meta name="description" content="{{ pascalCase name }} App" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
    </div>
  )
}

export default Home
