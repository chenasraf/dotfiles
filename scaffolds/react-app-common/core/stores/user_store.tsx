import { makeAutoObservable } from 'mobx'
import { User } from '../models/user'
import userApi, { UserLoginParams, UserRegisterResponse } from '../api/user.api'
import { ENV } from '../env'
import { Routes, usePushRoute } from '../routes'
import { {{#unless nextComponents}}useLocation as {{/unless}}useRouter } from '{{#if nextComponents}}next/router{{else}}react-router{{/if}}'

export type ProviderType = 'facebook' | 'google'

export interface ParsedProviderDetails {
  provider: ProviderType
  accessToken: string
  email: string
  firstName: string
  lastName: string
}

class UserStore {
  maybeUser: User | null = null
  provider: ProviderType | null = null
  /** Token used to login to {{ hyphenCase name }} only - sourced from social login */
  accessToken: string | null = null
  /** Token used to auth inside {{ hyphenCase name }} - sourced from `/login` endpoint */
  idToken: string | null = null
  loading = true

  constructor() {
    makeAutoObservable(this)
    
    if ({{#if nextComponents}}ENV.BROWSER_LOADED && {{/if}}localStorage.getItem('idToken')) {
      this.getStoredIdToken()
    }
    if ({{#if nextComponents}}ENV.BROWSER_LOADED && {{/if}}localStorage.getItem('accessToken')) {
      this.getStoredAccessToken()
    }
  }

  public async login(params: UserLoginParams): Promise<UserRegisterResponse> {
    this.loading = true
    const resp = await userApi.login(params)
    const { user, id_token: idToken } = resp
    this.setUser(user)
    this.setIdToken(idToken)
    this.setAccessToken(params.provider, params.accessToken)
    this.loading = false
    return resp
  }

  public async silentLogin(): Promise<UserRegisterResponse | undefined> {
    this.loading = true
    this.getStoredAccessToken()
    if (this.provider && this.accessToken) {
      const resp = await this.login({ provider: this.provider, accessToken: this.accessToken })
      this.loading = false
      return resp
    }
    this.loading = false
  }

  /** Token used to login to {{ hyphenCase name }} only - sourced from social login */
  public getStoredAccessToken() {
    const provider = localStorage.getItem('tokenProvider') as ProviderType | null
    const token = localStorage.getItem('accessToken')
    if (provider && token) {
      this.setAccessToken(provider, token)
    }
  }

  /** Token used to auth inside {{ hyphenCase name }} - sourced from `/login` endpoint */
  public getStoredIdToken() {
    const token = localStorage.getItem('idToken')
    if (token) {
      this.setIdToken(token)
    }
  }

  public get user(): User {
    return this.maybeUser!
  }

  private setUser(user: User) {
    this.maybeUser = user
  }

  public get isLoggedIn(): boolean {
    return Boolean(this.maybeUser)
  }

  /** Token used to login to {{ hyphenCase name }} only - sourced from social login */
  private setAccessToken(provider: ProviderType, accessToken: string) {
    {{#if nextComponents}} if (ENV.BROWSER_LOADED) { {{/if}}
      localStorage.setItem('accessToken', accessToken)
      localStorage.setItem('tokenProvider', provider)
    {{#if nextComponents}} } {{/if}}
    this.accessToken = accessToken
    this.provider = provider
  }

  /** Token used to auth inside {{ hyphenCase name }} - sourced from `/login` endpoint */
  private setIdToken(idToken: string) {
    {{#if nextComponents}} if (ENV.BROWSER_LOADED) { {{/if}}
      localStorage.setItem('idToken', idToken)
    {{#if nextComponents}} } {{/if}}
    this.idToken = idToken
    userApi.setAuthHeaders(idToken)
  }
}

const _userStore = new UserStore()

/** Don't forget to wrap in observer if needed */
export function useUserStore(): UserStore {
  return _userStore
}

/** Don't forget to wrap in observer if needed */
export function useUser(): User {
  return useUserStore().user
}

function _useLoginRedirect(force?: boolean): (registered: boolean) => void {
  const goTo = usePushRoute()
  const router = useRouter()

  return (registered) => {
    if (!force && router.pathname !== '/') {
      return
    }
    if (registered || force) {
      // TODO use [Routes.Home] once redirect is removed
      goTo(Routes.Home)
    } else {
      goTo(Routes.Register)
    }
  }
}

export function useLoginFlow(forceRedirect?: boolean): (details: UserLoginParams) => Promise<void> {
  const store = useUserStore()
  const redirect = _useLoginRedirect(forceRedirect)

  return async (details) => {
    const { registered } = await store.login(details)
    redirect(registered)
  }
}

export function useSilentLoginFlow(forceRedirect?: boolean): () => Promise<void> {
  const store = useUserStore()
  const redirect = _useLoginRedirect(forceRedirect)
  const goTo = usePushRoute()
  const router = useRouter()

  return async () => {
    try {
      const resp = await store.silentLogin()
      if (!resp) {
        // TODO check public route permission instead of directly checking against [Routes.Home]
        if (!store.isLoggedIn && router.pathname !== Routes.Home) {
          goTo(Routes.Register)
        }
        return
      }
      redirect(resp.registered)
    } catch (e) {
      goTo(Routes.Register)
    }
  }
}
