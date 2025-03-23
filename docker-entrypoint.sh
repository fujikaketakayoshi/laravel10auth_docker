#!/bin/bash
set -e

# .envファイルの確認と必要に応じてコピー
if [ -f .env.docker ] && [ ! -f .env ]; then
  cp .env.docker .env
elif [ -f .env.docker ] && ! diff -q .env.docker .env > /dev/null; then
  cp .env.docker .env
fi

# データベースが準備できるまで待機
until mysql -h db -u root -ppass -e "SELECT 1"; do
  echo "Waiting for database connection..."
  sleep 1
done

# マイグレーションの実行
php artisan migrate --force

# 通常のApache起動
exec apache2-foreground