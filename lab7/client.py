import psycopg2
from psycopg2 import Error
from psycopg2 import OperationalError
import os, re


def create_connection(db_name, db_user, db_password, db_host, db_port):
    connection = None

    connection = psycopg2.connect(
        database = db_name,
        user = db_user,
        password = db_password,
        host = db_host,
        port = db_port
    )

    print("Соединение установлено.")
    return connection


# Список сотрудников (для hr_manager)
def employeeList(connection):
    try:
        cursor = connection.cursor()
        query = "select * from employeeList"
        cursor.execute(query)
        rows = cursor.fetchall()
        print("-----+------------------------------+---------------+------------+----------------------------------------+--------------------+----------------------+----------")
        print("%5s|%30s|%15s|%12s|%40s|%20s|%22s|%10s" %("ID", "ФИО", "Паспорт", "Дата рожд.", "Адрес", "Телефон", "Должность", "Оклад"))
        print("-----+------------------------------+---------------+------------+----------------------------------------+--------------------+----------------------+----------")

        for row in rows:
            print("%5s|%30s|%15s|%12s|%40s|%20s|%22s|%10s" %(row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7]))

        cursor.close()
    except (Exception, Error) as e:
        print(e.diag.message_primary)
        connection.rollback()


# Добавление сотрудника (для hr_manager)
def addEmployee(connection):
    try:
        date_pattern = re.compile("(\d{4}-\d{2}-\d{2})")
        cursor = connection.cursor()
        name = input("Введите ФИО сотрудника: ")
        passport = input("Введите номер паспорта: ")

        birth_date = input("Введите дату рождения (yyyy-mm-dd): ")
        m = date_pattern.fullmatch(birth_date)
        while m == None:
            print("Неверный формат даты (yyyy-mm-dd).")
            birth_date = input("Введите дату рождения (yyyy-mm-dd): ")
            m = date_pattern.fullmatch(birth_date)

        address = input("Введите домашний адрес: ")
        phone = input("Введите домашний телефон: ")
        position_code = input("Введите код должности (DIR/MGR/DEV/ACC/HR/LAW): ")

        query = f"INSERT INTO \"Employees\"(full_name, passport_number, birth_date, home_address, home_phone, position_code)\nVALUES ('{name}', '{passport}', '{birth_date}', '{address}', '{phone}', '{position_code}')"
        cursor.execute(query)
        connection.commit()
        print("Сотрудник успешно добавлен.")
        cursor.close()
    except (Exception, Error) as e:
        print(e.diag.message_primary)
        connection.rollback()


# Просмотр сотрудников (для viewer)
def getEmployees(connection):
    try:
        cursor = connection.cursor()
        search = input("Введите ФИО для поиска (или пустую строку для всех): ")

        query = f"select * from getEmployees('{search}')"
        cursor.execute(query)
        rows = cursor.fetchall()

        if rows != None:
            print("-----+------------------------------+---------------+------------+----------------------------------------+--------------------+----------------------+----------")
            print("%5s|%30s|%15s|%12s|%40s|%20s|%22s|%10s" %("ID", "ФИО", "Паспорт", "Дата рожд.", "Адрес", "Телефон", "Должность", "Оклад"))
            print("-----+------------------------------+---------------+------------+----------------------------------------+--------------------+----------------------+----------")

            for row in rows:
                print("%5s|%30s|%15s|%12s|%40s|%20s|%22s|%10s" %(row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7]))

            cursor.close()
        else:
            print("Сотрудники не найдены.")

    except (Exception, Error) as e:
        print(e.diag.message_primary)
        connection.rollback()


# Добавление поощрения (для hr_manager)
def addReward(connection):
    try:
        cursor = connection.cursor()
        emp_id = input("Введите ID сотрудника: ")
        reward_type = input("Введите вид поощрения: ")

        query = f"select addReward('{emp_id}', '{reward_type}')"
        cursor.execute(query)
        connection.commit()
        print("Поощрение успешно добавлено.")

    except (Exception, Error) as e:
        print(e.diag.message_primary)
        connection.rollback()


# Добавление взыскания (для hr_manager)
def addPenalty(connection):
    try:
        cursor = connection.cursor()
        emp_id = input("Введите ID сотрудника: ")
        penalty_type = input("Введите вид взыскания: ")

        query = f"select addPenalty('{emp_id}', '{penalty_type}')"
        cursor.execute(query)
        connection.commit()
        print("Взыскание успешно добавлено.")

    except (Exception, Error) as e:
        print(e.diag.message_primary)
        connection.rollback()


# Увольнение сотрудника (для hr_manager)
def fireEmployee(connection):
    try:
        cursor = connection.cursor()
        emp_id = input("Введите ID сотрудника для увольнения: ")

        query = f"select fireEmployee('{emp_id}')"
        cursor.execute(query)
        connection.commit()
        print("Сотрудник уволен.")

    except (Exception, Error) as e:
        print(e.diag.message_primary)
        connection.rollback()


os.system("cls")
user = input("Введите логин: ")
password = input("Введите пароль: ")

try:
    connection = create_connection("hr_database", user, password, "localhost", "5432")
    op = 100
    while op != 0:
        print('\n\n1 - список сотрудников| 2 - добавление сотрудника| 3 - поиск сотрудников| 4 - добавить поощрение| 5 - добавить взыскание| 6 - увольнение| 0 - выход')
        op = input('выберите операцию:')

        match op:
            case '1':
                employeeList(connection)
            case '2':
                addEmployee(connection)
            case '3':
                getEmployees(connection)
            case '4':
                addReward(connection)
            case '5':
                addPenalty(connection)
            case '6':
                fireEmployee(connection)
            case '0':
                connection.close()
except (Exception, Error) as e:
    print(e)
