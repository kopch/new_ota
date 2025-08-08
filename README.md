# Listing Auditor AI

AI-powered SaaS service for automatic audit of vacation rental listings quality. Provides detailed reports with scores, visualizations, and actionable recommendations to help property owners increase bookings.

## 🚀 Features

- **Multi-Platform Support**: Analyze listings from Airbnb, VRBO, Booking.com, and Expedia
- **AI-Powered Analysis**: Comprehensive scoring across content, visuals, pricing, and marketing
- **Visual Reports**: Beautiful, shareable reports with screenshots and charts
- **Token-Based System**: Flexible usage with monthly token allocation
- **Real-time Processing**: Background processing with status updates
- **Export Options**: PDF and DOC export capabilities
- **Public Sharing**: Generate shareable links for reports

## 🏗️ Architecture

### Tech Stack
- **Frontend**: Vue.js 3 + Tailwind CSS + TypeScript
- **Backend**: n8n (self-hosted) for workflow automation
- **Database**: Supabase (self-hosted) with PostgreSQL
- **AI Service**: Manus for content analysis
- **Payments**: Stripe for subscription management
- **Deployment**: Docker Compose for easy setup

### System Components
1. **Vue.js Frontend**: User interface and dashboard
2. **Supabase**: Authentication, database, and real-time features
3. **n8n**: Workflow automation for scraping and analysis
4. **Browserless**: Headless browser for web scraping
5. **Stripe**: Payment processing and subscription management

## 📋 Prerequisites

- Docker and Docker Compose
- Node.js 18+ (for local development)
- Stripe account
- Manus AI API key (or similar AI service)

## 🛠️ Installation

### 1. Clone the Repository
```bash
git clone <repository-url>
cd listing-auditor-ai
```

### 2. Configure Environment Variables
```bash
cp env.example .env
```

Edit `.env` file with your configuration:
- Generate Supabase keys
- Add Stripe API keys
- Configure Manus AI API key
- Set up Google OAuth (optional)

### 3. Generate Supabase Keys
```bash
# Generate JWT secret
openssl rand -base64 32

# Generate anon and service role keys
openssl rand -base64 32
openssl rand -base64 32
```

### 4. Start the Application
```bash
docker-compose up -d
```

The application will be available at:
- **Frontend**: http://localhost:8080
- **n8n**: http://localhost:5678
- **Supabase**: http://localhost:8000

### 5. Initial Setup

1. **Access n8n**: Go to http://localhost:5678
   - Create admin account
   - Import the workflow from `n8n/workflows/listing-audit.json`
   - Configure database credentials

2. **Configure Supabase**:
   - Database schema is automatically created
   - RLS policies are enabled
   - Auth is configured

3. **Set up Stripe** (optional for development):
   - Create webhook endpoint
   - Configure subscription products

## 🎯 Usage

### Creating Your First Audit

1. **Sign Up**: Create an account with email or Google
2. **Add Listing URLs**: Enter URLs from supported platforms
3. **Start Analysis**: System processes listings in background
4. **View Report**: Get detailed analysis with scores and recommendations

### Understanding Scores

- **Overall Score**: Weighted average of all metrics (0-100)
- **Content Score**: Title, description, and review quality
- **Visual Score**: Photo quality, quantity, and presentation
- **Pricing Score**: Competitive pricing and availability
- **Marketing Score**: Trust indicators and promotional elements

### Subscription Plans

- **Free**: 5 tokens (one-time)
- **Basic**: $19/month - 10 tokens
- **Pro**: $49/month - 30 tokens
- **Business**: $99/month - 100 tokens

## 🔧 Development

### Local Development Setup

```bash
# Install frontend dependencies
cd apps/web
npm install

# Start development server
npm run dev

# Build for production
npm run build
```

### Project Structure
```
├── apps/
│   └── web/                 # Vue.js frontend
│       ├── src/
│       │   ├── pages/       # Page components
│       │   ├── lib/         # Utilities and config
│       │   └── components/  # Reusable components
├── n8n/
│   └── workflows/           # n8n workflow definitions
├── supabase/
│   ├── init/               # Database initialization
│   └── kong.yml           # API gateway config
├── docker-compose.yml      # Container orchestration
└── README.md
```

### API Endpoints

- `POST /listing-audit`: Trigger audit workflow
- `GET /rest/v1/projects`: Get user projects
- `GET /rest/v1/audit_reports`: Get audit reports
- `POST /auth/v1/signup`: User registration

## 🔒 Security

- Row Level Security (RLS) enabled on all tables
- JWT-based authentication
- API key authentication for services
- CORS configured for frontend
- Environment variables for sensitive data

## 🚀 Deployment

### Production Deployment

1. **Update Environment Variables**:
   - Set production URLs
   - Configure SSL certificates
   - Update API keys

2. **Deploy with Docker**:
   ```bash
   docker-compose -f docker-compose.prod.yml up -d
   ```

3. **Set up Reverse Proxy** (recommended):
   - Nginx or Traefik
   - SSL termination
   - Load balancing

### Environment Variables for Production

```bash
PUBLIC_SITE_URL=https://yourdomain.com
SUPABASE_PUBLIC_URL=https://yourdomain.com:8000
N8N_WEBHOOK_URL=https://yourdomain.com:5678
```

## 📊 Monitoring

### Health Checks
- Database connectivity
- n8n workflow status
- API response times
- Token usage metrics

### Logs
```bash
# View all logs
docker-compose logs -f

# View specific service
docker-compose logs -f web
docker-compose logs -f n8n
```

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Make changes
4. Add tests
5. Submit pull request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

- **Documentation**: Check this README
- **Issues**: Create GitHub issue
- **Email**: support@listingauditor.ai

## 🔄 Updates

### Version History
- **v1.0.0**: Initial release with core features
- **v1.1.0**: Added PDF export and sharing
- **v1.2.0**: Enhanced AI analysis and scoring

### Upcoming Features
- Mobile app
- Advanced analytics dashboard
- Competitor analysis
- Automated recommendations
- White-label solutions

---

**Built with ❤️ for vacation rental owners**
