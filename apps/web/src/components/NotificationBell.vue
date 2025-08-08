<template>
  <div class="relative">
    <button
      @click="toggleNotifications"
      class="relative p-2 text-gray-700 hover:text-gray-900 focus:outline-none focus:ring-2 focus:ring-blue-500 rounded-md"
    >
      <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-5 5v-5zM10.5 3.75a6 6 0 00-6 6v3.75l-2.25 2.25v1.5h15v-1.5L15.75 13.5V9.75a6 6 0 00-6-6z" />
      </svg>
      
      <!-- Notification badge -->
      <span
        v-if="unreadCount > 0"
        class="absolute -top-1 -right-1 bg-red-500 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center"
      >
        {{ unreadCount > 9 ? '9+' : unreadCount }}
      </span>
    </button>

    <!-- Notification dropdown -->
    <div
      v-if="showNotifications"
      class="absolute right-0 mt-2 w-80 bg-white rounded-lg shadow-lg border border-gray-200 z-50"
    >
      <div class="p-4 border-b border-gray-200">
        <h3 class="text-lg font-semibold text-gray-900">Notifications</h3>
      </div>
      
      <div class="max-h-96 overflow-y-auto">
        <div v-if="notifications.length === 0" class="p-4 text-center text-gray-500">
          No notifications
        </div>
        
        <div
          v-for="notification in notifications"
          :key="notification.id"
          class="p-4 border-b border-gray-100 hover:bg-gray-50 cursor-pointer"
          @click="handleNotificationClick(notification)"
        >
          <div class="flex items-start space-x-3">
            <div class="flex-shrink-0">
              <div
                :class="getNotificationIcon(notification.type).class"
                class="w-8 h-8 rounded-full flex items-center justify-center"
              >
                <svg class="w-4 h-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="getNotificationIcon(notification.type).path" />
                </svg>
              </div>
            </div>
            
            <div class="flex-1 min-w-0">
              <p class="text-sm font-medium text-gray-900">
                {{ notification.title }}
              </p>
              <p class="text-sm text-gray-500 mt-1">
                {{ notification.message }}
              </p>
              <p class="text-xs text-gray-400 mt-2">
                {{ formatTime(notification.created_at) }}
              </p>
            </div>
            
            <div v-if="!notification.read" class="flex-shrink-0">
              <div class="w-2 h-2 bg-blue-500 rounded-full"></div>
            </div>
          </div>
        </div>
      </div>
      
      <div class="p-4 border-t border-gray-200">
        <button
          @click="markAllAsRead"
          class="text-sm text-blue-600 hover:text-blue-700 font-medium"
        >
          Mark all as read
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '../lib/supabase'

const router = useRouter()
const showNotifications = ref(false)
const notifications = ref<any[]>([])
const unreadCount = ref(0)

const getNotificationIcon = (type: string) => {
  const icons: Record<string, { class: string; path: string }> = {
    audit_completed: {
      class: 'bg-green-500',
      path: 'M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z'
    },
    audit_failed: {
      class: 'bg-red-500',
      path: 'M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z'
    },
    token_low: {
      class: 'bg-yellow-500',
      path: 'M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1'
    },
    subscription: {
      class: 'bg-blue-500',
      path: 'M13 10V3L4 14h7v7l9-11h-7z'
    }
  }
  return icons[type] || icons.audit_completed
}

const formatTime = (timestamp: string) => {
  const date = new Date(timestamp)
  const now = new Date()
  const diff = now.getTime() - date.getTime()
  
  const minutes = Math.floor(diff / 60000)
  const hours = Math.floor(diff / 3600000)
  const days = Math.floor(diff / 86400000)
  
  if (minutes < 1) return 'Just now'
  if (minutes < 60) return `${minutes}m ago`
  if (hours < 24) return `${hours}h ago`
  if (days < 7) return `${days}d ago`
  
  return date.toLocaleDateString()
}

const loadNotifications = async () => {
  try {
    const { data: { user } } = await supabase.auth.getUser()
    if (!user) return

    const { data } = await supabase
      .from('notifications')
      .select('*')
      .eq('user_id', user.id)
      .order('created_at', { ascending: false })
      .limit(10)

    notifications.value = data || []
    unreadCount.value = notifications.value.filter(n => !n.read).length
  } catch (error) {
    console.error('Error loading notifications:', error)
  }
}

const markAllAsRead = async () => {
  try {
    const { data: { user } } = await supabase.auth.getUser()
    if (!user) return

    await supabase
      .from('notifications')
      .update({ read: true })
      .eq('user_id', user.id)
      .eq('read', false)

    await loadNotifications()
  } catch (error) {
    console.error('Error marking notifications as read:', error)
  }
}

const handleNotificationClick = (notification: any) => {
  // Mark as read
  if (!notification.read) {
    supabase
      .from('notifications')
      .update({ read: true })
      .eq('id', notification.id)
  }

  // Navigate based on notification type
  if (notification.type === 'audit_completed' && notification.project_id) {
    router.push(`/report/${notification.project_id}`)
  }

  showNotifications.value = false
}

const toggleNotifications = () => {
  showNotifications.value = !showNotifications.value
}

// Close dropdown when clicking outside
const handleClickOutside = (event: Event) => {
  const target = event.target as Element
  if (!target.closest('.notification-bell')) {
    showNotifications.value = false
  }
}

// Listen for real-time updates
const setupRealtime = () => {
  const channel = supabase
    .channel('notifications')
    .on('postgres_changes', {
      event: 'INSERT',
      schema: 'public',
      table: 'notifications'
    }, (payload) => {
      // Add new notification to the top
      notifications.value.unshift(payload.new as any)
      unreadCount.value++
    })
    .subscribe()

  return () => {
    supabase.removeChannel(channel)
  }
}

onMounted(() => {
  loadNotifications()
  const cleanup = setupRealtime()
  
  document.addEventListener('click', handleClickOutside)
  
  onUnmounted(() => {
    cleanup()
    document.removeEventListener('click', handleClickOutside)
  })
})
</script>
