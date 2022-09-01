/* eslint-disable @typescript-eslint/no-var-requires */
const withTM = require('next-transpile-modules')(['@mui/material']) // pass the modules you would like to see transpiled
const withImages = require('next-images')
const { i18n } = require('./next-i18next.config')

/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'standalone',
  reactStrictMode: true,
  swcMinify: true,
  i18n,
  images: {
    domains: ['placeholder.photo'],
  },
}

module.exports = withImages(withTM(nextConfig))
