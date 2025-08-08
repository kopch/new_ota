FROM browserless/chrome:1.61.0

# Настройки Browserless
ENV MAX_CONCURRENT_SESSIONS=10
ENV CONNECTION_TIMEOUT=300000
ENV MAX_QUEUE_LENGTH=10
ENV ENABLE_DEBUGGER=false
ENV ENABLE_DEBUGGER_VIEWER=false
ENV ENABLE_CORS=true
ENV TOKEN=your_browserless_token_here

# Порт
EXPOSE 3000

# Запуск Browserless
CMD ["browserless", "start"]
