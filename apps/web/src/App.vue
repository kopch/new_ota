<template>
  <div id="app" class="min-h-screen bg-gray-50">
    <!-- Navigation -->
    <nav v-if="showNav" class="bg-white shadow-sm border-b border-gray-200">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
          <div class="flex items-center">
            <router-link to="/dashboard" class="flex-shrink-0 flex items-center">
              <h1 class="text-xl font-bold text-gray-900">Listing Auditor AI</h1>
            </router-link>
          </div>
          
          <div class="flex items-center space-x-4">
            <router-link to="/dashboard" class="text-gray-700 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium">
              Dashboard
            </router-link>
            <router-link to="/create-audit" class="btn-primary text-sm">
              New Audit
            </router-link>
            <NotificationBell />
            <router-link to="/settings" class="text-gray-700 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium">
              Settings
            </router-link>
            <button @click="signOut" class="text-gray-700 hover:text-gray-900 px-3 py-2 rounded-md text-sm font-medium">
              Sign Out
            </button>
          </div>
        </div>
      </div>
    </nav>

    <!-- Main Content -->
    <main>
      <router-view />
    </main>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import { supabase } from './lib/supabase'
import NotificationBell from './components/NotificationBell.vue'

const route = useRoute()

const showNav = computed(() => {
  return !['/', '/auth'].includes(route.path)
})

const signOut = async () => {
  await supabase.auth.signOut()
  window.location.href = '/'
}
</script>
