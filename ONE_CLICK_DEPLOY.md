# 🚀 Деплой в один клик на Render.com

## Быстрый старт (5 минут)

### 1. Подготовка
```bash
# Создайте репозиторий на GitHub
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/your-username/listing-auditor-ai.git
git push -u origin main
```

### 2. Автоматический деплой через render.yaml

**Просто загрузите `render.yaml` в Render.com!**

1. Зайдите на [render.com](https://render.com)
2. Нажмите **"New +"** → **"Blueprint"**
3. Подключите ваш GitHub репозиторий
4. Render автоматически создаст все 4 сервиса!

### 3. Настройка переменных (2 минуты)

После создания сервисов добавьте только **3 ключевые переменные**:

#### В n8n сервисе:
```
MANUS_API_KEY=your_manus_api_key
N8N_BASIC_AUTH_PASSWORD=your_password
```

#### В Database сервисе:
```
POSTGRES_PASSWORD=your_password
```

### 4. Готово! 🎉

Ваши сервисы:
- **Frontend:** `https://listing-auditor-frontend.onrender.com`
- **n8n:** `https://listing-auditor-n8n.onrender.com`

---

## Альтернативный способ (если Blueprint не работает)

### 1. Создайте только 2 сервиса:

#### Frontend
- **New +** → **Web Service**
- Подключите репозиторий
- **Name:** `listing-auditor-frontend`
- **Build:** `cd apps/web && npm install && npm run build`
- **Start:** `cd apps/web && npm run preview`

#### Database
- **New +** → **PostgreSQL**
- **Name:** `listing-auditor-db`

### 2. Добавьте переменные в Frontend:
```
SUPABASE_PUBLIC_URL=https://listing-auditor-db.onrender.com
SUPABASE_ANON_KEY=your_anon_key
```

### 3. Готово! 🎉

---

## Получение ключей

### Manus AI (обязательно)
1. Зарегистрируйтесь на [manus.ai](https://manus.ai)
2. Получите API ключ
3. Добавьте в `MANUS_API_KEY`

### Supabase ключи (автоматически)
После создания базы данных в Render Dashboard:
1. Перейдите в PostgreSQL сервис
2. Скопируйте **Internal Database URL**
3. Используйте как `SUPABASE_URL`

---

## ❗ Важные моменты

- **Бесплатный план:** Сервисы "засыпают" после 15 минут
- **Платный план:** Рекомендуется для production
- **Обновления:** `git push` автоматически перезапускает сервисы

---

## 🔗 Ссылки

- [Render Dashboard](https://dashboard.render.com)
- [Manus AI](https://manus.ai)
- [Подробная инструкция](DEPLOYMENT.md) (если нужна)

