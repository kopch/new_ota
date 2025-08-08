# Деплой на Render.com

## 🚀 Пошаговая инструкция по развертыванию

### 1. Подготовка проекта

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
   chmod +x scripts/generate-keys.sh
   ./scripts/generate-keys.sh
   ```

### 2. Настройка Render.com

#### 2.1 Создание аккаунта
1. Зайдите на [render.com](https://render.com)
2. Зарегистрируйтесь через GitHub
3. Подключите ваш репозиторий

#### 2.2 Создание сервисов

**Frontend (Vue.js):**
1. Нажмите "New +" → "Web Service"
2. Подключите ваш GitHub репозиторий
3. Настройки:
   - **Name:** `listing-auditor-frontend`
   - **Environment:** `Node`
   - **Build Command:** `cd apps/web && npm install && npm run build`
   - **Start Command:** `cd apps/web && npm run preview`
   - **Plan:** Free (или выберите платный план)

**n8n Workflow:**
1. Нажмите "New +" → "Web Service"
2. Подключите тот же репозиторий
3. Настройки:
   - **Name:** `listing-auditor-n8n`
   - **Environment:** `Node`
   - **Build Command:** `npm install -g n8n`
   - **Start Command:** `n8n start`
   - **Plan:** Free (или выберите платный план)

**Database (PostgreSQL):**
1. Нажмите "New +" → "PostgreSQL"
2. Настройки:
   - **Name:** `listing-auditor-db`
   - **Database:** `listing_auditor`
   - **User:** `listing_auditor_user`
   - **Plan:** Free (или выберите платный план)

**Browserless:**
1. Нажмите "New +" → "Web Service"
2. Подключите тот же репозиторий
3. Настройки:
   - **Name:** `listing-auditor-browserless`
   - **Environment:** `Docker`
   - **Dockerfile Path:** `./browserless/Dockerfile`
   - **Plan:** Free (или выберите платный план)

### 3. Настройка переменных окружения

#### 3.1 Frontend переменные
В настройках `listing-auditor-frontend` → "Environment":

```
NODE_ENV=production
PUBLIC_SITE_URL=https://listing-auditor-frontend.onrender.com
SUPABASE_PUBLIC_URL=https://listing-auditor-db.onrender.com
SUPABASE_ANON_KEY=your_anon_key_here
```

#### 3.2 n8n переменные
В настройках `listing-auditor-n8n` → "Environment":

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

#### 3.3 Database переменные
В настройках `listing-auditor-db` → "Environment":

```
POSTGRES_PASSWORD=your_secure_password
POSTGRES_DB=listing_auditor
POSTGRES_USER=listing_auditor_user
JWT_SECRET=your_jwt_secret
ANON_KEY=your_anon_key
SERVICE_ROLE_KEY=your_service_role_key
```

#### 3.4 Browserless переменные
В настройках `listing-auditor-browserless` → "Environment":

```
MAX_CONCURRENT_SESSIONS=10
CONNECTION_TIMEOUT=300000
MAX_QUEUE_LENGTH=10
TOKEN=your_browserless_token
```

### 4. Получение ключей

#### 4.1 Supabase ключи
После создания базы данных, получите ключи из Render Dashboard:

1. Перейдите в ваш PostgreSQL сервис
2. В разделе "Connections" найдите:
   - **Internal Database URL** (для SUPABASE_URL)
   - **External Database URL** (для подключения извне)

#### 4.2 Генерация JWT и API ключей
Используйте скрипт `scripts/generate-keys.sh`:

```bash
./scripts/generate-keys.sh
```

Скопируйте сгенерированные ключи в соответствующие переменные окружения.

#### 4.3 Manus AI API ключ
1. Зарегистрируйтесь на [manus.ai](https://manus.ai)
2. Получите API ключ в личном кабинете
3. Добавьте в переменную `MANUS_API_KEY`

#### 4.4 Stripe ключи (опционально)
1. Создайте аккаунт на [stripe.com](https://stripe.com)
2. Получите ключи в Dashboard:
   - **Publishable Key** → `STRIPE_PUBLISHABLE_KEY`
   - **Secret Key** → `STRIPE_API_KEY`
   - **Webhook Secret** → `STRIPE_WEBHOOK_SECRET`

### 5. Инициализация базы данных

После создания всех сервисов:

1. Подключитесь к базе данных через psql или pgAdmin
2. Выполните SQL скрипт из `supabase/init/01-schema.sql`
3. Или используйте автоматическую инициализацию через Docker

### 6. Настройка n8n

1. Откройте n8n по адресу: `https://listing-auditor-n8n.onrender.com`
2. Войдите используя:
   - **Username:** `admin`
   - **Password:** (тот, что указали в `N8N_BASIC_AUTH_PASSWORD`)
3. Импортируйте workflow из `n8n/workflows/listing-audit.json`
4. Активируйте workflow

### 7. Проверка деплоя

1. **Frontend:** `https://listing-auditor-frontend.onrender.com`
2. **n8n:** `https://listing-auditor-n8n.onrender.com`
3. **Database:** Внутренний URL в Render Dashboard
4. **Browserless:** `https://listing-auditor-browserless.onrender.com`

### 8. Мониторинг и логи

- **Логи:** В каждом сервисе на Render есть вкладка "Logs"
- **Метрики:** В разделе "Metrics" каждого сервиса
- **Алерты:** Настройте уведомления в "Alerts"

### 9. Обновления

Для обновления приложения:
```bash
git add .
git commit -m "Update description"
git push origin main
```

Render автоматически пересоберет и перезапустит сервисы.

### 10. Troubleshooting

#### Проблемы с подключением к базе данных
- Проверьте переменные окружения
- Убедитесь, что база данных запущена
- Проверьте логи в Render Dashboard

#### Проблемы с n8n
- Проверьте переменные окружения
- Убедитесь, что workflow импортирован и активирован
- Проверьте логи n8n

#### Проблемы с Browserless
- Проверьте переменные окружения
- Убедитесь, что сервис доступен
- Проверьте логи Browserless

### 11. Безопасность

- Используйте сильные пароли
- Регулярно обновляйте ключи
- Настройте HTTPS (автоматически в Render)
- Ограничьте доступ к n8n через Basic Auth

### 12. Масштабирование

Для увеличения производительности:
1. Перейдите на платные планы Render
2. Увеличьте ресурсы для каждого сервиса
3. Настройте автомасштабирование

---

## 🎉 Готово!

Ваш SaaS-сервис "Listing Auditor AI" успешно развернут на Render.com!

**Следующие шаги:**
1. Протестируйте все функции
2. Настройте мониторинг
3. Подключите домен (опционально)
4. Настройте Stripe для платежей
5. Добавьте аналитику (Google Analytics, Mixpanel)
