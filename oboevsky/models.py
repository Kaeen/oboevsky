# -*- coding: utf-8 -*-

import os
#from django.contrib.sitemaps import Sitemap as _Sitemap
from django.db import models
from django.contrib import admin
from django.contrib.auth.models import User
from django.utils.translation import ugettext as _
from colour_field.fields import ColourField
from django.db.models.signals import pre_save
from wysiwyg import WYSIWYGField
from .thumbs import ImageWithThumbsField

thumbnails_sizes = ((284, 185), (170, 111))
textures_sizes = ((28,28), (128,128))
flag_sizes = ((13,20),)

############################
#           Обои           #
############################

class Wallpaper(models.Model):

	# Артикул 
	sku = models.SlugField(max_length=40, null=False, unique=True, verbose_name=_(u'артикул')) # TODO: pcre validation
	# Название товара:
	title = models.CharField(max_length=120, null=False, verbose_name=_(u'название'))
	# Якорь:
	url = models.SlugField(max_length=100, null=True, unique=True, verbose_name=_(u'якорь'))
	# Короткое описание: 
	short_desc = models.CharField(max_length=200, null=True, verbose_name=_(u'короткое описание'))
	# Полное описание: 
	long_desc = WYSIWYGField(null=True, verbose_name=_(u'длинное описание'))
	# Цена:
	price = models.DecimalField(max_digits=12, decimal_places=2, blank=False, null=True, verbose_name=_(u'цена'))

	# Категории товара: 
	categories = models.ManyToManyField(
		'Category',
		related_name='wallpapers',
		null=True,
		blank=True,
		default=None,
		verbose_name=_(u'категории товара')
	)
	# Производитель: 
	producer = models.ForeignKey(
		'Producer', 
		on_delete=models.SET_NULL,
		null=True,
		blank=True,
		default=None,
		related_name='wallpapers',
		verbose_name=_(u'производитель')
	)
	# Размеры: 
	sizes = models.ManyToManyField(
		'WallpaperSize', 
		blank=True, 
		null=True,
		default=None,
		related_name='wallpapers',
		verbose_name=_(u'размеры')
	)
	# Материалы: 
	materials = models.ManyToManyField(
		'Material', 
		null=True,
		blank=True,
		default=None,
		related_name='wallpapers',
		verbose_name=_(u'материалы')
	)
	# Текстуры:
	texture = models.ManyToManyField(
		'Texture', 
		null=True,
		blank=True,
		default=None,
		related_name='wallpapers',
		verbose_name=_(u'текстуры')
	)
	# Цвет:
	colour = ColourField(blank=True, null=True, verbose_name=_(u'цвет'))

	# Изображения товара: 
	images = models.ManyToManyField(
		'Picture', 
		null=True,
		blank=True,
		default=None,
		related_name='wallpaper',
		verbose_name=_(u'изображения товара')
	)

	# Шаблон: 
	template = models.ForeignKey(
		'Template', 
		on_delete=models.SET_NULL,
		blank=True, 
		null=True, 
		default=None,
		related_name='wallpapers',
		verbose_name=_(u'шаблон')
	)
	# Информационные блоки: 
	info_blocks = models.ManyToManyField(
		'iBlock', 
		blank=True, 
		null=True,
		default=None,
		related_name='wallpapers',
		verbose_name=_(u'информационные блоки')
	)

	# Топ продаж:
	top_sells = models.BooleanField(verbose_name=_(u'топ продаж'))
	# Распродажа: 
	on_clearance = models.BooleanField(verbose_name=_(u'распродажа'))
	# Новинка: 
	new = models.BooleanField(verbose_name=_(u'новинка'))
	# Количество: 
	quantity = models.IntegerField(blank=True, null=True, verbose_name=_(u'количество в наличии'))

	# Приоритет отображения: 
	priority = models.PositiveIntegerField(blank=True, default=0, verbose_name=u'приоритет отображения')
	# Метки времени: 
	created    = models.DateTimeField(auto_now_add=True, editable=False, blank=True, verbose_name=u'дата создания')
	modified   = models.DateTimeField(auto_now=True, auto_now_add=True, blank=True, verbose_name=u'дата последнего изменения')
	# Видимость: 
	visible    = models.BooleanField(default=False , verbose_name=u'видимость')

	def get_shortest_category_len(self):
		""" Убрать, это пиздец """
		for l in [len(x.get_breadcrumps_list()) for x in self.categories]:
			if not shortest or l < shortest:
				shortest = l
		return shortest or 0

	def get_shortest_category(self):
		""" Убрать, это пиздец """
		for c in [x.get_breadcrumps_list() for x in self.categories]:
			if not shortest or len(c) < shortest:
				shortest = len(c)
				result = c
		return result or ''

	def get_first_category(self):
		""" Возвращает самую приоритетную категорию.
		"""
		return self.categories.order_by('-parents_num')[0] if len(self.categories.all())>0 else None
	get_first_category.short_description = u'Категория с наивысшим приоритетом'

	def get_first_category_breadcrumps(self):
		""" Возвращает самую приоритетную категорию.
		"""
		return self.categories.order_by('-parents_num')[0].get_breadcrumps() if len(self.categories.order_by('-parents_num'))>0 else None
	get_first_category_breadcrumps.short_description = u'Категория с наивысшим приоритетом'

	def __unicode__(self):
		return self.title if self.visible else u'{0} (скрыт)'.format(self.title)

	def get_absolute_url(self):
		return u'/wallpaper/'+self.url

	def get_first_image(self):
		return self.images.all()[0] if self.images.all() else None

	def actual_price(self):
		campains = self.promo_campains
		# Выбираем самую низкую цену из всех промок:
		actual_price = self.price
		for c in campains:
			formula = c.wallpaper_price_formula
			for k,v in (
				# ПЕРЕМЕННЫЕ, ДОСТУПНЫЕ В ФОРМУЛАХ
				('WALLPAPER_PRICE', self.price),
			):
				formula.replace( k, v )
			if actual_price > eval(formula):
				actual_price = eval(formula)

		return actual_price

	def materials_as_text(self):
		t = u''
		for x in self.materials.all():
			if x.visible:
				t += x.title if t == '' else u', ' + x.title.lower()
		return t

	def categories_as_text(self):
		t = u''
		for x in self.categories.all():
			if x.visible:
				t += x.title if t == '' else u', ' + x.title.lower()
		return t

	def producer_as_text(self):
		return u'<img alt="{0}" align="absmiddle" src="{1}" />&nbsp;{2}'.format(self.producer.country.short_desc, self.producer.country.pic.url_13x20, self.producer.title)

	class Meta:
		verbose_name = _(u'обои')
		verbose_name_plural = _(u'обои')
		ordering = ['priority',]


