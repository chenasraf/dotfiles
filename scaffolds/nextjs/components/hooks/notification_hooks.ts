import notificationsApi from '../../core/api/notifications.api'
import { Notification } from '../../core/models/notification'
import { createUseApi } from '../../core/utils/react_utils'

const getId = (notification: Notification) => notification.userId

export const useNotifications = createUseApi(() => notificationsApi.getNotifications(), {
  cacheKey: 'notifications',
  responseKey: 'notifications',
})
