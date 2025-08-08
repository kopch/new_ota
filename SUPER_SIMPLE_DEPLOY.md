# 🚀 Супер простой деплой на Render.com

## Вариант 1: Только фронтенд (2 минуты)

### 1. Создайте репозиторий
```bash
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/your-username/listing-auditor-ai.git
git push -u origin main
```

### 2. Деплой через Blueprint
1. Зайдите на [render.com](https://render.com)
2. **New +** → **Blueprint**
3. Подключите репозиторий
4. Выберите `render-frontend-only.yaml`
5. **Deploy!**

### 3. Готово! 🎉
Ваш сайт: `https://listing-auditor-frontend.onrender.com`

---

## Вариант 2: Полный функционал (5 минут)

### 1. Создайте репозиторий (как выше)

### 2. Деплой через Blueprint
1. Зайдите на [render.com](https://render.com)
2. **New +** → **Blueprint**
3. Подключите репозиторий
4. Выберите `render-simple.yaml`
5. **Deploy!**

### 3. Добавьте только 2 переменные
В Database сервисе:
```
POSTGRES_PASSWORD=your_password
```

### 4. Готово! 🎉
- Frontend: `https://listing-auditor-frontend.onrender.com`
- Database: автоматически настроена

---

## Вариант 3: Ручной деплой (3 минуты)

### 1. Создайте только Frontend
- **New +** → **Web Service**
- Подключите репозиторий
- **Name:** `listing-auditor-frontend`
- **Build:** `cd apps/web && npm install && npm run build`
- **Start:** `cd apps/web && npm run preview`

### 2. Готово! 🎉

---

## ❗ Важные моменты

- **Бесплатный план:** Сервисы "засыпают" после 15 минут
- **Обновления:** `git push` автоматически перезапускает
- **Логи:** Проверяйте в Render Dashboard

---

## 🔗 Ссылки

- [Render Dashboard](https://dashboard.render.com)
- [Подробная инструкция](DEPLOYMENT.md) (если нужна)