############################
#      Размеры обоев       #
############################

class WallpaperSize(models.Model):
	# Якорь:
	url = models.SlugField(max_length=100, null=True, unique=True, verbose_name=_(u'якорь'))
	# Длина:
	length = models.DecimalField(max_digits=5, decimal_places=2, verbose_name=u'длина')
	# Высота:
	height = models.DecimalField(max_digits=5, decimal_places=2, verbose_name=u'высота')
	# Короткое описание: 
	short_desc = models.CharField(max_length=200, null=True, verbose_name=u'короткое описание')
	# Полное описание: 
	long_desc = WYSIWYGField(null=True, verbose_name=u'длинное описание')

	# Шаблон: 
	template = models.ForeignKey(
		'Template', 
		on_delete=models.SET_NULL,
		blank=True, 
		null=True, 
		default=None,
		related_name='wallpapersizes',
		verbose_name=u'шаблон'
	)
	# Информационные блоки: 
	info_blocks = models.ManyToManyField(
		'iBlock', 
		blank=True, 
		null=True,
		default=None,
		related_name='wallpapersizes',
		verbose_name=u'информационные блоки'
	)

	# Приоритет отображения: 
	priority = models.PositiveIntegerField(blank=True, default=0, verbose_name=u'приоритет отображения')
	# Метки времени: 
	created    = models.DateTimeField(auto_now_add=True, editable=False, blank=True, verbose_name=u'дата создания')
	modified   = models.DateTimeField(auto_now=True, auto_now_add=True, blank=True, verbose_name=u'дата последнего изменения')
	# Видимость: 
	visible    = models.BooleanField(default=False , verbose_name=u'видимость')

	def __unicode__(self):
		return u'{0}x{1}'.format(self.length, self.height)

	def get_absolute_url(self):
		return u'/size/'+self.url

	class Meta:
		verbose_name = _(u'размер обоев')
		verbose_name_plural = _(u'размеры обоев')
		ordering = ['priority',]




