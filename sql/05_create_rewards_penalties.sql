-- ============================================
-- Таблица: Rewards (Поощрения)
-- ============================================
CREATE TABLE IF NOT EXISTS Rewards (
    reward_id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL REFERENCES Employees(employee_id) 
        ON UPDATE CASCADE 
        ON DELETE CASCADE,
    reward_date DATE NOT NULL,
    reward_type VARCHAR(100) NOT NULL,
    CONSTRAINT check_reward_date CHECK (reward_date <= CURRENT_DATE)
);

COMMENT ON TABLE Rewards IS 'Информация о поощрениях сотрудников';
COMMENT ON COLUMN Rewards.reward_id IS 'Идентификатор поощрения (первичный ключ)';
COMMENT ON COLUMN Rewards.employee_id IS 'Личный номер сотрудника (внешний ключ, каскадное удаление)';
COMMENT ON COLUMN Rewards.reward_date IS 'Дата поощрения (не в будущем)';
COMMENT ON COLUMN Rewards.reward_type IS 'Вид поощрения';
COMMENT ON CONSTRAINT check_reward_date ON Rewards IS 'Проверка, что дата не в будущем';

-- ============================================
-- Таблица: Penalties (Взыскания)
-- ============================================
CREATE TABLE IF NOT EXISTS Penalties (
    penalty_id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL REFERENCES Employees(employee_id) 
        ON UPDATE CASCADE 
        ON DELETE CASCADE,
    penalty_date DATE NOT NULL,
    penalty_type VARCHAR(100) NOT NULL,
    CONSTRAINT check_penalty_date CHECK (penalty_date <= CURRENT_DATE)
);

COMMENT ON TABLE Penalties IS 'Информация о взысканиях сотрудников';
COMMENT ON COLUMN Penalties.penalty_id IS 'Идентификатор взыскания (первичный ключ)';
COMMENT ON COLUMN Penalties.employee_id IS 'Личный номер сотрудника (внешний ключ, каскадное удаление)';
COMMENT ON COLUMN Penalties.penalty_date IS 'Дата наложения взыскания (не в будущем)';
COMMENT ON COLUMN Penalties.penalty_type IS 'Вид взыскания';
COMMENT ON CONSTRAINT check_penalty_date ON Penalties IS 'Проверка, что дата не в будущем';
