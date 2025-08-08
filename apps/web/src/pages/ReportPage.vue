<template>
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- Header -->
    <div class="mb-8">
      <div class="flex items-center justify-between">
        <div>
          <h1 class="text-3xl font-bold text-gray-900">Audit Report</h1>
          <p class="mt-2 text-gray-600">{{ project?.name || 'Loading...' }}</p>
        </div>
        <div class="flex space-x-3">
          <button @click="exportPDF" class="btn-secondary">
            <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
            </svg>
            Export PDF
          </button>
          <button @click="shareReport" class="btn-primary">
            <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.367 2.684 3 3 0 00-5.367-2.684z" />
            </svg>
            Share
          </button>
        </div>
      </div>
    </div>

    <div v-if="loading" class="text-center py-12">
      <svg class="animate-spin h-12 w-12 text-blue-600 mx-auto" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
      </svg>
      <p class="mt-4 text-gray-500">Loading report...</p>
    </div>

    <div v-else-if="!project" class="text-center py-12">
      <p class="text-gray-500">Report not found</p>
    </div>

    <div v-else class="space-y-8">
      <!-- Overall Score -->
      <div class="card">
        <h2 class="text-2xl font-bold text-gray-900 mb-6">Overall Score</h2>
        <div class="flex items-center justify-center">
          <div class="text-center">
            <div class="relative w-32 h-32">
              <svg class="w-32 h-32 transform -rotate-90" viewBox="0 0 120 120">
                <circle cx="60" cy="60" r="54" fill="none" stroke="#e5e7eb" stroke-width="12"/>
                <circle 
                  cx="60" 
                  cy="60" 
                  r="54" 
                  fill="none" 
                  stroke="#3b82f6" 
                  stroke-width="12"
                  stroke-dasharray="339.292"
                  :stroke-dashoffset="339.292 - (339.292 * (overallScore || 0)) / 100"
                  stroke-linecap="round"
                />
              </svg>
              <div class="absolute inset-0 flex items-center justify-center">
                <span class="text-3xl font-bold text-gray-900">{{ overallScore || 0 }}</span>
              </div>
            </div>
            <p class="mt-4 text-lg font-medium text-gray-700">Out of 100</p>
          </div>
        </div>
      </div>

      <!-- Detailed Scores -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div class="card">
          <h3 class="text-lg font-semibold text-gray-900 mb-4">Content Score</h3>
          <div class="space-y-3">
            <div class="flex justify-between">
              <span class="text-gray-600">Title & Description</span>
              <span class="font-medium">{{ contentScore || 0 }}/100</span>
            </div>
            <div class="w-full bg-gray-200 rounded-full h-2">
              <div class="bg-blue-600 h-2 rounded-full" :style="{ width: `${contentScore || 0}%` }"></div>
            </div>
          </div>
        </div>

        <div class="card">
          <h3 class="text-lg font-semibold text-gray-900 mb-4">Visual Score</h3>
          <div class="space-y-3">
            <div class="flex justify-between">
              <span class="text-gray-600">Photos & Media</span>
              <span class="font-medium">{{ visualScore || 0 }}/100</span>
            </div>
            <div class="w-full bg-gray-200 rounded-full h-2">
              <div class="bg-green-600 h-2 rounded-full" :style="{ width: `${visualScore || 0}%` }"></div>
            </div>
          </div>
        </div>

        <div class="card">
          <h3 class="text-lg font-semibold text-gray-900 mb-4">Pricing Score</h3>
          <div class="space-y-3">
            <div class="flex justify-between">
              <span class="text-gray-600">Price & Availability</span>
              <span class="font-medium">{{ pricingScore || 0 }}/100</span>
            </div>
            <div class="w-full bg-gray-200 rounded-full h-2">
              <div class="bg-yellow-600 h-2 rounded-full" :style="{ width: `${pricingScore || 0}%` }"></div>
            </div>
          </div>
        </div>

        <div class="card">
          <h3 class="text-lg font-semibold text-gray-900 mb-4">Marketing Score</h3>
          <div class="space-y-3">
            <div class="flex justify-between">
              <span class="text-gray-600">Trust & Promotions</span>
              <span class="font-medium">{{ marketingScore || 0 }}/100</span>
            </div>
            <div class="w-full bg-gray-200 rounded-full h-2">
              <div class="bg-purple-600 h-2 rounded-full" :style="{ width: `${marketingScore || 0}%` }"></div>
            </div>
          </div>
        </div>
      </div>

      <!-- Strengths & Weaknesses -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div class="card">
          <h3 class="text-lg font-semibold text-gray-900 mb-4 flex items-center">
            <svg class="w-5 h-5 text-green-600 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            Strengths
          </h3>
          <ul class="space-y-2">
            <li v-for="strength in strengths" :key="strength" class="flex items-start">
              <span class="text-green-600 mr-2">•</span>
              <span class="text-gray-700">{{ strength }}</span>
            </li>
          </ul>
        </div>

        <div class="card">
          <h3 class="text-lg font-semibold text-gray-900 mb-4 flex items-center">
            <svg class="w-5 h-5 text-red-600 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            Areas for Improvement
          </h3>
          <ul class="space-y-2">
            <li v-for="weakness in weaknesses" :key="weakness" class="flex items-start">
              <span class="text-red-600 mr-2">•</span>
              <span class="text-gray-700">{{ weakness }}</span>
            </li>
          </ul>
        </div>
      </div>

      <!-- Recommendations -->
      <div class="card">
        <h3 class="text-lg font-semibold text-gray-900 mb-4">Actionable Recommendations</h3>
        <div class="space-y-4">
          <div v-for="(recommendation, index) in recommendations" :key="index" class="flex items-start space-x-3 p-4 bg-blue-50 rounded-lg">
            <div class="flex-shrink-0 w-6 h-6 bg-blue-600 text-white rounded-full flex items-center justify-center text-sm font-medium">
              {{ index + 1 }}
            </div>
            <p class="text-gray-700">{{ recommendation }}</p>
          </div>
        </div>
      </div>

      <!-- Screenshots -->
      <div v-if="screenshots.length > 0" class="card">
        <h3 class="text-lg font-semibold text-gray-900 mb-4">Key Screenshots</h3>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          <div v-for="screenshot in screenshots" :key="screenshot" class="aspect-video bg-gray-100 rounded-lg overflow-hidden">
            <img :src="screenshot" alt="Listing screenshot" class="w-full h-full object-cover" />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { supabase, type Project, type AuditReport } from '../lib/supabase'