############################
#      Производители       #
############################

class Producer(models.Model):
	# Название:
	title = models.CharField(max_length=120, null=False, verbose_name=_(u'название'))
	# Якорь:
	url = models.SlugField(max_length=100, null=True, unique=True, verbose_name=_(u'якорь'))
	# Короткое описание: 
	short_desc = models.CharField(max_length=200, null=True, verbose_name=_(u'короткое описание'))
	# Полное описание: 
	long_desc = WYSIWYGField(null=True, verbose_name=_(u'длинное описание'))
	# Страна:
	country = models.ForeignKey('Country', blank=False, verbose_name=_(u'страна'))
	# Шаблон: 
	template = models.ForeignKey('Template', blank=True, null=True, verbose_name=_(u'шаблон'))
	# Информационные блоки: 
	info_blocks = models.ManyToManyField('iBlock', blank=True, verbose_name=_(u'информационные блоки'))
	# Изображение: 
	logo = models.ImageField(upload_to='producers/', verbose_name=u'логотип') # TODO: WIDTH, HEIGHT

	# Приоритет отображения: 
	priority = models.PositiveIntegerField(blank=True, default=0, verbose_name=u'приоритет отображения')
	# Метки времени: 
	created  = models.DateTimeField(auto_now_add=True, editable=False, blank=True, verbose_name=u'дата создания')
	modified = models.DateTimeField(auto_now=True, auto_now_add=True, blank=True, verbose_name=u'дата последнего изменения')
	# Видимость: 
	visible  = models.BooleanField(default=False , verbose_name=u'видимость')

	class Meta:
		verbose_name = _(u'производитель')
		verbose_name_plural = _(u'производители')

	def __unicode__(self):
	    return self.title if self.visible else u'{0} (скрыт)'.format(self.title)

	def get_absolute_url(self):
		return u'/producer/'+self.url


class ProducerAdmin(admin.ModelAdmin): 
	readonly_fields = ('created', 'modified')
	list_display = ['title', 'country', 'url', 'priority', 'visible']


############################
#          Страны          #
############################

class Country(models.Model):
	# Название:
	title = models.CharField(max_length=120, null=False, verbose_name=_(u'название'))
	# Короткое описание: 
	short_desc = models.CharField(max_length=200, null=True, verbose_name=_(u'короткое описание'))
	# Полное описание: 
	long_desc = WYSIWYGField(null=True, verbose_name=_(u'длинное описание'))
	# Якорь:
	url = models.SlugField(max_length=100, null=True, unique=True, verbose_name=_(u'якорь'))
	# Пиктограмма страны: 
	pic = ImageWithThumbsField(upload_to='countries/', verbose_name=_(u'пиктограмма страны'), sizes=flag_sizes)
	# Код:
	code = models.SlugField(max_length=3, null=False, verbose_name=_(u'кодовое обозначение'))
	# Шаблон: 
	template = models.ForeignKey('Template', blank=True, null=True, verbose_name=_(u'шаблон'))
	# Информационные блоки: 
	info_blocks = models.ManyToManyField('iBlock', blank=True, verbose_name=_(u'информационные блоки'))

	# Приоритет отображения: 
	priority   = models.PositiveIntegerField(blank=True, default=0, verbose_name=u'приоритет отображения')
	# Метки времени: 
	created    = models.DateTimeField(auto_now_add=True, editable=False, blank=True, verbose_name=u'дата создания')
	modified   = models.DateTimeField(auto_now=True, auto_now_add=True, blank=True, verbose_name=u'дата последнего изменения')
	# Видимость: 
	visible    = models.BooleanField(default=False , verbose_name=u'видимость')

	class Meta:
		verbose_name = _(u'страна')
		verbose_name_plural = _(u'страны')

	def __unicode__(self):
	    return self.title if self.visible else u'{0} (скрыт)'.format(self.title)

	def get_absolute_url(self):
		return u'/country/'+self.url

	def get_html(self):
		import os
		return u'''
			<a href="{0}"><img src="/media/countries/{1}" align="absmiddle" height="13px" width="20px" /></a>&nbsp;<a href="{0}">{2}</a>
			'''.format(self.get_absolute_url(), os.path.split(self.pic.path)[1], self.title.strip()) # TODO HEIGHT WIDTH
	get_html.short_description = u'Изображение'
	get_html.allow_tags = True

	def get_admin_html(self):
		import os
		return u'''<img src="/media/countries/{0}" align="absmiddle" height="13px" width="20px" />&nbsp;{1}'''.format(
			os.path.split(self.pic.path)[1], self.title
		) # TODO HEIGHT WIDTH
	get_admin_html.short_description = u'Изображение'
	get_admin_html.allow_tags = True

