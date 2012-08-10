from django.core.context_processors import csrf
from django.views.decorators.csrf import csrf_protect
from django.template import RequestContext
from django.shortcuts import render_to_response, redirect
from django.http import HttpResponse

def home(request):
    return render_to_response('index.html', {}, context_instance=RequestContext(request) )
