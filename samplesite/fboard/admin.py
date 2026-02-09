from django.contrib import admin
from .models import Vehicle, Flight, Ticket, Category

# Register your models here.
class VehicleAdmin(admin.ModelAdmin):
    list_display = ("seats", "type")

class FlightAdmin(admin.ModelAdmin):
    list_display = ("num",  "fr",  "to",  "departure", "arrive", "vehicle")
    search_fields = ("fr", "to")

class TicketAdmin(admin.ModelAdmin):
    list_display = ("id", "full_name", "departure", "purchase", "booking", "price", "flight_num", "category")

class CategoryAdmin(admin.ModelAdmin):
    list_display = ("type", "seats", "vehicle")

admin.site.register(Vehicle, VehicleAdmin)
admin.site.register(Flight, FlightAdmin)
admin.site.register(Ticket, TicketAdmin)
admin.site.register(Category, CategoryAdmin)
