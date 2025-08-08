# 🚀 Быстрый деплой на Render.com

## Шаг 1: Подготовка (2 минуты)

1. **Создайте репозиторий на GitHub:**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/your-username/listing-auditor-ai.git
   git push -u origin main
   ```

2. **Сгенерируйте ключи:**
   ```bash
   powershell -ExecutionPolicy Bypass -File .\scripts\setup-render.ps1
   ```

## Шаг 2: Создание сервисов на Render (10 минут)

### 1. Frontend (Vue.js)
- **New +** → **Web Service**
- Подключите GitHub репозиторий
- **Name:** `listing-auditor-frontend`
- **Build Command:** `cd apps/web && npm install && npm run build`
- **Start Command:** `cd apps/web && npm run preview`

### 2. Database (PostgreSQL)
- **New +** → **PostgreSQL**
- **Name:** `listing-auditor-db`
- **Database:** `listing_auditor`

### 3. n8n Workflow
- **New +** → **Web Service**
- Подключите тот же репозиторий
- **Name:** `listing-auditor-n8n`
- **Build Command:** `npm install -g n8n`
- **Start Command:** `n8n start`

### 4. Browserless
- **New +** → **Web Service**
- Подключите тот же репозиторий
- **Name:** `listing-auditor-browserless`
- **Environment:** `Docker`
- **Dockerfile Path:** `./browserless/Dockerfile`

## Шаг 3: Переменные окружения

### Frontend
```
NODE_ENV=production
PUBLIC_SITE_URL=https://listing-auditor-frontend.onrender.com
SUPABASE_PUBLIC_URL=https://listing-auditor-db.onrender.com
SUPABASE_ANON_KEY=your_anon_key_here
```

### n8n
```
N8N_HOST=listing-auditor-n8n.onrender.com
N8N_PROTOCOL=https
N8N_WEBHOOK_URL=https://listing-auditor-n8n.onrender.com
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=your_secure_password
SUPABASE_URL=https://listing-auditor-db.onrender.com
SUPABASE_ANON_KEY=your_anon_key_here
MANUS_API_KEY=your_manus_api_key
BROWSERLESS_URL=https://listing-auditor-browserless.onrender.com
```

### Database
```
POSTGRES_PASSWORD=your_password
POSTGRES_DB=listing_auditor
POSTGRES_USER=listing_auditor_user
JWT_SECRET=your_jwt_secret
ANON_KEY=your_anon_key
SERVICE_ROLE_KEY=your_service_role_key
```

### Browserless
```
MAX_CONCURRENT_SESSIONS=10
CONNECTION_TIMEOUT=300000
MAX_QUEUE_LENGTH=10
TOKEN=your_browserless_token
```

## Шаг 4: Получение ключей

### Supabase ключи
После создания базы данных в Render Dashboard:
1. Перейдите в PostgreSQL сервис
2. Скопируйте **Internal Database URL**
3. Используйте как `SUPABASE_URL`

### Manus AI
1. Зарегистрируйтесь на [manus.ai](https://manus.ai)
2. Получите API ключ
3. Добавьте в `MANUS_API_KEY`

## Шаг 5: Инициализация (5 минут)

1. **База данных:** SQL скрипт выполнится автоматически
2. **n8n:** Откройте `https://listing-auditor-n8n.onrender.com`
   - Логин: `admin`
   - Пароль: (из `N8N_BASIC_AUTH_PASSWORD`)
3. **Импортируйте workflow:** `n8n/workflows/listing-audit.json`

## Шаг 6: Проверка

- **Frontend:** `https://listing-auditor-frontend.onrender.com`
- **n8n:** `https://listing-auditor-n8n.onrender.com`
- **Database:** Внутренний URL в Render Dashboard

## 🎉 Готово!

Ваш SaaS-сервис запущен за **20 минут**!

## ❗ Важные моменты

- **Бесплатный план:** Сервисы "засыпают" после 15 минут неактивности
- **Платный план:** Рекомендуется для production
- **Логи:** Проверяйте в Render Dashboard при проблемах
- **Обновления:** `git push` автоматически перезапускает сервисы

## 🔗 Полезные ссылки

- [Render Dashboard](https://dashboard.render.com)
- [Manus AI](https://manus.ai)
- [Stripe](https://stripe.com)
- [Подробная инструкция](DEPLOYMENT.md)