class CountryAdmin(admin.ModelAdmin):
	readonly_fields = ('created', 'modified')
	list_display = ['get_admin_html', 'url', 'code', 'priority', 'visible']
	filter_horizontal = ['info_blocks']


############################
#        Категории         #
############################

class Category(models.Model):
	# Название товара:
	title = models.CharField(max_length=120, null=False, verbose_name=_(u'название'))
	# Родительский каталог:
	parent = models.ForeignKey('self', null=True, blank=True, verbose_name=_(u'родительский каталог'))
	# Короткое описание: 
	short_desc = models.CharField(max_length=200, null=True, verbose_name=_(u'короткое описание'))
	# Полное описание: 
	long_desc = WYSIWYGField(null=True, verbose_name=_(u'длинное описание'))
	# Якорь:
	url = models.SlugField(max_length=100, null=True, unique=True, verbose_name=_(u'якорь'))
	# Шаблон: 
	template = models.ForeignKey('Template', blank=True, null=True, verbose_name=_(u'шаблон'))
	# Информационные блоки: 
	info_blocks = models.ManyToManyField(
		'iBlock', 
		blank=True, 
		verbose_name=_(u'информационные блоки')
	)

	# Количество родителей:
	parents_num = models.IntegerField(null=True, blank=True, editable=False, verbose_name=u'количество предков')

	# Приоритет отображения: 
	priority = models.PositiveIntegerField(blank=True, default=0, verbose_name=u'приоритет отображения')
	# Метки времени: 
	created    = models.DateTimeField(auto_now_add=True, editable=False, blank=True, verbose_name=u'дата создания')
	modified   = models.DateTimeField(auto_now=True, auto_now_add=True, blank=True, verbose_name=u'дата последнего изменения')
	# Видимость: 
	visible    = models.BooleanField(default=False , verbose_name=u'видимость')

	class Meta:
		verbose_name = _(u'категория товаров')
		verbose_name_plural = _(u'категории товаров')

	def __unicode__(self):
	    return self.title if self.visible else u'{0} (скрыт)'.format(self.title)

	def get_breadcrumps_list(self):
		""" 
		"""
		return self.get_parents(include_self=True)

	def get_breadcrumps(self):
		""" Получаем хлебные крошки.
		"""
		return u' — '.join( [x.title for x in self.get_breadcrumps_list()] )
	get_breadcrumps.short_description = u'Путь'

	def get_absolute_url(self):
		return u'/catalog/'+self.url

	def get_parents(self, include_self=False):
		""" Получить все родительские объекты.
		"""
		if not include_self:
			objects = Category.objects.raw("""
				WITH RECURSIVE parent(id, title, parent_id) AS (
				  SELECT id, title, parent_id FROM oboevsky_category WHERE id = %s
				  UNION
				    SELECT oboevsky_category.id, oboevsky_category.title, oboevsky_category.parent_id FROM oboevsky_category, parent
				    WHERE parent.parent_id = oboevsky_category.id)
				SELECT * FROM parent;""", [self.parent_id])[:]
		else:
			objects = Category.objects.raw("""
				WITH RECURSIVE parent(id, title, parent_id) AS (
				  SELECT id, title, parent_id FROM oboevsky_category WHERE id = %s
				  UNION
				    SELECT oboevsky_category.id, oboevsky_category.title, oboevsky_category.parent_id FROM oboevsky_category, parent
				    WHERE parent.parent_id = oboevsky_category.id)
				SELECT * FROM parent;""", [self.id])[:]
			objects.reverse()
		return objects

	def get_parent(self):
		""" Получить родительский объект.
		"""
		return self.parent or None

	def get_children(self, include_self=False):
		""" Получить все дочерние объекты.
		"""
		if not include_self:
			objects = Category.objects.raw("""
				WITH RECURSIVE child(id, title, parent_id) AS (
				  SELECT id, title, parent_id FROM oboevsky_category WHERE id = %s
				  UNION
				    SELECT oboevsky_category.id, oboevsky_category.title, oboevsky_category.parent_id FROM oboevsky_category, child
				    WHERE child.id = oboevsky_category.parent_id)
				SELECT * FROM child;""", [self.id])
		else:
			objects = Category.objects.raw("""
				WITH RECURSIVE child(id, title, parent_id) AS (
				  SELECT id, title, parent_id FROM oboevsky_category WHERE id = %s
				  UNION
				    SELECT oboevsky_category.id, oboevsky_category.title, oboevsky_category.parent_id FROM oboevsky_category, child
				    WHERE child.id = oboevsky_category.parent_id)
				SELECT * FROM child;""", [self.parent_id])
		return objects[:]

	def save(self):
		self.parents_num = len(self.get_parents())
		#TODO: mark all children and all child wallpapers not visible, too?
		super(Category, self).save()


