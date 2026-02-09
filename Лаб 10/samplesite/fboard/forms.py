from django.forms import ModelForm, DateInput, DateTimeInput
from django.contrib.admin import widgets    
from .models import Flight

class FlightForm(ModelForm):
    class Meta:
        model = Flight
        fields = ('num', 'fr', 'to', 'departure', 'arrive', 'vehicle')
        widgets = {
            'departure': DateTimeInput(attrs={'type': 'datetime-local'}),
            'arrive': DateTimeInput(attrs={'type': 'datetime-local'}),
        }
            
        
