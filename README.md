# Docker Compose Deploy Action

[![Deploy with Docker Compose](https://github.com/harnyk/docker-compose-deploy-action-example/actions/workflows/deploy.yml/badge.svg)](https://github.com/harnyk/docker-compose-deploy-action-example/actions/workflows/deploy.yml)

GitHub Action для автоматического деплоя приложений через Docker Compose на удаленный сервер.

## Переменные (Variables)

Настройте в Settings → Secrets and variables → Actions → Variables:

- `SSH_HOST` - IP адрес или домен сервера
- `SSH_USERNAME` - имя пользователя для SSH
- `SSH_PORT` - порт SSH (обычно 22)
- `TARGET_DIR` - абсолютный путь для деплоя (например: `/home/ubuntu/deployment`)

## Секреты (Secrets)

Настройте в Settings → Secrets and variables → Actions → Secrets:

- `SSH_PRIVATE_KEY` - приватный SSH ключ
- `SSH_PASSPHRASE` - пароль для SSH ключа (опционально)

## Запуск

### Из интерфейса GitHub
1. Actions → Deploy with Docker Compose
2. Run workflow

### Из консоли
```bash
gh workflow run deploy.yml
```

## Что делает
1. Копирует файлы на сервер
2. Устанавливает Docker и Docker Compose
3. Останавливает старые контейнеры
4. Запускает новые контейнеры
5. Проверяет статус деплоя