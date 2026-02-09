from django.contrib import admin
from .models import Specialty, Position, Employee, Education, QualificationTraining, Reward, Penalty

# Register your models here.
class SpecialtyAdmin(admin.ModelAdmin):
    list_display = ("specialty_code", "specialty_name")
    search_fields = ("specialty_code", "specialty_name")

class PositionAdmin(admin.ModelAdmin):
    list_display = ("position_code", "position_name", "salary")
    search_fields = ("position_name",)

class EmployeeAdmin(admin.ModelAdmin):
    list_display = ("id", "full_name", "passport_number", "birth_date", "home_phone", "position")
    search_fields = ("full_name", "passport_number")

class EducationAdmin(admin.ModelAdmin):
    list_display = ("employee", "education_level", "diploma_number", "specialty", "qualification")
    search_fields = ("employee__full_name", "diploma_number")

class QualificationTrainingAdmin(admin.ModelAdmin):
    list_display = ("employee", "training_date", "qualification_awarded", "certificate_number")
    search_fields = ("employee__full_name", "qualification_awarded")

class RewardAdmin(admin.ModelAdmin):
    list_display = ("employee", "reward_date", "reward_type")
    search_fields = ("employee__full_name", "reward_type")

class PenaltyAdmin(admin.ModelAdmin):
    list_display = ("employee", "penalty_date", "penalty_type")
    search_fields = ("employee__full_name", "penalty_type")

admin.site.register(Specialty, SpecialtyAdmin)
admin.site.register(Position, PositionAdmin)
admin.site.register(Employee, EmployeeAdmin)
admin.site.register(Education, EducationAdmin)
admin.site.register(QualificationTraining, QualificationTrainingAdmin)
admin.site.register(Reward, RewardAdmin)
admin.site.register(Penalty, PenaltyAdmin)
