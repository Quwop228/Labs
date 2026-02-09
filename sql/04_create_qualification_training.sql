-- ============================================
-- Таблица: Qualification_Training (Повышение квалификации)
-- ============================================
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

COMMENT ON TABLE Qualification_Training IS 'Информация о повышении квалификации сотрудников';
COMMENT ON COLUMN Qualification_Training.training_id IS 'Идентификатор записи о повышении квалификации (первичный ключ)';
COMMENT ON COLUMN Qualification_Training.employee_id IS 'Личный номер сотрудника (внешний ключ, каскадное удаление)';
COMMENT ON COLUMN Qualification_Training.training_date IS 'Дата прохождения повышения квалификации (не в будущем)';
COMMENT ON COLUMN Qualification_Training.qualification_awarded IS 'Присвоенная квалификация';
COMMENT ON COLUMN Qualification_Training.certificate_number IS 'Номер свидетельства о повышении квалификации (уникальное)';
COMMENT ON CONSTRAINT check_training_date ON Qualification_Training IS 'Проверка, что дата не в будущем';
