# coding: utf-8
import os
#from django.contrib.sitemaps import Sitemap as _Sitemap
from django.db import models
from django.contrib import admin
from django.contrib.auth.models import User
from django.utils.translation import ugettext as _
from colour_field.fields import ColourField
from django.db.models.signals import pre_save

############################
#           Обои           #
############################

class Wallpaper(models.Model):

	# Артикул 
	sku = models.SlugField(max_length=40, null=False, unique=True, verbose_name=_(u'артикул')) # TODO: pcre validation
	# Название товара:
	title = models.CharField(max_length=120, null=False, verbose_name=_(u'название'))
	# Якорь:
	url = models.SlugField(max_length=100, null=True, verbose_name=_(u'якорь'))
	# Короткое описание: 
	short_desc = models.CharField(max_length=200, null=True, verbose_name=_(u'короткое описание'))
	# Полное описание: 
	long_desc = models.TextField(null=True, verbose_name=_(u'длинное описание'))
	# Цена:
	price = models.DecimalField(max_digits=12, decimal_places=2, blank=True, null=True, verbose_name=_(u'цена'))

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
	colour = ColourField(blank=True, verbose_name=_(u'цвет'))

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
		return self.categories.order_by('-parents_num')[0]
	get_first_category.short_description = u'Категория с наивысшим приоритетом'

	def get_first_category_breadcrumps(self):
		""" Возвращает самую приоритетную категорию.
		"""
		return self.categories.order_by('-parents_num')[0].get_breadcrumps()
	get_first_category_breadcrumps.short_description = u'Категория с наивысшим приоритетом'

	def __unicode__(self):
		return self.title if self.visible else u'<s>{0}</s>'.format(self.title) if self.visible else u'<s>{0}</s>'.format(self.title)

	def get_absolute_url(self):
		return u'/обои/'+self.url

	class Meta:
		verbose_name = _(u'обои')
		verbose_name_plural = _(u'обои')
		ordering = ['priority']


############################
#      Производители       #
############################

class Producer(models.Model):
	# Название:
	title = models.CharField(max_length=120, null=False, verbose_name=_(u'название'))
	# Якорь:
	url = models.SlugField(max_length=100, null=True, verbose_name=_(u'якорь'))
	# Короткое описание: 
	short_desc = models.CharField(max_length=200, null=True, verbose_name=_(u'короткое описание'))
	# Полное описание: 
	long_desc = models.TextField(null=True, verbose_name=_(u'длинное описание'))
	# Страна:
	country = models.ForeignKey('Country', blank=False, verbose_name=_(u'страна'))
	# Шаблон: 
	template = models.ForeignKey('Template', blank=True, null=True, verbose_name=_(u'шаблон'))
	# Информационные блоки: 
	info_blocks = models.ManyToManyField('iBlock', blank=True, verbose_name=_(u'информационные блоки'))

	# TODO: LOGO!!!

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
	    return self.title if self.visible else u'<s>{0}</s>'.format(self.title)

	def get_absolute_url(self):
		return u'/производитель/'+self.url


class ProducerAdmin(admin.ModelAdmin): 
	readonly_fields = ('created', 'modified')
	list_display = ['title', 'country', 'url', 'visible']


############################
#          Страны          #
############################

class Country(models.Model):
	# Название:
	title = models.CharField(max_length=120, null=False, verbose_name=_(u'название'))
	# Короткое описание: 
	short_desc = models.CharField(max_length=200, null=True, verbose_name=_(u'короткое описание'))
	# Полное описание: 
	long_desc = models.TextField(null=True, verbose_name=_(u'длинное описание'))
	# Якорь:
	url = models.SlugField(max_length=100, null=True, verbose_name=_(u'якорь'))
	# Пиктограмма страны: 
	pic = models.ImageField(upload_to='countries/', verbose_name=_(u'пиктограмма страны'))
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
	    return self.title if self.visible else u'<s>{0}</s>'.format(self.title)

	def get_absolute_url(self):
		return u'/country/'+self.url

	def get_html(self):
		import os
		return u'''
			<a href="{0}">
				<img src="/media/countries/{1}" align="left" height width />&nbsp;{2}
			</a>
			'''.format(self.get_absolute_url(), os.path.split(self.pic.path)[1], self.title) # TODO HEIGHT WIDTH
	get_html.short_description = u'Изображение'
	get_html.allow_tags = True

	def get_admin_html(self):
		import os
		return u'''
				<img src="/media/countries/{0}" align="left" height width />&nbsp;{1}
			'''.format(os.path.split(self.pic.path)[1], self.title) # TODO HEIGHT WIDTH
	get_admin_html.short_description = u'Изображение'
	get_admin_html.allow_tags = True

