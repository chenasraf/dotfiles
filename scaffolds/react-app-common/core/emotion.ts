import createCache from '@emotion/cache'
import stylisRTLPlugin from 'stylis-plugin-rtl'
import { prefixer } from 'stylis'

export const createEmotionCache = () => {
  return createCache({
    key: 'css',
    prepend: true,
    stylisPlugins: [prefixer, stylisRTLPlugin],
  })
}
