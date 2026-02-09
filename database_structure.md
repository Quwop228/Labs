# Структура базы данных отдела кадров

## Общая информация

**Название БД:** hr_database  
**СУБД:** PostgreSQL  
**Метод проектирования:** Нормализация универсального отношения до 3НФ  
**Количество таблиц:** 7

## Описание таблиц

### Таблица 1: Specialties (Специальности)

**Назначение:** Справочник специальностей по образованию

| Поле | Тип данных | Ограничения |
| :--- | :--- | :--- |
| specialty_code | VARCHAR(20) | PRIMARY KEY |
| specialty_name | VARCHAR(200) | NOT NULL |

**Связи:**
- Связана с таблицей Education (один ко многим)

---

### Таблица 2: Positions (Должности)

**Назначение:** Справочник должностей с окладами

| Поле | Тип данных | Ограничения |
| :--- | :--- | :--- |
| position_code | VARCHAR(10) | PRIMARY KEY |
| position_name | VARCHAR(100) | NOT NULL |
| salary | NUMERIC(10, 2) | NOT NULL, CHECK (salary > 0) |

**Связи:**
- Связана с таблицей Employees (один ко многим)

**Ограничения CHECK:**
- `check_salary`: Оклад должен быть больше нуля

---

### Таблица 3: Employees (Сотрудники)

**Назначение:** Основная таблица с информацией о сотрудниках организации

| Поле | Тип данных | Ограничения |
| :--- | :--- | :--- |
| employee_id | SERIAL | PRIMARY KEY |
| full_name | VARCHAR(200) | NOT NULL |
| passport_number | VARCHAR(20) | NOT NULL, UNIQUE |
| birth_date | DATE | NOT NULL, CHECK (birth_date <= CURRENT_DATE - INTERVAL '18 years') |
| home_address | TEXT | NULL |
| home_phone | VARCHAR(20) | NULL |
| position_code | VARCHAR(10) | FOREIGN KEY (Positions.position_code) ON UPDATE CASCADE ON DELETE SET NULL |

**Связи:**
- Связана с таблицей Positions (многие к одному) через position_code
- Связана с таблицей Education (один ко многим)
- Связана с таблицей Qualification_Training (один ко многим)
- Связана с таблицей Rewards (один ко многим)
- Связана с таблицей Penalties (один ко многим)

**Ограничения CHECK:**
- `check_birth_date`: Возраст сотрудника должен быть не менее 18 лет

**Каскадные операции:**
- ON UPDATE CASCADE для position_code
- ON DELETE SET NULL для position_code

---

### Таблица 4: Education (Образование)

**Назначение:** Информация об образовании сотрудников

| Поле | Тип данных | Ограничения |
| :--- | :--- | :--- |
| education_id | SERIAL | PRIMARY KEY |
| employee_id | INTEGER | NOT NULL, FOREIGN KEY (Employees.employee_id) ON UPDATE CASCADE ON DELETE CASCADE |
| education_level | VARCHAR(50) | NOT NULL, CHECK (education_level IN ('Среднее', 'Среднее специальное', 'Неполное высшее', 'Высшее', 'Магистратура', 'Аспирантура')) |
| diploma_number | VARCHAR(50) | NOT NULL, UNIQUE |
| specialty_code | VARCHAR(20) | FOREIGN KEY (Specialties.specialty_code) ON UPDATE CASCADE ON DELETE SET NULL |
| qualification | VARCHAR(100) | NULL |

**Связи:**
- Связана с таблицей Employees (многие к одному) через employee_id
- Связана с таблицей Specialties (многие к одному) через specialty_code

**Ограничения CHECK:**
- `check_education_level`: Уровень образования должен быть одним из перечисленных значений

**Каскадные операции:**
- ON UPDATE CASCADE и ON DELETE CASCADE для employee_id
- ON UPDATE CASCADE и ON DELETE SET NULL для specialty_code

---

### Таблица 5: Qualification_Training (Повышение квалификации)

**Назначение:** Информация о повышении квалификации сотрудников

