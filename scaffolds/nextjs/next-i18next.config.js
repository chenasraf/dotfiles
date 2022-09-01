module.exports = {
  debug: process.env.NODE_ENV === 'development',
  i18n: {
    defaultLocale: 'he',
    locales: ['he'],
  },
  defaultNS: '{{ hyphenCase name }}',
  reloadOnPrerender: process.env.NODE_ENV === 'development',
}
