from django.db import models
from django.core.exceptions import ObjectDoesNotExist
from django.db.models.signals import pre_delete


# Create your models here.

class Model(models.Model):
    # Allow customization for base behavior here
    #deleted = models.BooleanField(default=False)
    
    def delete(self):
        self.delete_related()
        super(Model, self).delete()
        
    def delete_related(self):
        pass

    class Meta:
        abstract = True


class Person(Model):
    firstname =     models.CharField(max_length=100)
    middlename =    models.CharField(max_length=100, blank=True)
    surname =       models.CharField(max_length=100)
    secondsurname =       models.CharField(max_length=100, blank=True)
    email =         models.EmailField(blank=True)

    def delete_related(self):
        self.entry_set.clear()

    def __unicode__(self):
        return "%s %s" % (self.name, self.surname)  


class EntryLabel(Model):
    text =  models.CharField(max_length=100)
    
    def delete_related(self):
        self.entry_set.clear()


class Entry(Model):
    label =     models.ForeignKey(EntryLabel)
    person =    models.ForeignKey(Person)
    data =      models.TextField(blank=True, null=True)


# GAE hack
# For deletions through the admin to work cascade properly
def delete_related(sender, **kwargs):
    kwargs["instance"].delete_related()


pre_delete.connect(delete_related, sender=Person)