module.exports = {
  debug: process.env.NODE_ENV === 'development',
  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },
  defaultNS: '{{ hyphenCase name }}',
  reloadOnPrerender: process.env.NODE_ENV === 'development',
}