class CategoryAdmin(admin.ModelAdmin):
	list_display = ['get_breadcrumps', 'url', 'priority', 'visible']
	readonly_fields = ('parents_num', 'created', 'modified')
	filter_horizontal = ('info_blocks',)


############################
#         Картинки         #
############################

class Picture(models.Model):
	# Название товара:
	title = models.CharField(max_length=120, null=False, verbose_name=_(u'название'))
	# Короткое описание: 
	short_desc = models.CharField(max_length=200, null=True, verbose_name=_(u'короткое описание'))
	# Полное описание: 
	long_desc = WYSIWYGField(null=True, verbose_name=_(u'длинное описание'))
	# Изображение: 
	image = ImageWithThumbsField(upload_to='pictures/', verbose_name=u'изображение', sizes=thumbnails_sizes) # TODO: WIDTH, HEIGHT

	# TODO: the rest of fields

	# Метки времени: 
	created    = models.DateTimeField(auto_now_add=True, editable=False, blank=True, verbose_name=u'дата создания')
	modified   = models.DateTimeField(auto_now=True, auto_now_add=True, blank=True, verbose_name=u'дата последнего изменения')
	# Видимость: 
	visible    = models.BooleanField(default=False , verbose_name=u'видимость')

	class Meta:
		verbose_name = _(u'изображение товара')
		verbose_name_plural = _(u'изображения товаров')

	#TODO: preview methods

	def get_preview_html(self):
		return u"<img src='{0}' alt='{1}' />".format(self.image.get_filename(), self.short_desc)

	def __unicode__(self):
	    return self.title if self.visible else u'{0} (скрыт)'.format(self.title)


class PictureInline(admin.options.InlineModelAdmin):
	model = Wallpaper.images.through
	extra = 1
	verbose_name = u'Изображение'
	verbose_name_plural = u'Изображения'
	template = 'admin/edit_inline_images.tpl'


class PictureAdmin(admin.ModelAdmin):
	def admin_image_preview(self, obj):
		if obj.image:
			try:
				return u'<a href="%s" target="blank"><image style="max-width:100px; max-height:100px" src="%s"/></a>' % (obj.image.url, obj.image.url)
			except:
				return u'<p>При попытке вывести изображение произошла ошибка!</p>'
		else:
			return '-'

	admin_image_preview.short_description = 'Изображение'
	admin_image_preview.allow_tags = True

	list_display = ('title', 'admin_image_preview')
	#search_fields = ('item__theme__title', 'item__type__title', 'item__title', 'item__material')
	readonly_fields = ('created', 'modified')


############################
#         Текстуры         #
############################

