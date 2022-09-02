import axios, { Axios, AxiosResponse } from 'axios'
import { ENV } from '../env'

const client = axios.create({
  baseURL: ENV.API_BASE + '/api/v1',
})

export class ApiCollection {
  client!: Axios

  constructor() {
    this.client = client
  }

  public setAuthHeaders(token: string) {
    this.client.defaults.headers.common['Authorization'] = `Bearer ${token}`
  }

  public unsetAuthHeaders() {
    delete this.client.defaults.headers.common['Authorization']
  }

  protected async parse<T, K extends keyof T>(
    // eslint-disable-next-line no-unused-vars
    result: Promise<AxiosResponse<T>>,
    // eslint-disable-next-line no-unused-vars
    key: K,
  ): Promise<T[K]>
  // eslint-disable-next-line no-unused-vars
  protected async parse<T, K extends keyof T>(result: Promise<AxiosResponse<T>>): Promise<T>
  protected async parse<T, K extends keyof T>(
    result: Promise<AxiosResponse<T>>,
    key?: K,
  ): Promise<T | T[K]> {
    const { data } = await result
    return key ? data[key] : data
  }
}
