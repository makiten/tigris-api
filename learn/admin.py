# -*- coding: utf-8 -*-
from __future__ import unicode_literals
from django.contrib import admin

from .models import (
    Tag,
    Course,
    Module,
)


admin.site.register(Tag)
admin.site.register(Course)
admin.site.register(Module)
