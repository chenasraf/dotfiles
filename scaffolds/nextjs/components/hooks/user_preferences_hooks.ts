import userPreferencesApi from '../../core/api/user_preferences.api'
import { createUseApi } from '../../core/utils/react_utils'

export const useUserPreferences = createUseApi(() => userPreferencesApi.getUserPreferences(), {
  cacheKey: 'userPreferences',
  responseKey: 'userPreference',
})
