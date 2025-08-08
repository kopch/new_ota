FROM supabase/postgres:15.1.0.117

# Копируем SQL скрипты для инициализации
COPY init/ /docker-entrypoint-initdb.d/

# Устанавливаем дополнительные расширения
RUN apt-get update && apt-get install -y \
    postgresql-15-postgis \
    postgresql-15-pgrouting \
    && rm -rf /var/lib/apt/lists/*

# Настройки PostgreSQL
ENV POSTGRES_DB=postgres
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=your_password_here

# Порт
EXPOSE 5432

# Запуск PostgreSQL
CMD ["postgres"]