| Поле | Тип данных | Ограничения |
| :--- | :--- | :--- |
| training_id | SERIAL | PRIMARY KEY |
| employee_id | INTEGER | NOT NULL, FOREIGN KEY (Employees.employee_id) ON UPDATE CASCADE ON DELETE CASCADE |
| training_date | DATE | NOT NULL, CHECK (training_date <= CURRENT_DATE) |
| qualification_awarded | VARCHAR(100) | NOT NULL |
| certificate_number | VARCHAR(50) | NOT NULL, UNIQUE |

**Связи:**
- Связана с таблицей Employees (многие к одному) через employee_id

**Ограничения CHECK:**
- `check_training_date`: Дата повышения квалификации не может быть в будущем

**Каскадные операции:**
- ON UPDATE CASCADE и ON DELETE CASCADE для employee_id

---

### Таблица 6: Rewards (Поощрения)

**Назначение:** Информация о поощрениях сотрудников

| Поле | Тип данных | Ограничения |
| :--- | :--- | :--- |
| reward_id | SERIAL | PRIMARY KEY |
| employee_id | INTEGER | NOT NULL, FOREIGN KEY (Employees.employee_id) ON UPDATE CASCADE ON DELETE CASCADE |
| reward_date | DATE | NOT NULL, CHECK (reward_date <= CURRENT_DATE) |
| reward_type | VARCHAR(100) | NOT NULL |

**Связи:**
- Связана с таблицей Employees (многие к одному) через employee_id

**Ограничения CHECK:**
- `check_reward_date`: Дата поощрения не может быть в будущем

**Каскадные операции:**
- ON UPDATE CASCADE и ON DELETE CASCADE для employee_id

---

### Таблица 7: Penalties (Взыскания)

**Назначение:** Информация о взысканиях сотрудников

| Поле | Тип данных | Ограничения |
| :--- | :--- | :--- |
| penalty_id | SERIAL | PRIMARY KEY |
| employee_id | INTEGER | NOT NULL, FOREIGN KEY (Employees.employee_id) ON UPDATE CASCADE ON DELETE CASCADE |
| penalty_date | DATE | NOT NULL, CHECK (penalty_date <= CURRENT_DATE) |
| penalty_type | VARCHAR(100) | NOT NULL |

**Связи:**
- Связана с таблицей Employees (многие к одному) через employee_id

**Ограничения CHECK:**
- `check_penalty_date`: Дата взыскания не может быть в будущем

**Каскадные операции:**
- ON UPDATE CASCADE и ON DELETE CASCADE для employee_id

---

## Диаграмма связей

```
Specialties (1) ----< Education (N)
                         |
                         v
Positions (1) ----< Employees (N) >---- Qualification_Training (N)
                         |
                         +----< Rewards (N)
                         |
                         +----< Penalties (N)
```

## Сводная таблица ограничений целостности

### Первичные ключи

| Таблица | Первичный ключ | Тип |
| :--- | :--- | :--- |
| Specialties | specialty_code | VARCHAR(20) |
| Positions | position_code | VARCHAR(10) |
| Employees | employee_id | SERIAL |
| Education | education_id | SERIAL |
| Qualification_Training | training_id | SERIAL |
| Rewards | reward_id | SERIAL |
| Penalties | penalty_id | SERIAL |

### Внешние ключи

| Таблица | Поле | Ссылается на | Каскадные операции |
| :--- | :--- | :--- | :--- |
| Employees | position_code | Positions(position_code) | ON UPDATE CASCADE, ON DELETE SET NULL |
| Education | employee_id | Employees(employee_id) | ON UPDATE CASCADE, ON DELETE CASCADE |
| Education | specialty_code | Specialties(specialty_code) | ON UPDATE CASCADE, ON DELETE SET NULL |
| Qualification_Training | employee_id | Employees(employee_id) | ON UPDATE CASCADE, ON DELETE CASCADE |
| Rewards | employee_id | Employees(employee_id) | ON UPDATE CASCADE, ON DELETE CASCADE |
| Penalties | employee_id | Employees(employee_id) | ON UPDATE CASCADE, ON DELETE CASCADE |

