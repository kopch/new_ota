# 🚀 Быстрый старт на Render.com

## 1. Подготовка (5 минут)

```bash
# 1. Создайте репозиторий на GitHub
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/your-username/listing-auditor-ai.git
git push -u origin main

# 2. Сгенерируйте ключи
chmod +x scripts/generate-keys.sh
./scripts/generate-keys.sh
```

## 2. Создание сервисов на Render (10 минут)

### Frontend
1. **New +** → **Web Service**
2. Подключите GitHub репозиторий
3. Настройки:
   - **Name:** `listing-auditor-frontend`
   - **Build Command:** `cd apps/web && npm install && npm run build`
   - **Start Command:** `cd apps/web && npm run preview`

### Database
1. **New +** → **PostgreSQL**
2. Настройки:
   - **Name:** `listing-auditor-db`
   - **Database:** `listing_auditor`

### n8n
1. **New +** → **Web Service**
2. Подключите тот же репозиторий
3. Настройки:
   - **Name:** `listing-auditor-n8n`
   - **Build Command:** `npm install -g n8n`
   - **Start Command:** `n8n start`

### Browserless
1. **New +** → **Web Service**
2. Подключите тот же репозиторий
3. Настройки:
   - **Name:** `listing-auditor-browserless`
   - **Environment:** `Docker`
   - **Dockerfile Path:** `./browserless/Dockerfile`

## 3. Ключевые переменные окружения

### Frontend
```
SUPABASE_PUBLIC_URL=https://listing-auditor-db.onrender.com
SUPABASE_ANON_KEY=your_anon_key_here
```

### n8n
```
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=your_password
SUPABASE_URL=https://listing-auditor-db.onrender.com
SUPABASE_ANON_KEY=your_anon_key_here
MANUS_API_KEY=your_manus_key
BROWSERLESS_URL=https://listing-auditor-browserless.onrender.com
```

### Database
```
POSTGRES_PASSWORD=your_password
JWT_SECRET=your_jwt_secret
ANON_KEY=your_anon_key
SERVICE_ROLE_KEY=your_service_key
```

## 4. Получение ключей

### Supabase ключи
После создания базы данных в Render Dashboard:
1. Перейдите в PostgreSQL сервис
2. Скопируйте **Internal Database URL**
3. Используйте как `SUPABASE_URL`

### Генерация ключей
```bash
./scripts/generate-keys.sh
```
Скопируйте сгенерированные ключи в переменные окружения.

### Manus AI
1. Зарегистрируйтесь на [manus.ai](https://manus.ai)
2. Получите API ключ
3. Добавьте в `MANUS_API_KEY`

## 5. Инициализация (5 минут)

1. **База данных:** SQL скрипт выполнится автоматически
2. **n8n:** Откройте `https://listing-auditor-n8n.onrender.com`
   - Логин: `admin`
   - Пароль: (из `N8N_BASIC_AUTH_PASSWORD`)
3. **Импортируйте workflow:** `n8n/workflows/listing-audit.json`

## 6. Проверка

- **Frontend:** `https://listing-auditor-frontend.onrender.com`
- **n8n:** `https://listing-auditor-n8n.onrender.com`
- **Database:** Внутренний URL в Render Dashboard

## 🎉 Готово!

Ваш SaaS-сервис запущен за **20 минут**!

**Что дальше:**
1. Зарегистрируйтесь в приложении
2. Создайте первый аудит
3. Настройте Stripe для платежей
4. Подключите домен

---

## ❗ Важные моменты

- **Бесплатный план:** Сервисы "засыпают" после 15 минут неактивности
- **Платный план:** Рекомендуется для production
- **Логи:** Проверяйте в Render Dashboard при проблемах
- **Обновления:** `git push` автоматически перезапускает сервисы
