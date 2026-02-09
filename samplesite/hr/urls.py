from django.urls import path
from . import views

app_name = 'hr'

urlpatterns = [
    path('', views.index, name='index'),
    path('employees/', views.employee_list_template, name='employee_list'),
    path('employees/simple/', views.employee_list, name='employee_list_simple'),
    path('education/', views.education_list, name='education_list'),
    path('training/', views.training_list, name='training_list'),
    path('rewards/', views.reward_list, name='reward_list'),
    path('penalties/', views.penalty_list, name='penalty_list'),
    path('positions/', views.position_list, name='position_list'),
    path('specialties/', views.specialty_list, name='specialty_list'),
]
