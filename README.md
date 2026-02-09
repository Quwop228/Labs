# Лабораторная работа 1: База данных отдела кадров

## Описание

Проект реализует базу данных отдела кадров на PostgreSQL с применением методологии нормализации универсального отношения до третьей нормальной формы (3НФ).

## Структура проекта

```
.
├── sql/                          # SQL-скрипты
│   ├── 00_init_all.sql          # Главный скрипт инициализации
│   ├── 01_create_database.sql   # Создание справочных таблиц
│   ├── 02_create_employees.sql  # Создание таблицы сотрудников
│   ├── 03_create_education.sql  # Создание таблицы образования
│   ├── 04_create_qualification_training.sql  # Повышение квалификации
│   ├── 05_create_rewards_penalties.sql       # Поощрения и взыскания
│   └── 06_insert_test_data.sql  # Тестовые данные
├── database_structure.md         # Документация структуры БД
└── README.md                     # Этот файл
```

## Требования

- PostgreSQL 12 или выше
- Клиент psql или любой другой PostgreSQL-клиент (pgAdmin, DBeaver и т.д.)

## Установка и запуск

### Быстрый старт (рекомендуется)

```bash
# Шаг 1: Пересоздать базу данных с правильной кодировкой
psql -U postgres -f sql/00_recreate_database.sql

# Шаг 2: Инициализировать структуру и данные
psql -U postgres -d hr_database -f sql/init_complete.sql
```

### Альтернативный способ (если база уже создана)

Если база данных `hr_database` уже существует, просто выполните:

```bash
psql -U postgres -d hr_database -f sql/init_complete.sql
```

### Вариант 3: Через pgAdmin или DBeaver

1. Создайте новую базу данных `hr_database`
2. Откройте Query Tool / SQL Editor
3. Последовательно выполните содержимое файлов из папки `sql/` в указанном порядке:
   - 01_create_database.sql
   - 02_create_employees.sql
   - 03_create_education.sql
   - 04_create_qualification_training.sql
   - 05_create_rewards_penalties.sql
   - 06_insert_test_data.sql

## Проверка установки

После инициализации проверьте структуру:

```bash
psql -U postgres -d hr_database -f sql/07_verify_structure.sql
```

Или посмотрите примеры запросов:

```bash
psql -U postgres -d hr_database -f sql/08_example_queries.sql
```

## Структура базы данных

База данных состоит из 7 таблиц:

1. **Specialties** - Справочник специальностей
2. **Positions** - Справочник должностей с окладами
3. **Employees** - Основная таблица сотрудников
4. **Education** - Информация об образовании
5. **Qualification_Training** - Повышение квалификации
6. **Rewards** - Поощрения сотрудников
7. **Penalties** - Взыскания сотрудников

Подробное описание структуры см. в файле [database_structure.md](database_structure.md)

## Реализованные ограничения целостности

### Первичные ключи
- Все таблицы имеют первичные ключи (PRIMARY KEY)
- Используются SERIAL для автоинкрементных ключей

### Внешние ключи
- Все связи между таблицами реализованы через FOREIGN KEY
- Настроены каскадные операции:
  - ON UPDATE CASCADE - автоматическое обновление
  - ON DELETE CASCADE - каскадное удаление зависимых записей
  - ON DELETE SET NULL - установка NULL при удалении

### Уникальность
- Номера паспортов сотрудников (UNIQUE)
- Номера дипломов (UNIQUE)
- Номера свидетельств о повышении квалификации (UNIQUE)

### Обязательность полей (NOT NULL)
- Все ключевые поля обязательны для заполнения
- ФИО, паспорт, дата рождения сотрудника
- Даты и типы поощрений/взысканий

### Проверка значений (CHECK)
- Возраст сотрудника >= 18 лет
- Оклад > 0
- Уровень образования из перечисленного списка
- Даты событий не в будущем

## Тестовые данные

База данных содержит тестовые данные:
- 5 специальностей
- 6 должностей
- 6 сотрудников
- 7 записей об образовании
- 4 записи о повышении квалификации
- 4 поощрения
- 2 взыскания

## Примеры запросов

### Просмотр всех сотрудников с должностями

```sql
SELECT e.employee_id, e.full_name, p.position_name, p.salary
FROM Employees e
LEFT JOIN Positions p ON e.position_code = p.position_code
ORDER BY e.employee_id;
```

### Информация об образовании

```sql
SELECT e.full_name, ed.education_level, s.specialty_name, ed.qualification
FROM Employees e
JOIN Education ed ON e.employee_id = ed.employee_id
LEFT JOIN Specialties s ON ed.specialty_code = s.specialty_code
ORDER BY e.full_name;
```

### Сотрудники с поощрениями

```sql
SELECT e.full_name, r.reward_date, r.reward_type
FROM Employees e
JOIN Rewards r ON e.employee_id = r.employee_id
ORDER BY r.reward_date DESC;
```

### Проверка каскадного удаления

```sql
-- Посмотреть связанные записи сотрудника
SELECT 'Education' as table_name, COUNT(*) as count FROM Education WHERE employee_id = 1
UNION ALL
SELECT 'Qualification_Training', COUNT(*) FROM Qualification_Training WHERE employee_id = 1
UNION ALL
SELECT 'Rewards', COUNT(*) FROM Rewards WHERE employee_id = 1
UNION ALL
SELECT 'Penalties', COUNT(*) FROM Penalties WHERE employee_id = 1;

-- Удалить сотрудника (все связанные записи удалятся автоматически)
-- DELETE FROM Employees WHERE employee_id = 1;
```

## Проверка ограничений

### Проверка возраста (должна вернуть ошибку)

```sql
INSERT INTO Employees (full_name, passport_number, birth_date) 
VALUES ('Тест Тестович', '9999 999999', '2010-01-01');
-- ERROR: new row for relation "employees" violates check constraint "check_birth_date"
```

### Проверка уникальности паспорта (должна вернуть ошибку)

```sql
INSERT INTO Employees (full_name, passport_number, birth_date) 
VALUES ('Другой Человек', '4512 123456', '1990-01-01');
-- ERROR: duplicate key value violates unique constraint "employees_passport_number_key"
```

### Проверка положительности оклада (должна вернуть ошибку)

```sql
INSERT INTO Positions (position_code, position_name, salary) 
VALUES ('TEST', 'Тестовая должность', -1000);
-- ERROR: new row for relation "positions" violates check constraint "check_salary"
```

## Нормализация

База данных нормализована до 3НФ:

**1НФ:** Все атрибуты атомарны, устранены повторяющиеся группы

**2НФ:** Устранены частичные зависимости от составного ключа

**3НФ:** Устранены транзитивные зависимости:
- Наименование специальности зависит от кода → таблица Specialties
- Наименование должности и оклад зависят от кода → таблица Positions

## Автор

Лабораторная работа выполнена в рамках курса "СУБД PostgreSQL"

## Лицензия

Учебный проект
