# -*- encoding: utf-8 -*-

from django.contrib import admin
from oboevsky.models import *
from wysiwyg import WidgetWYSIWYG

class WallpaperAdmin(admin.ModelAdmin):
	list_display = ['id', 'sku', 'title', 'producer', 'get_first_category_breadcrumps', 'top_sells', 'on_clearance', 'new', 'visible', 'priority']
	horizontal_filter = ('categories', 'materials', 'info_blocks')
	readonly_fields = ('created', 'modified')
	filter_horizontal = ('categories', 'materials', 'texture', 'info_blocks')
	fieldsets = [
		(None, {
				'fields': ['sku', 'title', 'url', 'short_desc', 'long_desc', 'price']
			}
		),
		('Характеристики товара', {
				'fields': ['categories', 'producer', 'sizes', 'materials', 'texture', 'colour'],
				'classes': []#['collapse']
			}
		),
		('Особенности отображения', {
				'fields': ['template', 'info_blocks'],
				'classes': []#['collapse']
			}
		),
		('Маркетология', {
				'fields': ['top_sells', 'on_clearance', 'new', 'quantity'],
				'classes': []#['collapse']
			}
		),
		('Системные характеристики', {
				'fields': ['priority', 'visible'],
				'classes': []#['collapse']
			}
		)
	]
	inlines = [PictureInline,]
	save_as = True


class WallpaperSizeAdmin(admin.ModelAdmin):
	list_display = ['__unicode__', 'url', 'visible', 'priority']
	horizontal_filter = ('info_blocks',)
	readonly_fields = ('created', 'modified')
	filter_horizontal = ('info_blocks',)
	fieldsets = [
		(None, {
				'fields': ['length', 'height', 'url', 'short_desc', 'long_desc']
			}
		),
		('Особенности отображения', {
				'fields': ['template', 'info_blocks'],
				'classes': []#['collapse']
			}
		),
		('Системные характеристики', {
				'fields': ['priority', 'visible'],
				'classes': []#['collapse']
			}
		)
	]
	save_as = True

class CustomerAdmin(admin.ModelAdmin):
    readonly_fields=('user', 'first_name', 'second_name', 'surname', 'email',)
    # TODO: fieldsets

admin.site.register( Producer,   ProducerAdmin )
admin.site.register( Category,   CategoryAdmin )
admin.site.register( Picture,    PictureAdmin )
admin.site.register( Texture,    TextureAdmin )
admin.site.register( Material,   MaterialAdmin )
admin.site.register( Template,   TemplateAdmin )
admin.site.register( iBlock, 	 iBlockAdmin )
admin.site.register( Country, 	 CountryAdmin )
admin.site.register( PromoCampain, 	 PromoCampainAdmin )
admin.site.register( Wallpaper,  WallpaperAdmin )
admin.site.register( WallpaperSize,  WallpaperSizeAdmin )
admin.site.register( Customer, CustomerAdmin )
admin.site.register( Order )

from django.contrib.flatpages.models import FlatPage
from django.contrib.flatpages.admin import FlatPageAdmin as FlatPageAdminOld

class FlatPageAdmin(FlatPageAdminOld):
    formfield_overrides = {
        models.TextField: {'widget': WidgetWYSIWYG},
    }

admin.site.unregister(FlatPage)
admin.site.register(FlatPage, FlatPageAdmin)