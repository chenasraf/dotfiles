import { ENV } from '../env'
import { User } from '../models/user'
import { ProviderType } from '../stores/user_store'
import { ApiCollection } from './api'

export type GetUserResponse = User

export interface UserRegisterRequest {
  firstName: string
  lastName: string
}

export interface UserLoginParams {
  provider: ProviderType
  accessToken: string
}

export interface UserRegisterResponse {
  id_token: string
  registered: boolean
  ready: boolean
}

class UserApi extends ApiCollection {
  getCurrentUser(): Promise<GetUserResponse> {
    return this.parse(this.client.get<GetUserResponse>('/user/current'))
  }

  login({ provider, accessToken }: UserLoginParams): Promise<UserRegisterResponse> {
    return this.parse(
      this.client.post<UserRegisterResponse>(
        '/login',
        { provider },
        {
          baseURL: ENV.API_BASE,
          headers: {
            Authorization: `Bearer ${accessToken}`,
            Provider: provider,
          },
        },
      ),
    )
  }

  updateUser(details: UserRegisterRequest): Promise<UserRegisterResponse> {
    return this.parse(this.client.patch<UserRegisterResponse>('/user', details))
  }

  unsubscribeUser() {
    this.parse(this.client.delete<UserRegisterResponse>('/user'))
  }
}

export const userApi = new UserApi()
export default userApi