const route = useRoute()
const loading = ref(true)
const project = ref<Project | null>(null)
const report = ref<AuditReport | null>(null)

const overallScore = computed(() => report.value?.overall_score)
const contentScore = computed(() => report.value?.content_score)
const visualScore = computed(() => report.value?.visual_score)
const pricingScore = computed(() => report.value?.pricing_score)
const marketingScore = computed(() => report.value?.marketing_score)
const strengths = computed(() => report.value?.strengths || [])
const weaknesses = computed(() => report.value?.weaknesses || [])
const recommendations = computed(() => report.value?.recommendations || [])
const screenshots = computed(() => report.value?.screenshots || [])

const loadReport = async () => {
  try {
    const projectId = route.params.id as string
    
    // Load project
    const { data: projectData } = await supabase
      .from('projects')
      .select('*')
      .eq('id', projectId)
      .single()
    
    project.value = projectData

    // Load listings and their reports
    const { data: listings } = await supabase
      .from('listings')
      .select(`
        *,
        audit_reports (*)
      `)
      .eq('project_id', projectId)

    if (listings && listings.length > 0 && listings[0].audit_reports) {
      report.value = listings[0].audit_reports[0]
    }
  } catch (error) {
    console.error('Error loading report:', error)
  } finally {
    loading.value = false
  }
}

const exportPDF = () => {
  // TODO: Implement PDF export
  alert('PDF export coming soon!')
}

const shareReport = async () => {
  try {
    const shareUrl = `${window.location.origin}/shared-report/${route.params.id}`
    await navigator.clipboard.writeText(shareUrl)
    alert('Share link copied to clipboard!')
  } catch (error) {
    console.error('Error copying to clipboard:', error)
  }
}

onMounted(() => {
  loadReport()
})
</script>
