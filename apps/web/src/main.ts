import { createApp } from 'vue'
import { createRouter, createWebHistory } from 'vue-router'
import App from './App.vue'
import './style.css'

// Import pages
import HomePage from './pages/HomePage.vue'
import DashboardPage from './pages/DashboardPage.vue'
import AuthPage from './pages/AuthPage.vue'
import CreateAuditPage from './pages/CreateAuditPage.vue'
import ReportPage from './pages/ReportPage.vue'
import SettingsPage from './pages/SettingsPage.vue'

// Create router
const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/', component: HomePage },
    { path: '/auth', component: AuthPage },
    { path: '/dashboard', component: DashboardPage },
    { path: '/create-audit', component: CreateAuditPage },
    { path: '/report/:id', component: ReportPage },
    { path: '/settings', component: SettingsPage }
  ]
})

// Create and mount app
const app = createApp(App)
app.use(router)
app.mount('#app')
