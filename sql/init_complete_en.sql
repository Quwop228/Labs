-- ============================================
-- HR Database Complete Initialization
-- All-in-one script
-- ============================================

\echo 'Starting hr_database initialization...'

-- ============================================
-- Reference tables
-- ============================================
\echo 'Creating reference tables...'

CREATE TABLE IF NOT EXISTS Specialties (
    specialty_code VARCHAR(20) PRIMARY KEY,
    specialty_name VARCHAR(200) NOT NULL
);

CREATE TABLE IF NOT EXISTS Positions (
    position_code VARCHAR(10) PRIMARY KEY,
    position_name VARCHAR(100) NOT NULL,
    salary NUMERIC(10, 2) NOT NULL,
    CONSTRAINT check_salary CHECK (salary > 0)
);

-- ============================================
-- Employees table
-- ============================================
\echo 'Creating employees table...'

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

-- ============================================
-- Education table
-- ============================================
\echo 'Creating education table...'

CREATE TABLE IF NOT EXISTS Education (
    education_id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL REFERENCES Employees(employee_id) 
        ON UPDATE CASCADE 
        ON DELETE CASCADE,
    education_level VARCHAR(50) NOT NULL,
    diploma_number VARCHAR(50) NOT NULL UNIQUE,
    specialty_code VARCHAR(20) REFERENCES Specialties(specialty_code) 
        ON UPDATE CASCADE 
        ON DELETE SET NULL,
    qualification VARCHAR(100),
    CONSTRAINT check_education_level CHECK (
        education_level IN ('Среднее', 'Среднее специальное', 
                           'Неполное высшее', 'Высшее', 'Магистратура', 'Аспирантура')
    )
);

-- ============================================
-- Qualification training table
-- ============================================
\echo 'Creating qualification training table...'

CREATE TABLE IF NOT EXISTS Qualification_Training (
    training_id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL REFERENCES Employees(employee_id) 
        ON UPDATE CASCADE 
        ON DELETE CASCADE,
    training_date DATE NOT NULL,
    qualification_awarded VARCHAR(100) NOT NULL,
    certificate_number VARCHAR(50) NOT NULL UNIQUE,
    CONSTRAINT check_training_date CHECK (training_date <= CURRENT_DATE)
);

-- ============================================
-- Rewards and penalties tables
-- ============================================
\echo 'Creating rewards and penalties tables...'

CREATE TABLE IF NOT EXISTS Rewards (
    reward_id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL REFERENCES Employees(employee_id) 
        ON UPDATE CASCADE 
        ON DELETE CASCADE,
    reward_date DATE NOT NULL,
    reward_type VARCHAR(100) NOT NULL,
    CONSTRAINT check_reward_date CHECK (reward_date <= CURRENT_DATE)
);

CREATE TABLE IF NOT EXISTS Penalties (
    penalty_id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL REFERENCES Employees(employee_id) 
        ON UPDATE CASCADE 
        ON DELETE CASCADE,
    penalty_date DATE NOT NULL,
    penalty_type VARCHAR(100) NOT NULL,
    CONSTRAINT check_penalty_date CHECK (penalty_date <= CURRENT_DATE)
);

-- ============================================
-- Test data
-- ============================================
\echo 'Loading test data...'

INSERT INTO Specialties (specialty_code, specialty_name) VALUES
('09.03.01', 'Информатика и вычислительная техника'),
('38.03.01', 'Экономика'),
('40.03.01', 'Юриспруденция'),
('09.03.03', 'Прикладная информатика'),
('38.03.02', 'Менеджмент');

INSERT INTO Positions (position_code, position_name, salary) VALUES
('DIR', 'Директор', 150000.00),
('MGR', 'Менеджер', 80000.00),
('DEV', 'Разработчик', 95000.00),
('ACC', 'Бухгалтер', 70000.00),
('HR', 'Специалист по кадрам', 65000.00),
('LAW', 'Юрист', 75000.00);

INSERT INTO Employees (full_name, passport_number, birth_date, home_address, home_phone, position_code) VALUES
('Иванов Иван Иванович', '4512 123456', '1985-03-15', 'г. Москва, ул. Ленина, д. 10, кв. 5', '+7-495-123-45-67', 'DIR'),
('Петрова Мария Сергеевна', '4513 234567', '1990-07-22', 'г. Москва, ул. Пушкина, д. 20, кв. 12', '+7-495-234-56-78', 'MGR'),
('Сидоров Петр Алексеевич', '4514 345678', '1988-11-30', 'г. Москва, ул. Гоголя, д. 15, кв. 8', '+7-495-345-67-89', 'DEV'),
('Козлова Анна Дмитриевна', '4515 456789', '1992-05-18', 'г. Москва, ул. Чехова, д. 25, кв. 3', '+7-495-456-78-90', 'ACC'),
('Смирнов Алексей Викторович', '4516 567890', '1987-09-10', 'г. Москва, ул. Толстого, д. 30, кв. 15', '+7-495-567-89-01', 'DEV'),
('Новикова Елена Павловна', '4517 678901', '1995-02-28', 'г. Москва, ул. Достоевского, д. 5, кв. 7', '+7-495-678-90-12', 'HR');

INSERT INTO Education (employee_id, education_level, diploma_number, specialty_code, qualification) VALUES
(1, 'Высшее', 'ВСГ 1234567', '38.03.02', 'Менеджер'),
(2, 'Высшее', 'ВСГ 2345678', '38.03.01', 'Экономист'),
(3, 'Высшее', 'ВСГ 3456789', '09.03.01', 'Инженер-программист'),
(3, 'Магистратура', 'ВМА 1111111', '09.03.03', 'Магистр прикладной информатики'),
(4, 'Высшее', 'ВСГ 4567890', '38.03.01', 'Экономист-бухгалтер'),
(5, 'Высшее', 'ВСГ 5678901', '09.03.01', 'Инженер-программист'),
(6, 'Высшее', 'ВСГ 6789012', '38.03.02', 'Менеджер по персоналу');

INSERT INTO Qualification_Training (employee_id, training_date, qualification_awarded, certificate_number) VALUES
(1, '2023-06-15', 'Управление проектами', 'ПК-2023-001'),
(2, '2023-09-20', 'Финансовый анализ', 'ПК-2023-002'),
(3, '2024-01-10', 'Современные технологии разработки ПО', 'ПК-2024-001'),
(5, '2024-03-15', 'Архитектура микросервисов', 'ПК-2024-002');

INSERT INTO Rewards (employee_id, reward_date, reward_type) VALUES
(1, '2023-12-25', 'Премия за выполнение годового плана'),
(3, '2024-03-08', 'Благодарность за успешную реализацию проекта'),
(2, '2024-05-01', 'Премия ко Дню труда'),
(5, '2024-06-15', 'Благодарность за наставничество');

INSERT INTO Penalties (employee_id, penalty_date, penalty_type) VALUES
(4, '2024-02-10', 'Замечание за опоздание'),
(6, '2024-04-20', 'Выговор за нарушение трудовой дисциплины');

\echo ''
\echo 'Initialization completed successfully!'
\echo ''
\echo 'Data verification:'

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
