from django.contrib import admin
from addressbook.models import *

admin.site.register(EntryLabel)
admin.site.register(Entry)
admin.site.register(Person)