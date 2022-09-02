import { {{#unless nextComponents}}useNavigate as {{/unless}}useRouter } from '{{#if nextComponents}}next/router{{else}}react-router{{/if}}'
import React from 'react'

export const Routes = {
  Home: '/',
  Register: '/register',
  Login: '/login',
}

type RoutePush = (route: string, params?: { [key: string]: string }) => {{#if nextComponents}}Promise<boolean>{{else}}void{{/if}}

export function usePushRoute(): RoutePush {
  const router = useRouter()
  const goTo = React.useCallback(
    (route: string, params?: { [key: string]: string }) =>
      {{#if nextComponents}}
      router.push(buildRoute(route, params ?? {})),
      {{else}}
      router(buildRoute(route, params ?? {})),
      {{/if}}
      
    [router],
  )
  return goTo
}

export function buildRoute(route: string, params: { [key: string]: string }): string {
  if (!route.includes(':')) {
    console.warn('Route does not contain any params', route)
    return route
  }
  return Object.entries(params).reduce((acc, [key, value]) => acc.replace(`:${key}`, value), route)
}
