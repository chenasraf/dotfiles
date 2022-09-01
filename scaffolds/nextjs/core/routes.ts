import { useRouter } from 'next/router'
import React from 'react'

const _signup = '/signup'
const _flats = '/flats'
const _user = '/user'

export const Routes = {
  Home: '/',

  // Signup
  Signup: _signup,
  SignupUserDetails: `${_signup}/user-details`,

  // User
  Profile: `${_user}/profile`,
  UserDetails: `${_user}/details`,
  Preferences: `${_user}/preferences`,
  Notifications: `${_user}/notifications`,

  // Flats
  MyFlat: `${_flats}/my`,
  MatchedFlatsList: `${_flats}/matches`,
  PotentialFlatsList: `${_flats}/potential`,
  LikedFlatsList: `${_flats}/liked`,
  DislikedFlatsList: `${_flats}/disliked`,
  ViewFlat: `${_flats}/:id`,
}

type RoutePush = (route: string, params?: { [key: string]: string }) => Promise<boolean>

export function usePushRoute(): RoutePush {
  const router = useRouter()
  const goTo = React.useCallback(
    (route: string, params?: { [key: string]: string }) =>
      router.push(buildRoute(route, params ?? {})),
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