class Texture(models.Model):
	# Название товара:
	title = models.CharField(max_length=120, null=False, verbose_name=_(u'название'))
	# Короткое описание: 
	short_desc = models.CharField(max_length=200, null=True, verbose_name=_(u'короткое описание'))
	# Полное описание: 
	long_desc = WYSIWYGField(null=True, verbose_name=_(u'длинное описание'))
	# Изображение текстуры: 
	pic = ImageWithThumbsField(upload_to='textures/', verbose_name=_(u'изображение текстуры'), sizes=textures_sizes) # TODO: РАЗМЕРЫ ПИКТОГРАММЫ ТЕКСТУРЫ
	# Шаблон: 
	template = models.ForeignKey('Template', blank=True, null=True, verbose_name=_(u'шаблон'))
	# Информационные блоки: 
	info_blocks = models.ManyToManyField(
		'iBlock', 
		blank=True, 
		verbose_name=_(u'информационные блоки')
	)

	# Метки времени: 
	created    = models.DateTimeField(auto_now_add=True, editable=False, blank=True, verbose_name=u'дата создания')
	modified   = models.DateTimeField(auto_now=True, auto_now_add=True, blank=True, verbose_name=u'дата последнего изменения')
	# Видимость: 
	visible    = models.BooleanField(default=False , verbose_name=u'видимость')

	class Meta:
		verbose_name = _(u'текстура')
		verbose_name_plural = _(u'текстуры')

	def get_preview_html(self):
		import os
		return """
			<img src="/media/textures/{0}" height="60" />
			""".format(os.path.split(self.pic.path)[1])
	get_preview_html.allow_tags = True
	get_preview_html.short_description = u'Предпросмотр'

	def __unicode__(self):
		return self.title

	def get_absolute_url(self):
		return '#'

	def list_title(self):
	    return self.title if self.visible else u'{0} (скрыт)'.format(self.title)
	list_title.allow_tags = True
	list_title.short_description = u'Название'

class TextureAdmin(admin.ModelAdmin):
	filter_horizontal = ('info_blocks',)
	list_display = ['list_title', 'get_preview_html', 'visible']
	readonly_fields = ('created', 'modified')
	save_as = True


############################
#        Материалы         #
############################

class Material(models.Model):
	# Название товара:
	title = models.CharField(max_length=120, null=False, verbose_name=_(u'название'))
	# Короткое описание: 
	short_desc = models.CharField(max_length=200, null=True, verbose_name=_(u'короткое описание'))
	# Полное описание: 
	long_desc = WYSIWYGField(null=True, verbose_name=_(u'длинное описание'))
	# Пиктограмма: TODO: УБРАТЬ
	pic = ImageWithThumbsField(upload_to='textures/', blank=True, verbose_name=_(u'изображение материала'), sizes=thumbnails_sizes)
	# Шаблон: 
	template = models.ForeignKey('Template', blank=True, null=True, verbose_name=_(u'шаблон'))
	# Информационные блоки: 
	info_blocks = models.ManyToManyField(
		'iBlock', 
		blank=True, 
		verbose_name=_(u'информационные блоки')
	)

	# Метки времени: 
	created    = models.DateTimeField(auto_now_add=True, editable=False, blank=True, verbose_name=u'дата создания')
	modified   = models.DateTimeField(auto_now=True, auto_now_add=True, blank=True, verbose_name=u'дата последнего изменения')
	# Видимость: 
	visible    = models.BooleanField(default=False , verbose_name=u'видимость')

	class Meta:
		verbose_name = _(u'материал')
		verbose_name_plural = _(u'материалы')

	def get_preview_html(self):
		import os
		return u'<img src="/media/textures/{0}" width height />'.format(os.path.split(self.pic.path)[1]) if self.pic else '(Пусто)'
	get_preview_html.allow_tags = True
	get_preview_html.short_description = u'Картинки'

	def __unicode__(self):
	    return self.title if self.visible else u'{0} (скрыт)'.format(self.title)

	def get_absolute_url(self):
		# TODO: id => url!!!
		return u'/material/{0}/'.format(self.id)

class MaterialAdmin(admin.ModelAdmin):
	filter_horizontal = ('info_blocks',)
	list_display = ['title', 'get_preview_html', 'visible']
	readonly_fields = ('created', 'modified')


############################
#          Шаблоны         #
############################

class Template(models.Model):
	# Название товара:
	title = models.CharField(max_length=120, null=False, verbose_name=_(u'название'))
	# Комментарий
	comment = WYSIWYGField(verbose_name=_(u'комментарий'))
	# Файл шаблона:
	template = models.FileField(upload_to='templates/custom/') # TODO: ВАЛИДАЦИЯ РАСШИРЕНИЯ
	# Информационные блоки: 
	info_blocks = models.ManyToManyField(
		'iBlock', 
		blank=True, 
		verbose_name=_(u'информационные блоки')
	)

	# Метки времени: 
	created    = models.DateTimeField(auto_now_add=True, editable=False, blank=True, verbose_name=u'дата создания')
	modified   = models.DateTimeField(auto_now=True, auto_now_add=True, blank=True, verbose_name=u'дата последнего изменения')
	# Видимость: 
	visible    = models.BooleanField(default=False , verbose_name=u'видимость')

	class Meta:
		verbose_name = _(u'шаблон')
		verbose_name_plural = _(u'шаблоны')

	def __unicode__(self):
	    return self.title if self.visible else u'{0} (скрыт)'.format(self.title)

