-- ============================================
-- Таблица: Education (Образование)
-- ============================================
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

COMMENT ON TABLE Education IS 'Информация об образовании сотрудников';
COMMENT ON COLUMN Education.education_id IS 'Идентификатор записи об образовании (первичный ключ)';
COMMENT ON COLUMN Education.employee_id IS 'Личный номер сотрудника (внешний ключ, каскадное удаление)';
COMMENT ON COLUMN Education.education_level IS 'Уровень образования (перечислимое значение)';
COMMENT ON COLUMN Education.diploma_number IS 'Номер диплома (уникальное, обязательное поле)';
COMMENT ON COLUMN Education.specialty_code IS 'Код специальности (внешний ключ на Specialties)';
COMMENT ON COLUMN Education.qualification IS 'Квалификация по образованию';
COMMENT ON CONSTRAINT check_education_level ON Education IS 'Проверка допустимых уровней образования';
