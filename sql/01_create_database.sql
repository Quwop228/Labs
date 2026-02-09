-- ============================================
-- Лабораторная работа 1: База данных отдела кадров
-- Создание базы данных и справочных таблиц
-- ============================================

-- Создание базы данных (выполнить от имени суперпользователя)
-- DROP DATABASE IF EXISTS hr_database;
-- CREATE DATABASE hr_database
--     WITH 
--     ENCODING = 'UTF8'
--     LC_COLLATE = 'Russian_Russia.1251'
--     LC_CTYPE = 'Russian_Russia.1251'
--     TEMPLATE = template0;

-- Подключение к базе данных
-- \c hr_database

-- ============================================
-- Таблица: Specialties (Справочник специальностей)
-- ============================================
CREATE TABLE IF NOT EXISTS Specialties (
    specialty_code VARCHAR(20) PRIMARY KEY,
    specialty_name VARCHAR(200) NOT NULL
);

COMMENT ON TABLE Specialties IS 'Справочник специальностей по образованию';
COMMENT ON COLUMN Specialties.specialty_code IS 'Код специальности (первичный ключ)';
COMMENT ON COLUMN Specialties.specialty_name IS 'Наименование специальности';

-- ============================================
-- Таблица: Positions (Справочник должностей)
-- ============================================
CREATE TABLE IF NOT EXISTS Positions (
    position_code VARCHAR(10) PRIMARY KEY,
    position_name VARCHAR(100) NOT NULL,
    salary NUMERIC(10, 2) NOT NULL,
    CONSTRAINT check_salary CHECK (salary > 0)
);

COMMENT ON TABLE Positions IS 'Справочник должностей с окладами';
COMMENT ON COLUMN Positions.position_code IS 'Код должности (первичный ключ)';
COMMENT ON COLUMN Positions.position_name IS 'Наименование должности';
COMMENT ON COLUMN Positions.salary IS 'Должностной оклад (должен быть больше нуля)';
COMMENT ON CONSTRAINT check_salary ON Positions IS 'Проверка положительности оклада';
