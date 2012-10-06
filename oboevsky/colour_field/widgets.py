from django import forms
from django.conf import settings
from django.utils.safestring import mark_safe

class ColourPickerWidget(forms.TextInput):
    def render(self, name, value, attrs=None):
        rendered = super(ColourPickerWidget, self).render(name, value, attrs)
        return rendered + mark_safe(u'''<div id="colourpicker_%(name)s" class="colourpicker"></div>
                    <script type="text/javascript">
                    $('#colourpicker_%(name)s').farbtastic('#id_%(name)s');
                    $('#id_%(name)s').focus(function(){
                        $('#colourpicker_%(name)s').show();
                    });
                    $('#id_%(name)s').blur(function(){
                        $('#colourpicker_%(name)s').hide();
                    });
                    $('#colourpicker_%(name)s').hide();
                    </script>''' % {'name' : name})
        
    class Media:
        css = {
            'all': (settings.STATIC_URL + 'colour_field/css/farbtastic.css',)
        }
        js = (
            settings.STATIC_URL + 'colour_field/js/jquery-1.4.2.js',
            settings.STATIC_URL + 'colour_field/js/farbtastic.js',
        )