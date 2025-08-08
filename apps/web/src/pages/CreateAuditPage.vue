<template>
  <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- Header -->
    <div class="mb-8">
      <h1 class="text-3xl font-bold text-gray-900">Create New Audit</h1>
      <p class="mt-2 text-gray-600">Analyze your vacation rental listings with AI-powered insights</p>
    </div>

    <!-- Progress Steps -->
    <div class="mb-8">
      <div class="flex items-center justify-center">
        <div class="flex items-center">
          <div :class="currentStep >= 1 ? 'bg-blue-600' : 'bg-gray-300'" class="w-8 h-8 rounded-full flex items-center justify-center">
            <span class="text-white text-sm font-medium">1</span>
          </div>
          <div :class="currentStep >= 1 ? 'bg-blue-600' : 'bg-gray-300'" class="w-16 h-1 mx-2"></div>
        </div>
        <div class="flex items-center">
          <div :class="currentStep >= 2 ? 'bg-blue-600' : 'bg-gray-300'" class="w-8 h-8 rounded-full flex items-center justify-center">
            <span class="text-white text-sm font-medium">2</span>
          </div>
          <div :class="currentStep >= 2 ? 'bg-blue-600' : 'bg-gray-300'" class="w-16 h-1 mx-2"></div>
        </div>
        <div class="flex items-center">
          <div :class="currentStep >= 3 ? 'bg-blue-600' : 'bg-gray-300'" class="w-8 h-8 rounded-full flex items-center justify-center">
            <span class="text-white text-sm font-medium">3</span>
          </div>
        </div>
      </div>
      <div class="flex justify-center mt-2 text-sm text-gray-600">
        <span class="mr-8">Choose Platform</span>
        <span class="mr-8">Add URLs</span>
        <span>Review & Start</span>
      </div>
    </div>

    <!-- Step 1: Platform Selection -->
    <div v-if="currentStep === 1" class="card">
      <h2 class="text-xl font-semibold text-gray-900 mb-6">Choose Platform</h2>
      <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
        <button
          v-for="platform in platforms"
          :key="platform.id"
          @click="selectPlatform(platform.id)"
          :class="selectedPlatform === platform.id ? 'ring-2 ring-blue-500 bg-blue-50' : 'hover:bg-gray-50'"
          class="p-4 border border-gray-200 rounded-lg text-center transition-colors"
        >
          <div class="w-12 h-12 mx-auto mb-3 bg-gray-100 rounded-lg flex items-center justify-center">
            <span class="text-2xl">{{ platform.icon }}</span>
          </div>
          <h3 class="font-medium text-gray-900">{{ platform.name }}</h3>
          <p class="text-sm text-gray-500 mt-1">{{ platform.description }}</p>
        </button>
      </div>
      
      <div class="mt-6 flex justify-end">
        <button
          @click="nextStep"
          :disabled="!selectedPlatform"
          class="btn-primary disabled:opacity-50 disabled:cursor-not-allowed"
        >
          Next
        </button>
      </div>
    </div>

    <!-- Step 2: URL Input -->
    <div v-if="currentStep === 2" class="card">
      <h2 class="text-xl font-semibold text-gray-900 mb-6">Add Listing URLs</h2>
      <p class="text-gray-600 mb-4">Enter the URLs of the listings you want to analyze. You can add multiple URLs.</p>
      
      <div class="space-y-4">
        <div v-for="(url, index) in urls" :key="index" class="flex items-center space-x-2">
          <input
            v-model="urls[index]"
            type="url"
            :placeholder="`${getPlatformUrl(selectedPlatform)}`"
            class="input-field flex-1"
          />
          <button
            v-if="urls.length > 1"
            @click="removeUrl(index)"
            class="p-2 text-red-600 hover:text-red-700"
          >
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
            </svg>
          </button>
        </div>
      </div>
      
      <button
        @click="addUrl"
        class="mt-4 text-blue-600 hover:text-blue-700 text-sm font-medium"
      >
        + Add another URL
      </button>
      
      <div class="mt-6 flex justify-between">
        <button @click="prevStep" class="btn-secondary">
          Back
        </button>
        <button
          @click="nextStep"
          :disabled="!isValidUrls"
          class="btn-primary disabled:opacity-50 disabled:cursor-not-allowed"
        >
          Next
        </button>
      </div>
    </div>

    <!-- Step 3: Review & Start -->
    <div v-if="currentStep === 3" class="card">
      <h2 class="text-xl font-semibold text-gray-900 mb-6">Review & Start Audit</h2>
      
      <div class="space-y-6">
        <div>
          <h3 class="text-lg font-medium text-gray-900 mb-2">Project Summary</h3>
          <div class="bg-gray-50 rounded-lg p-4">
            <div class="flex items-center mb-2">
              <span class="text-2xl mr-3">{{ getPlatformIcon(selectedPlatform) }}</span>
              <span class="font-medium">{{ getPlatformName(selectedPlatform) }}</span>
            </div>
            <p class="text-gray-600">{{ urls.length }} listing{{ urls.length !== 1 ? 's' : '' }} to analyze</p>
          </div>
        </div>
        
        <div>
          <h3 class="text-lg font-medium text-gray-900 mb-2">URLs to Analyze</h3>
          <div class="space-y-2">
            <div v-for="(url, index) in urls" :key="index" class="flex items-center space-x-2 p-2 bg-gray-50 rounded">
              <span class="text-gray-500 text-sm">{{ index + 1 }}.</span>
              <span class="text-sm text-gray-700 truncate">{{ url }}</span>
            </div>
          </div>
        </div>
        
        <div>
          <h3 class="text-lg font-medium text-gray-900 mb-2">Token Usage</h3>
          <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-4">
            <div class="flex items-center justify-between">
              <span class="text-yellow-800">Tokens required: {{ urls.length }}</span>
              <span class="text-yellow-800">Available: {{ user?.tokens_remaining || 0 }}</span>
            </div>
            <div v-if="urls.length > (user?.tokens_remaining || 0)" class="mt-2 text-red-600 text-sm">
              You don't have enough tokens. Please upgrade your subscription.
            </div>
          </div>
        </div>
      </div>
      
      <div class="mt-6 flex justify-between">
        <button @click="prevStep" class="btn-secondary">
          Back
        </button>
        <button
          @click="startAudit"
          :disabled="loading || urls.length > (user?.tokens_remaining || 0)"
          class="btn-primary disabled:opacity-50 disabled:cursor-not-allowed"
        >
          <span v-if="loading" class="flex items-center">
            <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
            Creating...
          </span>
          <span v-else>Start Audit</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { supabase, type User } from '../lib/supabase'