class TemplateAdmin(admin.ModelAdmin):
	filter_horizontal = ('info_blocks',)
	readonly_fields = ('created', 'modified')


############################
#         Инфоблоки        #
############################

class iBlock(models.Model):
	# Название товара:
	title = models.CharField(max_length=120, null=False, verbose_name=_(u'название'))
	# Содержимое: 
	content = WYSIWYGField(null=True, verbose_name=_(u'содержимое'))

	# TODO: PRIORITY!
	# Метки времени: 
	created    = models.DateTimeField(auto_now_add=True, editable=False, blank=True, verbose_name=u'дата создания')
	modified   = models.DateTimeField(auto_now=True, auto_now_add=True, blank=True, verbose_name=u'дата последнего изменения')
	# Видимость: 
	visible    = models.BooleanField(default=False , verbose_name=u'видимость')

	class Meta:
		verbose_name = _(u'инфоблок')
		verbose_name_plural = _(u'инфоблоки')

	def __unicode__(self):
	    return self.title if self.visible else u'{0} (скрыт)'.format(self.title)

class iBlockAdmin(admin.ModelAdmin):
	readonly_fields = ('created', 'modified')
	list_display = ['id', 'title', 'content', 'visible']

########################
#        Акция         #
########################

class PromoCampain(models.Model):

	# Название акции: 
	title = models.CharField(max_length=120, null=False, verbose_name=_(u'название'))
	# Содержимое: 
	content = WYSIWYGField(null=True, verbose_name=_(u'содержимое'))

	# Инфоблок акции: 
	info_blocks = models.ManyToManyField(
		'iBlock', 
		blank=True, 
		related_name='promo_campains',
		verbose_name=u'инфоблок акции'
	)

	# Формула рассчёта цены товара в акции:
	wallpaper_price_formula = WYSIWYGField(blank=True, null=True, default="WALLPAPER_PRICE*1", verbose_name=u"формула рассчёта цены обоев")
	# Формула рассчёта общей стоимости корзины: 
	total_price_formula = WYSIWYGField(blank=True, null=True, default="TOTAL_PRICE*1", verbose_name=u"формула рассчёта общей стоимости заказа")
	# Формула рассчёта стоимости доставки:
	shipping_price_formula = WYSIWYGField(blank=True, null=True, default="SHIPPING_PRICE*1", verbose_name=u"формула рассчёта стоимости доставки")

	# Формула условий акции: 
	conditions = WYSIWYGField(blank=True, null=True, default="IS_PROMO", verbose_name=u"условия акции")

	# Категории товара: 
	categories = models.ManyToManyField(
		'Category',
		related_name='promo_campains',
		null=True,
		blank=True,
		default=None,
		verbose_name=_(u'категории товара')
	)
	# Обои:
	wallpapers = models.ManyToManyField(
		'Wallpaper',
		related_name='promo_campains',
		null=True,
		blank=True,
		default=None,
		verbose_name=u'обои'
	)
	# TODO: BOOL "FOR EVERYTHING"

	# Метки времени: 
	created    = models.DateTimeField(auto_now_add=True, editable=False, blank=True, verbose_name=u'дата создания')
	modified   = models.DateTimeField(auto_now=True, auto_now_add=True, blank=True, verbose_name=u'дата последнего изменения')
	# Видимость: 
	visible    = models.BooleanField(default=False , verbose_name=u"видимость") # TODO: active, not visible!

	class Meta:
		verbose_name = _(u'Акция')
		verbose_name_plural = _(u'Акции')

	def __unicode__(self):
		return self.title if self.visible else u'{0} (скрыт)'.format(self.title)

	def save(self):
		# TODO: take all categories and add their items to wallpapers!!!
		#raise NotImplementedError, u'В разработке'
		super(PromoCampain, self).save()

	#TODO: процедуры проверки условий акции для отдельной обоины, стоимости заказа и стоимости доставки


