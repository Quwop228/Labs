from django.db import models


class Specialty(models.Model):
    specialty_code = models.CharField(max_length=20, primary_key=True, verbose_name="Код специальности")
    specialty_name = models.CharField(max_length=200, verbose_name="Наименование специальности")

    class Meta:
        verbose_name = "Специальность"
        verbose_name_plural = "Специальности"

    def __str__(self):
        return f"{self.specialty_code} - {self.specialty_name}"


class Position(models.Model):
    position_code = models.CharField(max_length=10, primary_key=True, verbose_name="Код должности")
    position_name = models.CharField(max_length=100, verbose_name="Наименование должности")
    salary = models.DecimalField(max_digits=10, decimal_places=2, verbose_name="Должностной оклад")

    class Meta:
        verbose_name = "Должность"
        verbose_name_plural = "Должности"

    def __str__(self):
        return f"{self.position_code} - {self.position_name}"


class Employee(models.Model):
    full_name = models.CharField(max_length=200, verbose_name="ФИО сотрудника")
    passport_number = models.CharField(max_length=20, unique=True, verbose_name="Номер паспорта")
    birth_date = models.DateField(verbose_name="Дата рождения")
    home_address = models.TextField(null=True, blank=True, verbose_name="Домашний адрес")
    home_phone = models.CharField(max_length=20, null=True, blank=True, verbose_name="Домашний телефон")
    position = models.ForeignKey(
        Position,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        verbose_name="Должность",
        related_name="employees"
    )

    class Meta:
        verbose_name = "Сотрудник"
        verbose_name_plural = "Сотрудники"

    def __str__(self):
        return self.full_name


class Education(models.Model):
    EDUCATION_LEVELS = [
        ('Среднее', 'Среднее'),
        ('Среднее специальное', 'Среднее специальное'),
        ('Неполное высшее', 'Неполное высшее'),
        ('Высшее', 'Высшее'),
        ('Магистратура', 'Магистратура'),
        ('Аспирантура', 'Аспирантура'),
    ]

    employee = models.ForeignKey(
        Employee,
        on_delete=models.CASCADE,
        verbose_name="Сотрудник",
        related_name="educations"
    )
    education_level = models.CharField(max_length=50, choices=EDUCATION_LEVELS, verbose_name="Уровень образования")
    diploma_number = models.CharField(max_length=50, unique=True, verbose_name="Номер диплома")
    specialty = models.ForeignKey(
        Specialty,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        verbose_name="Специальность",
        related_name="educations"
    )
    qualification = models.CharField(max_length=100, null=True, blank=True, verbose_name="Квалификация")

    class Meta:
        verbose_name = "Образование"
        verbose_name_plural = "Образование"

    def __str__(self):
        return f"{self.employee.full_name} - {self.education_level} ({self.diploma_number})"


class QualificationTraining(models.Model):
    employee = models.ForeignKey(
        Employee,
        on_delete=models.CASCADE,
        verbose_name="Сотрудник",
        related_name="trainings"
    )
    training_date = models.DateField(verbose_name="Дата повышения квалификации")
    qualification_awarded = models.CharField(max_length=100, verbose_name="Присвоена квалификация")
    certificate_number = models.CharField(max_length=50, unique=True, verbose_name="Номер свидетельства")

    class Meta:
        verbose_name = "Повышение квалификации"
        verbose_name_plural = "Повышение квалификации"

    def __str__(self):
        return f"{self.employee.full_name} - {self.qualification_awarded}"


class Reward(models.Model):
    employee = models.ForeignKey(
        Employee,
        on_delete=models.CASCADE,
        verbose_name="Сотрудник",
        related_name="rewards"
    )
    reward_date = models.DateField(verbose_name="Дата поощрения")
    reward_type = models.CharField(max_length=100, verbose_name="Вид поощрения")

    class Meta:
        verbose_name = "Поощрение"
        verbose_name_plural = "Поощрения"

    def __str__(self):
        return f"{self.employee.full_name} - {self.reward_type}"


class Penalty(models.Model):
    employee = models.ForeignKey(
        Employee,
        on_delete=models.CASCADE,
        verbose_name="Сотрудник",
        related_name="penalties"
    )
    penalty_date = models.DateField(verbose_name="Дата взыскания")
    penalty_type = models.CharField(max_length=100, verbose_name="Вид взыскания")

    class Meta:
        verbose_name = "Взыскание"
        verbose_name_plural = "Взыскания"

    def __str__(self):
        return f"{self.employee.full_name} - {self.penalty_type}"
