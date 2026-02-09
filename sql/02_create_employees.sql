-- ============================================
-- Таблица: Employees (Сотрудники)
-- ============================================
CREATE TABLE IF NOT EXISTS Employees (
    employee_id SERIAL PRIMARY KEY,
    full_name VARCHAR(200) NOT NULL,
    passport_number VARCHAR(20) NOT NULL UNIQUE,
    birth_date DATE NOT NULL,
    home_address TEXT,
    home_phone VARCHAR(20),
    position_code VARCHAR(10) REFERENCES Positions(position_code) 
        ON UPDATE CASCADE 
        ON DELETE SET NULL,
    CONSTRAINT check_birth_date CHECK (birth_date <= CURRENT_DATE - INTERVAL '18 years')
);

COMMENT ON TABLE Employees IS 'Основная таблица сотрудников организации';
COMMENT ON COLUMN Employees.employee_id IS 'Личный номер сотрудника (первичный ключ, автоинкремент)';
COMMENT ON COLUMN Employees.full_name IS 'ФИО сотрудника (обязательное поле)';
COMMENT ON COLUMN Employees.passport_number IS 'Номер паспорта (уникальное, обязательное поле)';
COMMENT ON COLUMN Employees.birth_date IS 'Дата рождения (обязательное поле, возраст >= 18 лет)';
COMMENT ON COLUMN Employees.home_address IS 'Домашний адрес';
COMMENT ON COLUMN Employees.home_phone IS 'Домашний телефон';
COMMENT ON COLUMN Employees.position_code IS 'Код должности (внешний ключ на Positions)';
COMMENT ON CONSTRAINT check_birth_date ON Employees IS 'Проверка минимального возраста 18 лет';