class PromoCampainAdmin(admin.ModelAdmin):
	readonly_fields = ('created', 'modified')
	filter_horizontal = ('info_blocks', 'categories', 'wallpapers')
	list_display = ['title', 'conditions', 'wallpaper_price_formula', 'total_price_formula', 'shipping_price_formula', 'visible']

########################
#        Клиент        #
########################

class Customer(models.Model):
	# TODO: поля
	user = models.OneToOneField(User)
	first_name = models.CharField(max_length=32, blank=False, editable=False, verbose_name=u"Имя")
	second_name = models.CharField(max_length=32, blank=False, editable=False, verbose_name=u"Отчество")
	surname = models.CharField(max_length=32, blank=False, editable=False, verbose_name=u"Фамилия")

	email = models.CharField(max_length=32, blank=False, editable=False, verbose_name=u"Электропочта")
	email_confirmation_hash = models.CharField(max_length=32, blank=True, null=True, editable=False, verbose_name=u"Хеш подтверждения")

	address = models.TextField(blank=True, editable=True, verbose_name=u"Адрес")
	phone = models.CharField(max_length=18, blank=True, editable=True, verbose_name=u"Телефон")

	class Meta:
		verbose_name = _(u'клиент')
		verbose_name_plural = _(u'клиенты')


	def full_name(self):
		return u'%s %s %s' % (self.first_name, self.second_name, self.surname)

	def __unicode__(self):
		return u'%s %s %s' % (self.first_name, self.second_name, self.surname)

	@classmethod
	def create(cls, **kw):
		customer = cls(**kw)
		# do something with the book
		return customer

########################
#        Заказ         #
########################

ORDER_STATE_CHOICES = (
	('PLACED', 			'Размещён'),
	('CALLED_SUCCESS', 	'Подтверждён'),
	('CALLED_FAILED', 	'Не дозвонились'),
	('FAKE',			'Ложный'),
	('CLIENT_REFUSED',	'Отказ'),
	('ORDER_SENT',		'Отправлен'),
	('DONE',			'Выполнен')
)

class Order(models.Model):
	# TODO: поля
	# Состояние заказа:
	state = models.CharField(max_length=20, blank=False, verbose_name=u'состояние заказа')

	# Метки времени: 
	created    = models.DateTimeField(auto_now_add=True, editable=False, blank=True, verbose_name=u'дата создания')
	modified   = models.DateTimeField(auto_now=True, auto_now_add=True, blank=True, verbose_name=u'дата последнего изменения')
	# Видимость: 
	visible    = models.BooleanField(default=False , verbose_name=u'видимость')

	dump = models.TextField(blank=True, editable=False) #...
	total = models.IntegerField(blank=True, editable=False, verbose_name=u'стоимость')

	comments = models.TextField(blank=True, editable=True, verbose_name=u"комментарий")

	customer = models.ForeignKey(Customer, blank=True, null=True, verbose_name=u"заказчик")

	class Meta:
		verbose_name = _(u'заказ')
		verbose_name_plural = _(u'заказы')

	def __unicode__(self):
		return u"%s %s" % (self.created, self.state)

	def customer_or_unregistered(self):
		if self.customer: 
			# TODO: return not just an object but a link to the admin page w/customer
			return self.customer
		return u"Пользователь не зарегистрирован"

	def fetch_items(self):
		import pickle
		return pickle.loads(str(self.dump)).values()

	def print_html(self):
		html = u"""<b>Заказчик: {customer}</b>

		<p>{comments}</p>

		{items}

		<hr />
		<p>Итого: {total}</p>"""
		items = self.fetch_items()
		strings = str()
		for i in items:	
			strings += u"<p>[%s] <b>%s</b> x%s @ %s</p>" % (i.sku, i.title, str(i.quantity), str(i.price))
		return html.format( customer=self.customer_or_unregistered(), comments=self.comments, items=strings, total=self.total )
	print_html.allow_tags = True

	def print_text(self):
		text = u"""Заказчик: {customer}

		{comments}

		Товары: 
		{items}

		-----
		Итого: {total}"""
		items = self.fetch_items()
		strings = str()
		for i in items:	
			strings += u"[%s] %s x%s @ %s\n\r" % (i.sku, i.title, str(i.quantity), str(i.price))
		return text.format( customer=self.customer_or_unregistered(), comments=self.comments, items=strings, total=self.total )



