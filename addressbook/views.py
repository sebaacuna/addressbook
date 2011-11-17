# Create your views here.
from django.http import HttpResponse
from django.shortcuts import render_to_response
from django.core.urlresolvers import reverse
from django import forms
from addressbook.models import Image
from django.template import RequestContext

class UploadForm(forms.ModelForm):
    class Meta:
        model = Image

def upload(request, path=""):
    view_url = reverse('upload')
    if request.method == 'POST':
        form = UploadForm(request.POST, request.FILES)
        image = form.save()
        return HttpResponse("{ id: '%s', 'file': '%s' }" % (image.id, image.file) )
    return HttpResponse("Something's broken")
