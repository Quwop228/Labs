from django.http import HttpResponse
from django.shortcuts import render
from .models import Employee, Position, Specialty, Education, QualificationTraining, Reward, Penalty


def index(request):
    """Главная страница отдела кадров"""
    return render(request, 'hr/index.html')


def employee_list(request):
    """Список сотрудников - вывод через HttpResponse (как в лабораторной)"""
    s = "Список сотрудников отдела кадров:<br><br>"
    for emp in Employee.objects.select_related('position').order_by('full_name'):
        position_name = emp.position.position_name if emp.position else "Не назначена"
        salary = emp.position.salary if emp.position else "-"
        s += f"{emp.full_name} - {position_name} (оклад: {salary} руб.)<br>"
    return HttpResponse(s)


def employee_list_template(request):
    """Список сотрудников с должностями - через шаблон"""
    employees = Employee.objects.select_related('position').order_by('full_name')
    return render(request, 'hr/employee_list.html', {'employees': employees})


def education_list(request):
    """Информация об образовании сотрудников"""
    educations = Education.objects.select_related('employee', 'specialty').order_by('employee__full_name')
    return render(request, 'hr/education_list.html', {'educations': educations})


def training_list(request):
    """Повышение квалификации"""
    trainings = QualificationTraining.objects.select_related('employee').order_by('-training_date')
    return render(request, 'hr/training_list.html', {'trainings': trainings})


def reward_list(request):
    """Поощрения сотрудников"""
    rewards = Reward.objects.select_related('employee').order_by('-reward_date')
    return render(request, 'hr/reward_list.html', {'rewards': rewards})


def penalty_list(request):
    """Взыскания сотрудников"""
    penalties = Penalty.objects.select_related('employee').order_by('-penalty_date')
    return render(request, 'hr/penalty_list.html', {'penalties': penalties})


def position_list(request):
    """Справочник должностей"""
    positions = Position.objects.order_by('position_name')
    return render(request, 'hr/position_list.html', {'positions': positions})


def specialty_list(request):
    """Справочник специальностей"""
    specialties = Specialty.objects.order_by('specialty_code')
    return render(request, 'hr/specialty_list.html', {'specialties': specialties})