const router = useRouter()
const currentStep = ref(1)
const selectedPlatform = ref('')
const urls = ref([''])
const loading = ref(false)
const user = ref<User | null>(null)

const platforms = [
  { id: 'airbnb', name: 'Airbnb', icon: '🏠', description: 'Vacation rentals' },
  { id: 'vrbo', name: 'VRBO', icon: '🏖️', description: 'Vacation homes' },
  { id: 'booking', name: 'Booking.com', icon: '🏨', description: 'Hotels & rentals' },
  { id: 'expedia', name: 'Expedia', icon: '✈️', description: 'Travel bookings' }
]

const isValidUrls = computed(() => {
  return urls.value.every(url => url.trim() !== '')
})

const getPlatformIcon = (platformId: string) => {
  const platform = platforms.find(p => p.id === platformId)
  return platform?.icon || '?'
}

const getPlatformName = (platformId: string) => {
  const platform = platforms.find(p => p.id === platformId)
  return platform?.name || 'Unknown'
}

const getPlatformUrl = (platformId: string) => {
  const urls: Record<string, string> = {
    airbnb: 'https://airbnb.com/rooms/...',
    vrbo: 'https://vrbo.com/...',
    booking: 'https://booking.com/...',
    expedia: 'https://expedia.com/...'
  }
  return urls[platformId] || 'https://example.com/...'
}

const selectPlatform = (platformId: string) => {
  selectedPlatform.value = platformId
}

const addUrl = () => {
  urls.value.push('')
}

const removeUrl = (index: number) => {
  urls.value.splice(index, 1)
}

const nextStep = () => {
  if (currentStep.value < 3) {
    currentStep.value++
  }
}

const prevStep = () => {
  if (currentStep.value > 1) {
    currentStep.value--
  }
}

const startAudit = async () => {
  loading.value = true
  
  try {
    // Get current user
    const { data: { user: authUser } } = await supabase.auth.getUser()
    if (!authUser) throw new Error('User not authenticated')

    // Create project
    const { data: project, error: projectError } = await supabase
      .from('projects')
      .insert({
        user_id: authUser.id,
        name: `${getPlatformName(selectedPlatform.value)} Audit`,
        platform: selectedPlatform.value,
        status: 'processing'
      })
      .select()
      .single()

    if (projectError) throw projectError

    // Create listings
    const listings = urls.value.map(url => ({
      project_id: project.id,
      url: url.trim()
    }))

    const { error: listingsError } = await supabase
      .from('listings')
      .insert(listings)

    if (listingsError) throw listingsError

    // Deduct tokens
    const tokensNeeded = urls.value.length
    const { error: tokenError } = await supabase
      .from('users')
      .update({ tokens_remaining: (user.value?.tokens_remaining || 0) - tokensNeeded })
      .eq('id', authUser.id)

    if (tokenError) throw tokenError

    // Trigger n8n workflow (webhook)
    const n8nWebhookUrl = `${import.meta.env.VITE_N8N_WEBHOOK_URL}/listing-audit`
    await fetch(n8nWebhookUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ project_id: project.id })
    })

    // Redirect to dashboard
    router.push('/dashboard')
  } catch (error) {
    console.error('Error creating audit:', error)
    alert('Failed to create audit. Please try again.')
  } finally {
    loading.value = false
  }
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
  } catch (error) {
    console.error('Error loading user:', error)
  }
}

onMounted(() => {
  loadUser()
})
</script>