class CountryAdmin(admin.ModelAdmin):
	readonly_fields = ('created', 'modified')
	list_display = ['get_html', 'url', 'code', 'priority', 'visible']
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
	long_desc = models.TextField(null=True, verbose_name=_(u'длинное описание'))
	# Якорь:
	url = models.SlugField(max_length=100, null=True, verbose_name=_(u'якорь'))
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
	    return self.title if self.visible else u'<s>{0}</s>'.format(self.title)

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
	long_desc = models.TextField(null=True, verbose_name=_(u'длинное описание'))
	# Изображение: 
	image = models.ImageField(upload_to='pictures/', verbose_name=u'изображение') # TODO: WIDTH, HEIGHT

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
		return "<img src='{0}' alt='{1}' />".format(self.get_filename(), self.short_desc)

	def __unicode__(self):
	    return self.title if self.visible else u'<s>{0}</s>'.format(self.title)


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
	long_desc = models.TextField(null=True, verbose_name=_(u'длинное описание'))
	# Изображение текстуры: 
	pic = models.ImageField(upload_to='textures/', verbose_name=_(u'изображение текстуры')) # TODO: РАЗМЕРЫ ПИКТОГРАММЫ ТЕКСТУРЫ
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

	def list_title(self):
	    return self.title if self.visible else u'<s>{0}</s>'.format(self.title)
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
	long_desc = models.TextField(null=True, verbose_name=_(u'длинное описание'))
	# Пиктограмма: TODO: УБРАТЬ
	pic = models.ImageField(upload_to='textures/', blank=True, verbose_name=_(u'изображение материала')) # TODO: РАЗМЕРЫ ПИКТОГРАММЫ МАТЕРИАЛА
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
	    return self.title if self.visible else u'<s>{0}</s>'.format(self.title)

	def get_absolute_url(self):
		return u'/materials/'+self.url

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
	comment = models.TextField(verbose_name=_(u'комментарий'))
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
	    return self.title if self.visible else u'<s>{0}</s>'.format(self.title)

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
	content = models.TextField(null=True, verbose_name=_(u'содержимое'))

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
	    return self.title if self.visible else u'<s>{0}</s>'.format(self.title)

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
	content = models.TextField(null=True, verbose_name=_(u'содержимое'))

	# Инфоблок акции: 
	info_blocks = models.ManyToManyField(
		'iBlock', 
		blank=True, 
		related_name='promo_campains',
		verbose_name=u'инфоблок акции'
	)

	# Формула рассчёта цены товара в акции:
	wallpaper_price_formula = models.TextField(blank=True, null=True, default="WALLPAPER_PRICE*1", verbose_name=u"формула рассчёта цены обоев")
	# Формула рассчёта общей стоимости корзины: 
	total_price_formula = models.TextField(blank=True, null=True, default="TOTAL_PRICE*1", verbose_name=u"формула рассчёта общей стоимости заказа")
	# Формула рассчёта стоимости доставки:
	shipping_price_formula = models.TextField(blank=True, null=True, default="SHIPPING_PRICE*1", verbose_name=u"формула рассчёта стоимости доставки")

	# Формула условий акции: 
	conditions = models.TextField(blank=True, null=True, default="IS_PROMO", verbose_name=u"условия акции")

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
		related_name='wallpapers',
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
		return self.title if self.visible else u'<s>{0}</s>'.format(self.title)

	def save(self):
		# TODO: take all categories and add their items to wallpapers!!!
		#raise NotImplementedError, u'В разработке'
		super(PromoCampain, self).save()


class PromoCampainAdmin(admin.ModelAdmin):
	readonly_fields = ('created', 'modified')
	filter_horizontal = ('info_blocks', 'categories', 'wallpapers')
	list_display = ['title', 'conditions', 'wallpaper_price_formula', 'total_price_formula', 'shipping_price_formula', 'visible']


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

	# Состояние заказа:
	state = models.CharField(max_length=20, blank=False, verbose_name=u'состояние заказа')

	# Метки времени: 
	created    = models.DateTimeField(auto_now_add=True, editable=False, blank=True, verbose_name=u'дата создания')
	modified   = models.DateTimeField(auto_now=True, auto_now_add=True, blank=True, verbose_name=u'дата последнего изменения')
	# Видимость: 
	visible    = models.BooleanField(default=False , verbose_name=u'видимость')

	#user = models.OneToOneField(User)

	class Meta:
		verbose_name = _(u'заказ')
		verbose_name_plural = _(u'заказы')

	def __unicode__(self):
		pass


########################
#        Клиент        #
########################

class Customer(models.Model):

	user = models.OneToOneField(User)

