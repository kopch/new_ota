#!/bin/bash

# Скрипт для настройки переменных окружения на Render.com
# Использование: ./scripts/setup-render.sh

set -e

echo "🚀 Настройка переменных окружения для Render.com"
echo "=================================================="

# Генерируем ключи если их нет
if [ ! -f .env.keys ]; then
    echo "📝 Генерация ключей..."
    ./scripts/generate-keys.sh > .env.keys
fi

# Загружаем ключи
source .env.keys

echo ""
echo "🔑 Сгенерированные ключи:"
echo "JWT_SECRET: $JWT_SECRET"
echo "ANON_KEY: $ANON_KEY"
echo "SERVICE_ROLE_KEY: $SERVICE_ROLE_KEY"
echo "DB_PASSWORD: $DB_PASSWORD"
echo ""

echo "📋 Инструкция по настройке Render.com:"
echo "======================================"

echo ""
echo "1️⃣ Создайте сервисы на Render.com:"
echo "   - Frontend: Web Service (Node.js)"
echo "   - Database: PostgreSQL"
echo "   - n8n: Web Service (Node.js)"
echo "   - Browserless: Web Service (Docker)"
echo ""

echo "2️⃣ Настройте переменные окружения для Frontend:"
echo "   NODE_ENV=production"
echo "   PUBLIC_SITE_URL=https://listing-auditor-frontend.onrender.com"
echo "   SUPABASE_PUBLIC_URL=https://listing-auditor-db.onrender.com"
echo "   SUPABASE_ANON_KEY=$ANON_KEY"
echo ""

echo "3️⃣ Настройте переменные окружения для n8n:"
echo "   N8N_HOST=listing-auditor-n8n.onrender.com"
echo "   N8N_PROTOCOL=https"
echo "   N8N_WEBHOOK_URL=https://listing-auditor-n8n.onrender.com"
echo "   N8N_BASIC_AUTH_ACTIVE=true"
echo "   N8N_BASIC_AUTH_USER=admin"
echo "   N8N_BASIC_AUTH_PASSWORD=your_secure_password"
echo "   SUPABASE_URL=https://listing-auditor-db.onrender.com"
echo "   SUPABASE_ANON_KEY=$ANON_KEY"
echo "   MANUS_API_KEY=your_manus_api_key"
echo "   BROWSERLESS_URL=https://listing-auditor-browserless.onrender.com"
echo ""

echo "4️⃣ Настройте переменные окружения для Database:"
echo "   POSTGRES_PASSWORD=$DB_PASSWORD"
echo "   POSTGRES_DB=listing_auditor"
echo "   POSTGRES_USER=listing_auditor_user"
echo "   JWT_SECRET=$JWT_SECRET"
echo "   ANON_KEY=$ANON_KEY"
echo "   SERVICE_ROLE_KEY=$SERVICE_ROLE_KEY"
echo ""

echo "5️⃣ Настройте переменные окружения для Browserless:"
echo "   MAX_CONCURRENT_SESSIONS=10"
echo "   CONNECTION_TIMEOUT=300000"
echo "   MAX_QUEUE_LENGTH=10"
echo "   TOKEN=your_browserless_token"
echo ""

echo "🔗 Полезные ссылки:"
echo "   - Render Dashboard: https://dashboard.render.com"
echo "   - Manus AI: https://manus.ai"
echo "   - Stripe: https://stripe.com"
echo ""

echo "📝 Следующие шаги:"
echo "   1. Создайте аккаунт на Manus AI и получите API ключ"
echo "   2. Добавьте MANUS_API_KEY в переменные n8n"
echo "   3. Настройте Stripe (опционально)"
echo "   4. Импортируйте workflow в n8n"
echo ""

echo "✅ Настройка завершена!"
echo "   Теперь следуйте инструкции в DEPLOYMENT.md"
