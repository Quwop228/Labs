-- ============================================
-- Тестирование ограничений целостности
-- Этот скрипт демонстрирует работу ограничений
-- ============================================

\echo '============================================'
\echo 'ТЕСТ 1: Проверка возраста (должна быть ошибка)'
\echo '============================================'

-- Попытка вставить сотрудника младше 18 лет
INSERT INTO Employees (full_name, passport_number, birth_date) 
VALUES ('Несовершеннолетний Тест', '9999 111111', '2010-01-01');

\echo ''
\echo '============================================'
\echo 'ТЕСТ 2: Проверка уникальности паспорта (должна быть ошибка)'
\echo '============================================'

-- Попытка вставить сотрудника с существующим паспортом
INSERT INTO Employees (full_name, passport_number, birth_date) 
VALUES ('Дубликат Паспорта', '4512 123456', '1990-01-01');

\echo ''
\echo '============================================'
\echo 'ТЕСТ 3: Проверка NOT NULL (должна быть ошибка)'
\echo '============================================'

-- Попытка вставить сотрудника без обязательных полей
INSERT INTO Employees (full_name, birth_date) 
VALUES ('Без Паспорта', '1990-01-01');

\echo ''
\echo '============================================'
\echo 'ТЕСТ 4: Проверка положительности оклада (должна быть ошибка)'
\echo '============================================'

-- Попытка вставить должность с отрицательным окладом
INSERT INTO Positions (position_code, position_name, salary) 
VALUES ('NEG', 'Отрицательный оклад', -1000);

\echo ''
\echo '============================================'
\echo 'ТЕСТ 5: Проверка внешнего ключа (должна быть ошибка)'
\echo '============================================'

-- Попытка назначить несуществующую должность
INSERT INTO Employees (full_name, passport_number, birth_date, position_code) 
VALUES ('Тест Внешнего Ключа', '9999 222222', '1990-01-01', 'NONEXIST');

\echo ''
\echo '============================================'
\echo 'ТЕСТ 6: Проверка уникальности номера диплома (должна быть ошибка)'
\echo '============================================'

-- Попытка вставить образование с существующим номером диплома
INSERT INTO Education (employee_id, education_level, diploma_number, specialty_code) 
VALUES (1, 'Высшее', 'ВСГ 1234567', '09.03.01');

\echo ''
\echo '============================================'
\echo 'ТЕСТ 7: Проверка перечислимого значения (должна быть ошибка)'
\echo '============================================'

-- Попытка вставить недопустимый уровень образования
INSERT INTO Education (employee_id, education_level, diploma_number) 
VALUES (1, 'Начальное', 'ВСГ 9999999');

\echo ''
\echo '============================================'
\echo 'ТЕСТ 8: Проверка даты в будущем (должна быть ошибка)'
\echo '============================================'

-- Попытка вставить поощрение с датой в будущем
INSERT INTO Rewards (employee_id, reward_date, reward_type) 
VALUES (1, '2030-01-01', 'Будущее поощрение');

\echo ''
\echo '============================================'
\echo 'ТЕСТ 9: Каскадное удаление (должно пройти успешно)'
\echo '============================================'

-- Создать временного сотрудника с зависимыми записями
BEGIN;

INSERT INTO Employees (full_name, passport_number, birth_date) 
VALUES ('Временный Сотрудник', '9999 333333', '1990-01-01')
RETURNING employee_id;

-- Сохраним ID для использования (в реальности нужно получить из RETURNING)
DO $$
DECLARE
    temp_emp_id INTEGER;
BEGIN
    SELECT employee_id INTO temp_emp_id 
    FROM Employees 
    WHERE passport_number = '9999 333333';
    
    -- Добавить зависимые записи
    INSERT INTO Education (employee_id, education_level, diploma_number) 
    VALUES (temp_emp_id, 'Высшее', 'TEMP 999999');
    
    INSERT INTO Rewards (employee_id, reward_date, reward_type) 
    VALUES (temp_emp_id, CURRENT_DATE, 'Тестовое поощрение');
    
    -- Проверить количество записей
    RAISE NOTICE 'Создано записей об образовании: %', 
        (SELECT COUNT(*) FROM Education WHERE employee_id = temp_emp_id);
    RAISE NOTICE 'Создано поощрений: %', 
        (SELECT COUNT(*) FROM Rewards WHERE employee_id = temp_emp_id);
    
    -- Удалить сотрудника (должны удалиться и зависимые записи)
    DELETE FROM Employees WHERE employee_id = temp_emp_id;
    
    -- Проверить, что зависимые записи удалены
    RAISE NOTICE 'После удаления сотрудника:';
    RAISE NOTICE 'Записей об образовании: %', 
        (SELECT COUNT(*) FROM Education WHERE employee_id = temp_emp_id);
    RAISE NOTICE 'Поощрений: %', 
        (SELECT COUNT(*) FROM Rewards WHERE employee_id = temp_emp_id);
END $$;

ROLLBACK;

\echo ''
\echo '============================================'
\echo 'ТЕСТ 10: Каскадное обновление (должно пройти успешно)'
\echo '============================================'

BEGIN;

-- Создать временную должность
INSERT INTO Positions (position_code, position_name, salary) 
VALUES ('TEMP', 'Временная должность', 50000);

-- Назначить должность сотруднику
UPDATE Employees SET position_code = 'TEMP' WHERE employee_id = 1;

-- Проверить назначение
SELECT full_name, position_code FROM Employees WHERE employee_id = 1;

-- Изменить код должности (должен обновиться и у сотрудника)
UPDATE Positions SET position_code = 'TEMP2' WHERE position_code = 'TEMP';

-- Проверить обновление
SELECT full_name, position_code FROM Employees WHERE employee_id = 1;

ROLLBACK;

\echo ''
\echo '============================================'
\echo 'Тестирование ограничений завершено!'
\echo 'Все ошибки выше - ожидаемое поведение'
\echo '============================================'
