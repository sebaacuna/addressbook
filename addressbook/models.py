from django.db import models
from django.core.exceptions import ObjectDoesNotExist
from django.db.models.signals import pre_delete


def promo_image_name(instance, filename):
    return "promo/image/%s" % (instance.name)

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


class Image(Model):
    name =          models.CharField(max_length=200)
    file =          models.FileField(upload_to=promo_image_name, blank=True, null=True)

    def __unicode__(self):
        return self.name

    def delete(self):
        self.file.delete(save=False)
        super(Image, self).delete()

class Person(Model):
    firstname =     models.CharField(max_length=100, blank=True)
    middlename =    models.CharField(max_length=100, blank=True)
    lastname =       models.CharField(max_length=100, blank=True)
    secondlastname =       models.CharField(max_length=100, blank=True)
    email =         models.EmailField(blank=True)

    def delete_related(self):
        #self.entry_set.clear()
        pass

    def __unicode__(self):
        return "%s %s" % (self.firstname, self.lastname)  


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