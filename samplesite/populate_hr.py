"""
Скрипт для заполнения базы данных отдела кадров тестовыми данными.
Аналогично: Flight.objects.create(...) в лабораторной работе №8.
"""
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'samplesite.settings')
django.setup()

from hr.models import Specialty, Position, Employee, Education, QualificationTraining, Reward, Penalty

# Очистка данных (если повторный запуск)
Penalty.objects.all().delete()
Reward.objects.all().delete()
QualificationTraining.objects.all().delete()
Education.objects.all().delete()
Employee.objects.all().delete()
Position.objects.all().delete()
Specialty.objects.all().delete()

print("Заполнение справочника специальностей...")
# === Справочник специальностей (5 записей) ===
Specialty.objects.create(specialty_code='09.03.01', specialty_name='Информатика и вычислительная техника')
Specialty.objects.create(specialty_code='38.03.01', specialty_name='Экономика')
Specialty.objects.create(specialty_code='40.03.01', specialty_name='Юриспруденция')
Specialty.objects.create(specialty_code='09.03.03', specialty_name='Прикладная информатика')
Specialty.objects.create(specialty_code='38.03.02', specialty_name='Менеджмент')

print("Заполнение справочника должностей...")
# === Справочник должностей (6 записей) ===
Position.objects.create(position_code='DIR', position_name='Директор', salary=150000.00)
Position.objects.create(position_code='MGR', position_name='Менеджер', salary=80000.00)
Position.objects.create(position_code='DEV', position_name='Разработчик', salary=95000.00)
Position.objects.create(position_code='ACC', position_name='Бухгалтер', salary=70000.00)
Position.objects.create(position_code='HR', position_name='Специалист по кадрам', salary=65000.00)
Position.objects.create(position_code='LAW', position_name='Юрист', salary=75000.00)

print("Заполнение таблицы сотрудников...")
# === Сотрудники (6 записей) ===
emp1 = Employee.objects.create(
    full_name='Иванов Иван Иванович',
    passport_number='4512 123456',
    birth_date='1985-03-15',
    home_address='г. Москва, ул. Ленина, д. 10, кв. 5',
    home_phone='+7-495-123-45-67',
    position=Position.objects.get(position_code='DIR')
)
emp2 = Employee.objects.create(
    full_name='Петрова Мария Сергеевна',
    passport_number='4513 234567',
    birth_date='1990-07-22',
    home_address='г. Москва, ул. Пушкина, д. 20, кв. 12',
    home_phone='+7-495-234-56-78',
    position=Position.objects.get(position_code='MGR')
)
emp3 = Employee.objects.create(
    full_name='Сидоров Петр Алексеевич',
    passport_number='4514 345678',
    birth_date='1988-11-30',
    home_address='г. Москва, ул. Гоголя, д. 15, кв. 8',
    home_phone='+7-495-345-67-89',
    position=Position.objects.get(position_code='DEV')
)
emp4 = Employee.objects.create(
    full_name='Козлова Анна Дмитриевна',
    passport_number='4515 456789',
    birth_date='1992-05-18',
    home_address='г. Москва, ул. Чехова, д. 25, кв. 3',
    home_phone='+7-495-456-78-90',
    position=Position.objects.get(position_code='ACC')
)
emp5 = Employee.objects.create(
    full_name='Смирнов Алексей Викторович',
    passport_number='4516 567890',
    birth_date='1987-09-10',
    home_address='г. Москва, ул. Толстого, д. 30, кв. 15',
    home_phone='+7-495-567-89-01',
    position=Position.objects.get(position_code='DEV')
)
emp6 = Employee.objects.create(
    full_name='Новикова Елена Павловна',
    passport_number='4517 678901',
    birth_date='1995-02-28',
    home_address='г. Москва, ул. Достоевского, д. 5, кв. 7',
    home_phone='+7-495-678-90-12',
    position=Position.objects.get(position_code='HR')
)

print("Заполнение таблицы образования...")
# === Образование (7 записей) ===
Education.objects.create(employee=emp1, education_level='Высшее', diploma_number='ВСГ 1234567',
                         specialty=Specialty.objects.get(specialty_code='38.03.02'), qualification='Менеджер')
Education.objects.create(employee=emp2, education_level='Высшее', diploma_number='ВСГ 2345678',
                         specialty=Specialty.objects.get(specialty_code='38.03.01'), qualification='Экономист')
Education.objects.create(employee=emp3, education_level='Высшее', diploma_number='ВСГ 3456789',
                         specialty=Specialty.objects.get(specialty_code='09.03.01'), qualification='Инженер-программист')
Education.objects.create(employee=emp3, education_level='Магистратура', diploma_number='ВМА 1111111',
                         specialty=Specialty.objects.get(specialty_code='09.03.03'), qualification='Магистр прикладной информатики')
Education.objects.create(employee=emp4, education_level='Высшее', diploma_number='ВСГ 4567890',
                         specialty=Specialty.objects.get(specialty_code='38.03.01'), qualification='Экономист-бухгалтер')
Education.objects.create(employee=emp5, education_level='Высшее', diploma_number='ВСГ 5678901',
                         specialty=Specialty.objects.get(specialty_code='09.03.01'), qualification='Инженер-программист')
Education.objects.create(employee=emp6, education_level='Высшее', diploma_number='ВСГ 6789012',
                         specialty=Specialty.objects.get(specialty_code='38.03.02'), qualification='Менеджер по персоналу')

print("Заполнение таблицы повышения квалификации...")
# === Повышение квалификации (4 записи) ===
QualificationTraining.objects.create(employee=emp1, training_date='2023-06-15',
                                     qualification_awarded='Управление проектами', certificate_number='ПК-2023-001')
QualificationTraining.objects.create(employee=emp2, training_date='2023-09-20',
                                     qualification_awarded='Финансовый анализ', certificate_number='ПК-2023-002')
QualificationTraining.objects.create(employee=emp3, training_date='2024-01-10',
                                     qualification_awarded='Современные технологии разработки ПО', certificate_number='ПК-2024-001')
QualificationTraining.objects.create(employee=emp5, training_date='2024-03-15',
                                     qualification_awarded='Архитектура микросервисов', certificate_number='ПК-2024-002')

print("Заполнение таблицы поощрений...")
# === Поощрения (4 записи) ===
Reward.objects.create(employee=emp1, reward_date='2023-12-25', reward_type='Премия за выполнение годового плана')
Reward.objects.create(employee=emp3, reward_date='2024-03-08', reward_type='Благодарность за успешную реализацию проекта')
Reward.objects.create(employee=emp2, reward_date='2024-05-01', reward_type='Премия ко Дню труда')
Reward.objects.create(employee=emp5, reward_date='2024-06-15', reward_type='Благодарность за наставничество')

print("Заполнение таблицы взысканий...")
# === Взыскания (2 записи) ===
Penalty.objects.create(employee=emp4, penalty_date='2024-02-10', penalty_type='Замечание за опоздание')
Penalty.objects.create(employee=emp6, penalty_date='2024-04-20', penalty_type='Выговор за нарушение трудовой дисциплины')

print()
print("=" * 60)
print("Тестовые данные успешно загружены!")
print("=" * 60)
print(f"Специальностей: {Specialty.objects.count()}")
print(f"Должностей: {Position.objects.count()}")
print(f"Сотрудников: {Employee.objects.count()}")
print(f"Записей об образовании: {Education.objects.count()}")
print(f"Записей о повышении квалификации: {QualificationTraining.objects.count()}")
print(f"Поощрений: {Reward.objects.count()}")
print(f"Взысканий: {Penalty.objects.count()}")
