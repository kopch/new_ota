<template>
  <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- Header -->
    <div class="mb-8">
      <h1 class="text-3xl font-bold text-gray-900">Settings</h1>
      <p class="mt-2 text-gray-600">Manage your account and subscription</p>
    </div>

    <div class="space-y-8">
      <!-- Profile Settings -->
      <div class="card">
        <h2 class="text-xl font-semibold text-gray-900 mb-6">Profile Settings</h2>
        <form @submit.prevent="updateProfile" class="space-y-4">
          <div>
            <label for="email" class="block text-sm font-medium text-gray-700 mb-1">Email</label>
            <input
              id="email"
              v-model="email"
              type="email"
              disabled
              class="input-field bg-gray-50"
            />
            <p class="mt-1 text-sm text-gray-500">Email cannot be changed</p>
          </div>
          
          <div>
            <label for="name" class="block text-sm font-medium text-gray-700 mb-1">Display Name</label>
            <input
              id="name"
              v-model="displayName"
              type="text"
              class="input-field"
              placeholder="Enter your display name"
            />
          </div>
          
          <div class="flex justify-end">
            <button
              type="submit"
              :disabled="profileLoading"
              class="btn-primary disabled:opacity-50"
            >
              {{ profileLoading ? 'Saving...' : 'Save Changes' }}
            </button>
          </div>
        </form>
      </div>

      <!-- Subscription -->
      <div class="card">
        <h2 class="text-xl font-semibold text-gray-900 mb-6">Subscription</h2>
        
        <div v-if="subscriptionLoading" class="text-center py-4">
          <svg class="animate-spin h-6 w-6 text-blue-600 mx-auto" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
        </div>
        
        <div v-else class="space-y-6">
          <!-- Current Plan -->
          <div class="bg-gray-50 rounded-lg p-4">
            <div class="flex items-center justify-between">
              <div>
                <h3 class="text-lg font-medium text-gray-900">{{ getPlanName(user?.subscription_tier) }}</h3>
                <p class="text-sm text-gray-600">{{ getPlanDescription(user?.subscription_tier) }}</p>
              </div>
              <span :class="getStatusClass(user?.subscription_status)" class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium">
                {{ user?.subscription_status || 'No subscription' }}
              </span>
            </div>
          </div>

          <!-- Token Usage -->
          <div class="bg-blue-50 border border-blue-200 rounded-lg p-4">
            <h3 class="text-lg font-medium text-gray-900 mb-2">Token Usage</h3>
            <div class="flex items-center justify-between mb-2">
              <span class="text-sm text-gray-600">Tokens remaining this month</span>
              <span class="text-lg font-semibold text-gray-900">{{ user?.tokens_remaining || 0 }}</span>
            </div>
            <div class="w-full bg-blue-200 rounded-full h-2">
              <div 
                class="bg-blue-600 h-2 rounded-full transition-all duration-300" 
                :style="{ width: `${getTokenUsagePercentage()}%` }"
              ></div>
            </div>
            <p class="mt-2 text-sm text-gray-600">
              {{ getTokenLimit(user?.subscription_tier) }} tokens per month
            </p>
          </div>

          <!-- Plan Actions -->
          <div class="space-y-3">
            <button
              v-if="user?.subscription_tier === 'free'"
              @click="upgradeSubscription"
              class="w-full btn-primary"
            >
              Upgrade to Pro
            </button>
            
            <button
              v-if="user?.subscription_status === 'active'"
              @click="manageSubscription"
              class="w-full btn-secondary"
            >
              Manage Subscription
            </button>
            
            <button
              v-if="user?.subscription_status === 'active'"
              @click="cancelSubscription"
              class="w-full text-red-600 hover:text-red-700 text-sm font-medium"
            >
              Cancel Subscription
            </button>
          </div>
        </div>
      </div>

      <!-- Pricing Plans -->
      <div class="card">
        <h2 class="text-xl font-semibold text-gray-900 mb-6">Available Plans</h2>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div v-for="plan in plans" :key="plan.id" class="border border-gray-200 rounded-lg p-6">
            <div class="text-center">
              <h3 class="text-lg font-semibold text-gray-900">{{ plan.name }}</h3>
              <p class="text-3xl font-bold text-gray-900 mt-2">${{ plan.price }}</p>
              <p class="text-sm text-gray-600">per month</p>
            </div>
            
            <ul class="mt-6 space-y-3">
              <li v-for="feature in plan.features" :key="feature" class="flex items-center">
                <svg class="w-5 h-5 text-green-500 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                </svg>
                <span class="text-sm text-gray-700">{{ feature }}</span>
              </li>
            </ul>
            
            <button
              v-if="user?.subscription_tier !== plan.id"
              @click="upgradeToPlan(plan.id)"
              class="w-full mt-6 btn-primary"
            >
              {{ user?.subscription_tier === 'free' ? 'Upgrade' : 'Switch Plan' }}
            </button>
            
            <div v-else class="w-full mt-6 text-center text-sm text-gray-500">
              Current Plan
            </div>
          </div>
        </div>
      </div>

      <!-- Danger Zone -->
      <div class="card border-red-200">
        <h2 class="text-xl font-semibold text-red-900 mb-6">Danger Zone</h2>
        <div class="space-y-4">
          <div class="flex items-center justify-between p-4 bg-red-50 rounded-lg">
            <div>
              <h3 class="text-lg font-medium text-red-900">Delete Account</h3>
              <p class="text-sm text-red-700">Permanently delete your account and all data</p>
            </div>
            <button
              @click="deleteAccount"
              class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors"
            >
              Delete Account
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { supabase, type User } from '../lib/supabase'