### Уникальные ограничения

| Таблица | Поле |
| :--- | :--- |
| Employees | passport_number |
| Education | diploma_number |
| Qualification_Training | certificate_number |

### Ограничения NOT NULL

| Таблица | Поля |
| :--- | :--- |
| Specialties | specialty_code, specialty_name |
| Positions | position_code, position_name, salary |
| Employees | employee_id, full_name, passport_number, birth_date |
| Education | education_id, employee_id, education_level, diploma_number |
| Qualification_Training | training_id, employee_id, training_date, qualification_awarded, certificate_number |
| Rewards | reward_id, employee_id, reward_date, reward_type |
| Penalties | penalty_id, employee_id, penalty_date, penalty_type |

### Ограничения CHECK

| Таблица | Ограничение | Условие |
| :--- | :--- | :--- |
| Positions | check_salary | salary > 0 |
| Employees | check_birth_date | birth_date <= CURRENT_DATE - INTERVAL '18 years' |
| Education | check_education_level | education_level IN ('Среднее', 'Среднее специальное', 'Неполное высшее', 'Высшее', 'Магистратура', 'Аспирантура') |
| Qualification_Training | check_training_date | training_date <= CURRENT_DATE |
| Rewards | check_reward_date | reward_date <= CURRENT_DATE |
| Penalties | check_penalty_date | penalty_date <= CURRENT_DATE |

## Тестовые данные

База данных содержит следующие тестовые данные:
- **Specialties:** 5 записей
- **Positions:** 6 записей
- **Employees:** 6 записей
- **Education:** 7 записей (включая одного сотрудника с двумя образованиями)
- **Qualification_Training:** 4 записи
- **Rewards:** 4 записи
- **Penalties:** 2 записи

## Инструкции по развертыванию

### Создание базы данных

```bash
# Подключиться к PostgreSQL
psql -U postgres

# Создать базу данных
CREATE DATABASE hr_database
    WITH 
    ENCODING = 'UTF8'
    LC_COLLATE = 'Russian_Russia.1251'
    LC_CTYPE = 'Russian_Russia.1251'
    TEMPLATE = template0;

# Подключиться к созданной базе
\c hr_database

# Выполнить скрипты создания таблиц
\i sql/01_create_database.sql
\i sql/02_create_employees.sql
\i sql/03_create_education.sql
\i sql/04_create_qualification_training.sql
\i sql/05_create_rewards_penalties.sql

# Загрузить тестовые данные
\i sql/06_insert_test_data.sql
```

### Альтернативный способ (один скрипт)

```bash
psql -U postgres -d hr_database -f sql/00_init_all.sql
psql -U postgres -d hr_database -f sql/06_insert_test_data.sql
```

## Примеры запросов

### Получить всех сотрудников с их должностями

```sql
SELECT e.employee_id, e.full_name, p.position_name, p.salary
FROM Employees e
LEFT JOIN Positions p ON e.position_code = p.position_code
ORDER BY e.employee_id;
```

### Получить информацию об образовании сотрудников

```sql
SELECT e.full_name, ed.education_level, ed.diploma_number, 
       s.specialty_name, ed.qualification
FROM Employees e
JOIN Education ed ON e.employee_id = ed.employee_id
LEFT JOIN Specialties s ON ed.specialty_code = s.specialty_code
ORDER BY e.full_name;
```

### Получить сотрудников с поощрениями

```sql
SELECT e.full_name, r.reward_date, r.reward_type
FROM Employees e
JOIN Rewards r ON e.employee_id = r.employee_id
ORDER BY r.reward_date DESC;
```

### Получить полную информацию о сотруднике

```sql
SELECT 
    e.employee_id,
    e.full_name,
    e.passport_number,
    e.birth_date,
    e.home_address,
    e.home_phone,
    p.position_name,
    p.salary
FROM Employees e
LEFT JOIN Positions p ON e.position_code = p.position_code
WHERE e.employee_id = 1;
```
