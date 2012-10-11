# coding: utf-8
from django.contrib import admin
from oboevsky.models import *

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
				'fields': ['categories', 'producer', 'materials', 'texture', 'colour'],
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