from django.db import models

# Create your models here.

class Vehicle(models.Model):
    seats = models.IntegerField(verbose_name="Общее количество мест")
    type = models.CharField(max_length=30, verbose_name="Тип", primary_key=True)

    class Meta:
        verbose_name_plural = "Транспортные средства"
        verbose_name = "Транспортное средство"

class Flight(models.Model):
    num = models.IntegerField(primary_key=True, verbose_name="Номер")
    fr = models.CharField(max_length=40, verbose_name="Пункт отправления")
    to = models.CharField(max_length=40, verbose_name="Пункт назначения")
    departure = models.DateTimeField(auto_now=False, db_index=True, verbose_name="Время отправления")
    arrive = models.DateTimeField(auto_now=False, db_index=True, verbose_name="Время прибытия")
    vehicle = models.ForeignKey(Vehicle, on_delete=models.PROTECT, verbose_name="Тип транспортного средства")

    class Meta:
        verbose_name_plural = "Рейсы"
        verbose_name = "Рейс"

class Ticket(models.Model):
    id = models.IntegerField(primary_key=True, verbose_name="Уникальный номер пассажира")
    full_name = models.CharField(max_length=40, verbose_name="ФИО")
    departure = models.DateTimeField(auto_now=False, db_index=True, verbose_name="Дата и время отправления")
    purchase = models.DateTimeField(auto_now=False, db_index=True, verbose_name="Дата и время продажи")
    booking = models.DateTimeField(auto_now=False, db_index=True, verbose_name="Дата и время бронирования")
    price = models.DecimalField(max_digits=5, decimal_places=2, verbose_name="Стоимость")
    flight_num = models.ForeignKey(Flight, on_delete=models.PROTECT, verbose_name="Номер рейса")
    category = models.CharField(max_length=15, verbose_name="Тип категории")

    class Meta:
        verbose_name_plural = "Билеты"
        verbose_name = "Билет"

class Category(models.Model):
    type = models.CharField(max_length=15, verbose_name="Тип")
    seats = models.IntegerField(verbose_name="Количество мест данной категории")
    vehicle = models.ForeignKey(Vehicle, on_delete=models.PROTECT, verbose_name="Тип транспортного средства")

    class Meta:
        verbose_name_plural = "Категории"
        verbose_name = "Категория"
        constraints = [
            models.UniqueConstraint(
                fields=["type", "vehicle"], name="primary_key"
            )
        ]