const user = ref<User | null>(null)
const email = ref('')
const displayName = ref('')
const profileLoading = ref(false)
const subscriptionLoading = ref(false)

const plans = [
  {
    id: 'free',
    name: 'Free',
    price: '0',
    features: ['5 free tokens', 'Basic reports', 'Email support']
  },
  {
    id: 'basic',
    name: 'Basic',
    price: '19',
    features: ['10 tokens/month', 'Detailed reports', 'Priority support']
  },
  {
    id: 'pro',
    name: 'Pro',
    price: '49',
    features: ['30 tokens/month', 'Advanced analytics', 'Priority support', 'API access']
  },
  {
    id: 'business',
    name: 'Business',
    price: '99',
    features: ['100 tokens/month', 'Custom reports', 'Dedicated support', 'White-label options']
  }
]

const getPlanName = (tier: string | undefined) => {
  const plan = plans.find(p => p.id === tier)
  return plan?.name || 'Free'
}

const getPlanDescription = (tier: string | undefined) => {
  const descriptions: Record<string, string> = {
    free: 'Perfect for trying out the service',
    basic: 'Great for individual property owners',
    pro: 'Ideal for property managers',
    business: 'Best for large property portfolios'
  }
  return descriptions[tier || 'free'] || ''
}

const getStatusClass = (status: string | undefined) => {
  const classes: Record<string, string> = {
    active: 'bg-green-100 text-green-800',
    canceled: 'bg-red-100 text-red-800',
    past_due: 'bg-yellow-100 text-yellow-800'
  }
  return classes[status || ''] || 'bg-gray-100 text-gray-800'
}

const getTokenLimit = (tier: string | undefined) => {
  const limits: Record<string, number> = {
    free: 5,
    basic: 10,
    pro: 30,
    business: 100
  }
  return limits[tier || 'free']
}

const getTokenUsagePercentage = () => {
  const limit = getTokenLimit(user.value?.subscription_tier)
  const remaining = user.value?.tokens_remaining || 0
  return Math.max(0, Math.min(100, ((limit - remaining) / limit) * 100))
}

const loadUser = async () => {
  try {
    const { data: { user: authUser } } = await supabase.auth.getUser()
    if (!authUser) return

    const { data: userData } = await supabase
      .from('users')
      .select('*')
      .eq('id', authUser.id)
      .single()

    user.value = userData
    email.value = authUser.email || ''
    displayName.value = userData?.display_name || ''
  } catch (error) {
    console.error('Error loading user:', error)
  }
}

const updateProfile = async () => {
  profileLoading.value = true
  try {
    const { data: { user: authUser } } = await supabase.auth.getUser()
    if (!authUser) return

    const { error } = await supabase
      .from('users')
      .update({ display_name: displayName.value })
      .eq('id', authUser.id)

    if (error) throw error
    alert('Profile updated successfully!')
  } catch (error) {
    console.error('Error updating profile:', error)
    alert('Failed to update profile')
  } finally {
    profileLoading.value = false
  }
}

const upgradeSubscription = () => {
  // TODO: Implement Stripe checkout
  alert('Subscription upgrade coming soon!')
}

const upgradeToPlan = (planId: string) => {
  // TODO: Implement Stripe checkout for specific plan
  alert(`Upgrade to ${planId} plan coming soon!`)
}

const manageSubscription = () => {
  // TODO: Redirect to Stripe customer portal
  alert('Subscription management coming soon!')
}

const cancelSubscription = async () => {
  if (!confirm('Are you sure you want to cancel your subscription?')) return
  
  try {
    // TODO: Implement subscription cancellation
    alert('Subscription cancellation coming soon!')
  } catch (error) {
    console.error('Error canceling subscription:', error)
    alert('Failed to cancel subscription')
  }
}

const deleteAccount = async () => {
  if (!confirm('Are you sure you want to delete your account? This action cannot be undone.')) return
  
  try {
    const { data: { user: authUser } } = await supabase.auth.getUser()
    if (!authUser) return

    // Delete user data
    await supabase.from('users').delete().eq('id', authUser.id)
    
    // Delete auth user
    await supabase.auth.admin.deleteUser(authUser.id)
    
    alert('Account deleted successfully')
    window.location.href = '/'
  } catch (error) {
    console.error('Error deleting account:', error)
    alert('Failed to delete account')
  }
}

onMounted(() => {
  loadUser()
})
</script>
