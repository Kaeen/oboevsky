from django import forms
from django.utils.translation import ugettext_lazy as _
import re
from widgets import ColourPickerWidget

class ColourFormField(forms.Field):
    default_error_messages = {
        'invalid':_(u'Enter a valid colour value: e.g. "#ff0022"'),
    }
    
    def __init__(self, *args, **kwargs):
        defaults = {'widget':ColourPickerWidget}
        defaults.update(kwargs)
        super(ColourFormField, self).__init__(*args, **defaults)
    
    def clean(self, value):
        super(ColourFormField, self).clean(value)
        if value == '' and not self.required:
            return u''
        
        if not re.match('#[0-9a-fA-F]{6}', value):
            raise forms.ValidationError(self.error_messages['invalid'])
        
        return value
    