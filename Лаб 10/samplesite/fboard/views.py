from typing import Any, Dict, Optional, Type
from django.contrib.admin.widgets import AdminDateWidget
from django.forms.models import BaseModelForm
from django.http import HttpResponse
from django.views.generic.edit import FormView, CreateView
from django.urls import reverse_lazy
from django.shortcuts import render
from .forms import FlightForm
from .models import Flight, Vehicle

def index(request):
    return render(request, 'index.html')

class FlightFormView(FormView):
    template_name = 'flightList.html'
    form_class = FlightForm

    def get_context_data(self, **kwargs: Any) -> Dict[str, Any]:
        context = super().get_context_data(**kwargs)
        context['flights'] = Flight.objects.all()
        return context
    
class FlightCreateView(CreateView):
    template_name = 'addFlight.html'
    form_class = FlightForm
    success_url = reverse_lazy('/flights/')
    
    def form_valid(self, form: BaseModelForm) -> HttpResponse:
        form
        return super().form_valid(form)
