-- ============================================
-- Примеры SQL-запросов для базы данных отдела кадров
-- ============================================

\echo '============================================'
\echo 'Пример 1: Все сотрудники с должностями'
\echo '============================================'

SELECT 
    e.employee_id AS "Личный номер",
    e.full_name AS "ФИО",
    e.passport_number AS "Паспорт",
    e.birth_date AS "Дата рождения",
    p.position_name AS "Должность",
    p.salary AS "Оклад"
FROM Employees e
LEFT JOIN Positions p ON e.position_code = p.position_code
ORDER BY e.employee_id;

\echo ''
\echo '============================================'
\echo 'Пример 2: Информация об образовании'
\echo '============================================'

SELECT 
    e.full_name AS "ФИО сотрудника",
    ed.education_level AS "Уровень образования",
    ed.diploma_number AS "Номер диплома",
    s.specialty_name AS "Специальность",
    ed.qualification AS "Квалификация"
FROM Employees e
JOIN Education ed ON e.employee_id = ed.employee_id
LEFT JOIN Specialties s ON ed.specialty_code = s.specialty_code
ORDER BY e.full_name, ed.education_level DESC;

\echo ''
\echo '============================================'
\echo 'Пример 3: Повышение квалификации'
\echo '============================================'

SELECT 
    e.full_name AS "ФИО сотрудника",
    qt.training_date AS "Дата прохождения",
    qt.qualification_awarded AS "Присвоенная квалификация",
    qt.certificate_number AS "Номер свидетельства"
FROM Employees e
JOIN Qualification_Training qt ON e.employee_id = qt.employee_id
ORDER BY qt.training_date DESC;

\echo ''
\echo '============================================'
\echo 'Пример 4: Поощрения сотрудников'
\echo '============================================'

SELECT 
    e.full_name AS "ФИО сотрудника",
    r.reward_date AS "Дата поощрения",
    r.reward_type AS "Вид поощрения"
FROM Employees e
JOIN Rewards r ON e.employee_id = r.employee_id
ORDER BY r.reward_date DESC;

\echo ''
\echo '============================================'
\echo 'Пример 5: Взыскания сотрудников'
\echo '============================================'

SELECT 
    e.full_name AS "ФИО сотрудника",
    pen.penalty_date AS "Дата взыскания",
    pen.penalty_type AS "Вид взыскания"
FROM Employees e
JOIN Penalties pen ON e.employee_id = pen.employee_id
ORDER BY pen.penalty_date DESC;

\echo ''
\echo '============================================'
\echo 'Пример 6: Полная информация о сотруднике'
\echo '============================================'

SELECT 
    e.employee_id AS "Личный номер",
    e.full_name AS "ФИО",
    e.passport_number AS "Паспорт",
    e.birth_date AS "Дата рождения",
    EXTRACT(YEAR FROM AGE(e.birth_date)) AS "Возраст",
    e.home_address AS "Адрес",
    e.home_phone AS "Телефон",
    p.position_name AS "Должность",
    p.salary AS "Оклад"
FROM Employees e
LEFT JOIN Positions p ON e.position_code = p.position_code
WHERE e.employee_id = 1;

\echo ''
\echo '============================================'
\echo 'Пример 7: Статистика по должностям'
\echo '============================================'

SELECT 
    p.position_name AS "Должность",
    COUNT(e.employee_id) AS "Количество сотрудников",
    p.salary AS "Оклад"
FROM Positions p
LEFT JOIN Employees e ON p.position_code = e.position_code
GROUP BY p.position_code, p.position_name, p.salary
ORDER BY COUNT(e.employee_id) DESC;

\echo ''
\echo '============================================'
\echo 'Пример 8: Сотрудники с высшим образованием'
\echo '============================================'

SELECT DISTINCT
    e.full_name AS "ФИО",
    p.position_name AS "Должность"
FROM Employees e
JOIN Education ed ON e.employee_id = ed.employee_id
LEFT JOIN Positions p ON e.position_code = p.position_code
WHERE ed.education_level IN ('Высшее', 'Магистратура', 'Аспирантура')
ORDER BY e.full_name;

\echo ''
\echo '============================================'
\echo 'Пример 9: Сотрудники без взысканий'
\echo '============================================'

SELECT 
    e.full_name AS "ФИО",
    p.position_name AS "Должность"
FROM Employees e
LEFT JOIN Penalties pen ON e.employee_id = pen.employee_id
LEFT JOIN Positions p ON e.position_code = p.position_code
WHERE pen.penalty_id IS NULL
ORDER BY e.full_name;

\echo ''
\echo '============================================'
\echo 'Пример 10: Сводная информация по сотруднику'
\echo '============================================'

SELECT 
    e.full_name AS "ФИО",
    COUNT(DISTINCT ed.education_id) AS "Количество образований",
    COUNT(DISTINCT qt.training_id) AS "Повышений квалификации",
    COUNT(DISTINCT r.reward_id) AS "Поощрений",
    COUNT(DISTINCT pen.penalty_id) AS "Взысканий"
FROM Employees e
LEFT JOIN Education ed ON e.employee_id = ed.employee_id
LEFT JOIN Qualification_Training qt ON e.employee_id = qt.employee_id
LEFT JOIN Rewards r ON e.employee_id = r.employee_id
LEFT JOIN Penalties pen ON e.employee_id = pen.employee_id
GROUP BY e.employee_id, e.full_name
ORDER BY e.full_name;

\echo ''
\echo '============================================'
\echo 'Примеры запросов выполнены!'
\echo '============================================'
