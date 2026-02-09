-- ============================================
-- Пересоздание базы данных с правильной кодировкой
-- Запустить от имени postgres: psql -U postgres -f sql/00_recreate_database.sql
-- ============================================

-- Отключить всех пользователей от базы данных
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'hr_database'
  AND pid <> pg_backend_pid();

-- Удалить базу данных если существует
DROP DATABASE IF EXISTS hr_database;

-- Создать базу данных с кодировкой WIN1251
CREATE DATABASE hr_database
    WITH 
    ENCODING = 'WIN1251'
    TEMPLATE = template0;

\echo 'База данных hr_database пересоздана с кодировкой WIN1251'
\echo 'Теперь подключитесь к базе и выполните инициализацию:'
\echo 'psql -U postgres -d hr_database -f sql/00_init_all.sql'
