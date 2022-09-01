export const ENV = {
  BROWSER_LOADED: typeof window !== 'undefined',
  API_BASE: process.env.NEXT_PUBLIC_API_BASE!,
  API_TEST: process.env.NODE_ENV === 'development' || process.env.NEXT_PUBLIC_API_TEST === 'true',
  MAPBOX_API_KEY: process.env.NEXT_PUBLIC_MAPBOX_API_KEY!,
  FACEBOOK_APP_ID: process.env.NEXT_PUBLIC_FACEBOOK_APP_ID!,
}
