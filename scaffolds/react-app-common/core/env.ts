export const ENV = {
  {{#if nextComponents}}
  BROWSER_LOADED: typeof window !== 'undefined',
  {{/if}}
  API_BASE: '/api',
  IS_DEBUG: process.env.NODE_ENV === 'development',
}
