-- ============================================
-- Скрипт проверки структуры базы данных
-- ============================================

\echo '============================================'
\echo 'Проверка наличия всех таблиц'
\echo '============================================'

SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_type = 'BASE TABLE'
ORDER BY table_name;

\echo ''
\echo '============================================'
\echo 'Проверка первичных ключей'
\echo '============================================'

SELECT 
    tc.table_name, 
    kcu.column_name,
    tc.constraint_type
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
    ON tc.constraint_name = kcu.constraint_name
WHERE tc.constraint_type = 'PRIMARY KEY'
  AND tc.table_schema = 'public'
ORDER BY tc.table_name;

\echo ''
\echo '============================================'
\echo 'Проверка внешних ключей'
\echo '============================================'

SELECT 
    tc.table_name AS from_table,
    kcu.column_name AS from_column,
    ccu.table_name AS to_table,
    ccu.column_name AS to_column,
    rc.update_rule,
    rc.delete_rule
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage ccu 
    ON tc.constraint_name = ccu.constraint_name
JOIN information_schema.referential_constraints rc
    ON tc.constraint_name = rc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_schema = 'public'
ORDER BY tc.table_name, kcu.column_name;

\echo ''
\echo '============================================'
\echo 'Проверка уникальных ограничений'
\echo '============================================'

SELECT 
    tc.table_name,
    kcu.column_name,
    tc.constraint_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
    ON tc.constraint_name = kcu.constraint_name
WHERE tc.constraint_type = 'UNIQUE'
  AND tc.table_schema = 'public'
ORDER BY tc.table_name, kcu.column_name;

\echo ''
\echo '============================================'
\echo 'Проверка CHECK ограничений'
\echo '============================================'

SELECT 
    tc.table_name,
    tc.constraint_name,
    cc.check_clause
FROM information_schema.table_constraints tc
JOIN information_schema.check_constraints cc
    ON tc.constraint_name = cc.constraint_name
WHERE tc.constraint_type = 'CHECK'
  AND tc.table_schema = 'public'
ORDER BY tc.table_name;

\echo ''
\echo '============================================'
\echo 'Проверка NOT NULL ограничений'
\echo '============================================'

SELECT 
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
  AND is_nullable = 'NO'
ORDER BY table_name, ordinal_position;

\echo ''
\echo '============================================'
\echo 'Количество записей в таблицах'
\echo '============================================'

SELECT 'Specialties' AS table_name, COUNT(*) AS record_count FROM Specialties
UNION ALL
SELECT 'Positions', COUNT(*) FROM Positions
UNION ALL
SELECT 'Employees', COUNT(*) FROM Employees
UNION ALL
SELECT 'Education', COUNT(*) FROM Education
UNION ALL
SELECT 'Qualification_Training', COUNT(*) FROM Qualification_Training
UNION ALL
SELECT 'Rewards', COUNT(*) FROM Rewards
UNION ALL
SELECT 'Penalties', COUNT(*) FROM Penalties
ORDER BY table_name;

\echo ''
\echo '============================================'
\echo 'Проверка завершена!'
\echo '============================================'
