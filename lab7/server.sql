-- ============================================
-- Лабораторная работа №7
-- Создание приложения базы данных
-- База данных: Отдел кадров (hr_database)
-- Вариант №6
-- ============================================

-- ============================================
-- 2. Реализация базы данных в СУБД PostgreSQL
-- Создание ролей
-- ============================================

CREATE ROLE "hr_manager" LOGIN PASSWORD '1234';
CREATE ROLE "viewer" LOGIN PASSWORD '1111';

-- ============================================
-- Привилегии для viewer (просмотр сотрудников)
-- ============================================

GRANT EXECUTE ON FUNCTION getEmployees
TO "viewer";

GRANT EXECUTE ON FUNCTION getEmployeesByPosition
TO "viewer";

-- ============================================
-- Привилегии для hr_manager (просмотр + добавление + увольнение)
-- ============================================

GRANT SELECT ON employeeList
TO "hr_manager";

GRANT INSERT ON employeeList
TO "hr_manager";

GRANT SELECT ON "Positions" TO "hr_manager";
GRANT SELECT ON "Employees" TO "hr_manager";
GRANT INSERT, SELECT ON "Employees" TO "hr_manager";
GRANT INSERT, SELECT ON "Rewards" TO "hr_manager";
GRANT INSERT, SELECT ON "Penalties" TO "hr_manager";
GRANT EXECUTE ON FUNCTION addReward TO "hr_manager";
GRANT EXECUTE ON FUNCTION addPenalty TO "hr_manager";
GRANT EXECUTE ON FUNCTION fireEmployee TO "hr_manager";

-- ============================================
-- 3. Реализация серверной части приложения
-- ============================================

-- Вариант использования получения списка сотрудников
-- реализован с помощью функции getEmployees(search_name TEXT)

CREATE OR REPLACE FUNCTION PUBLIC.GETEMPLOYEES(search_name TEXT)
RETURNS TABLE(id INT, full_name TEXT, passport TEXT, birth_date DATE,
address TEXT, phone TEXT, position TEXT, salary NUMERIC) AS $$
SELECT E.employee_id, E.full_name, E.passport_number, E.birth_date,
E.home_address, E.home_phone, P.position_name, P.salary
FROM "Employees" E
LEFT JOIN "Positions" P ON E.position_code = P.position_code
WHERE E.full_name LIKE '%' || search_name || '%'
ORDER BY E.full_name
$$ LANGUAGE SQL
SECURITY DEFINER;

-- Вариант использования получения сотрудников по должности
-- реализован с помощью функции getEmployeesByPosition(pos_name TEXT)

CREATE OR REPLACE FUNCTION PUBLIC.GETEMPLOYEESBYPOSITION(pos_name TEXT)
RETURNS TABLE(id INT, full_name TEXT, passport TEXT, birth_date DATE,
address TEXT, phone TEXT, position TEXT, salary NUMERIC) AS $$
SELECT E.employee_id, E.full_name, E.passport_number, E.birth_date,
E.home_address, E.home_phone, P.position_name, P.salary
FROM "Employees" E
LEFT JOIN "Positions" P ON E.position_code = P.position_code
WHERE P.position_name LIKE '%' || pos_name || '%'
ORDER BY E.full_name
$$ LANGUAGE SQL
SECURITY DEFINER;

-- Вариант добавления поощрения реализован с помощью функции
-- addReward(emp_id INT, r_type TEXT)

CREATE OR REPLACE FUNCTION PUBLIC.ADDREWARD(emp_id INT, r_type TEXT)
RETURNS VOID AS
$$
BEGIN
    INSERT INTO "Rewards"(employee_id, reward_date, reward_type)
    VALUES(emp_id, NOW(), r_type);
END;
$$ LANGUAGE PLPGSQL;

-- Вариант добавления взыскания реализован с помощью функции
-- addPenalty(emp_id INT, p_type TEXT)

CREATE OR REPLACE FUNCTION PUBLIC.ADDPENALTY(emp_id INT, p_type TEXT)
RETURNS VOID AS
$$
BEGIN
    INSERT INTO "Penalties"(employee_id, penalty_date, penalty_type)
    VALUES(emp_id, NOW(), p_type);
END;
$$ LANGUAGE PLPGSQL;

-- При попытке добавить сотрудника срабатывает триггер

CREATE TRIGGER TR1
BEFORE
INSERT ON "Employees"
FOR EACH ROW EXECUTE PROCEDURE checkEmployeeAge();

-- Триггер вызывается перед добавлением, т.к. функция
-- checkEmployeeAge() проверяет возраст сотрудника (не менее 18 лет)

CREATE OR REPLACE FUNCTION checkEmployeeAge()
RETURNS TRIGGER
AS
$$
DECLARE
    age_years INT;
BEGIN
    age_years := DATE_PART('year', AGE(NOW(), new.birth_date));

    IF age_years < 18 THEN
        RAISE EXCEPTION 'Сотрудник должен быть не младше 18 лет (возраст: %)', age_years;
    END IF;
    RETURN new;
END;
$$ LANGUAGE PLPGSQL;

-- Вариант просмотра сотрудников hr_manager реализован с помощью представления

CREATE OR REPLACE VIEW employeeList AS
SELECT E.employee_id, E.full_name, E.passport_number, E.birth_date,
E.home_address, E.home_phone, P.position_name, P.salary
FROM "Employees" E
LEFT JOIN "Positions" P ON E.position_code = P.position_code
ORDER BY E.full_name;

-- Вариант использования добавления сотрудника hr_manager
-- реализован с помощью представления employeeList

CREATE OR REPLACE RULE "insertEmployee" AS
ON INSERT TO employeeList
DO NOTHING;

-- Вариант увольнения сотрудника реализован с помощью функции
-- fireEmployee(emp_id INT)

CREATE OR REPLACE FUNCTION PUBLIC.FIREEMPLOYEE(emp_id INT)
RETURNS VOID AS
$$
BEGIN
    DELETE FROM "Employees" WHERE employee_id = emp_id;
END;
$$ LANGUAGE PLPGSQL;
