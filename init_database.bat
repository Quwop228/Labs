@echo off
chcp 1251 > nul
echo Установка кодировки Windows-1251...
echo.

echo Пересоздание базы данных...
psql -U postgres -f sql\00_recreate_database.sql
echo.

echo Инициализация структуры и данных...
psql -U postgres -d hr_database -f sql\init_complete.sql
echo.

echo Готово!
pause
