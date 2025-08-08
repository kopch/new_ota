import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('Missing Supabase environment variables')
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey)

// Database types
export interface User {
  id: string
  email: string
  created_at: string
  tokens_remaining: number
  subscription_tier: 'free' | 'basic' | 'pro' | 'business'
  subscription_status: 'active' | 'canceled' | 'past_due'
}

export interface Project {
  id: string
  user_id: string
  name: string
  platform: 'airbnb' | 'vrbo' | 'booking' | 'expedia'
  status: 'processing' | 'completed' | 'failed'
  created_at: string
  updated_at: string
}

export interface Listing {
  id: string
  project_id: string
  url: string
  title: string
  description: string
  price: number
  rating: number
  review_count: number
  image_urls: string[]
  amenities: string[]
  created_at: string
}

export interface AuditReport {
  id: string
  listing_id: string
  overall_score: number
  content_score: number
  visual_score: number
  pricing_score: number
  marketing_score: number
  strengths: string[]
  weaknesses: string[]
  recommendations: string[]
  screenshots: string[]
  created_at: string
}
