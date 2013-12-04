{% extends "public/inc/common_sitepage.tpl" %}

{% block page_title %}{{block.super}} — Искать обои по параметрам{% endblock %}

{% block left_sidebar %}
<div class="pageSidebar left">
    <form action="?do" method="POST">
    {% csrf_token %}

    <script>
    function changeChecked(id) {
        obj = $('#'+id)
        if(obj.attr('checked') == undefined) {
            obj.attr('checked', 'checked');
        } else {
            obj.removeAttr('checked');
        }
    }
    </script>

    <div class="pageColumn">
        <h2>Критерии поиска:</h2>
        <ul>
            {% block menu_categories %}

                <li>
                    <h3>Ограничить цену:</h3>
                    От: <input type="text" name="min_price" value="{{min_price}}" />
                    До: <input type="text" name="max_price" value="{{max_price}}" />
                </li>

                {% if menu_categories|length > 0 %}
                <li>
                    <h3>Назначение:</h3>
                    <ul>
                        {% for temp in menu_categories %}
                        <li style="cursor:pointer;" onClick="javascript:changeChecked('category_{{temp.pk}}');"><input onClick="javascript:changeChecked('category_{{temp.pk}}');" id="category_{{temp.pk}}" type="checkbox" name="categories" value="{{temp.pk}}" {% if temp.pk in selected_categories %}checked="checked"{% endif %}/> {{temp.title}}</li>
                        {% endfor %}
                    </ul>
                </li>
                {% endif %}
            {% endblock %}

            {% comment %}
                {% if menu_countries|length > 0 %}
                <li>
                    <h3>Страны: </h3>
                    <ul>
                        {% for temp in menu_countries %}
                            <li style="cursor:pointer;" onClick="javascript:changeChecked('country_{{temp.pk}}');"><input onClick="javascript:changeChecked('country_{{temp.pk}}');" id="country_{{temp.pk}}" type="checkbox" name="countries" value="{{temp.pk}}" {% if temp.pk in selected_countries %}checked="checked"{% endif %}/> {{temp.get_html|safe}}</li>
                        {% endfor %}
                    </ul>
                </li>
                {% endif %}
            {% endcomment %}

            {% if menu_producers|length > 0 %}
            <li>
                <h3>Производители:</h3>
                <ul class="no-list">
                    {% for temp in menu_producers %}
                        <li style="cursor:pointer;" onClick="javascript:changeChecked('producer_{{temp.pk}}');"><input onClick="changeChecked('producer_{{temp.pk}}');" id="producer_{{temp.pk}}" type="checkbox" name="producers" value="{{temp.pk}}" {% if temp.pk in selected_producers %}checked="checked"{% endif %}/><img alt="{{item.producer.country.short_desc}}" src="{{temp.producer.country.pic.url_13x20}}"/> {{temp.title}}</li>
                    {% endfor %}
                </ul>
            </li>
            {% endif %}

            {% if menu_materials|length > 0 %}
            <li>
                <h3>Материалы:</h3>
                <ul>
                    {% for temp in menu_materials %}
                        <li style="cursor:pointer;" onClick="javascript:changeChecked('material_{{temp.pk}}');"><input onClick="javascript:changeChecked('material_{{temp.pk}}');" id="material_{{temp.pk}}" type="checkbox" name="materials" value="{{temp.pk}}" {% if temp.pk in selected_materials %}checked="checked"{% endif %}/> {{temp.title}}</li>
                    {% endfor %}
                </ul>
            </li>
            {% endif %}

            <li style="list-style:none; text-align:center;">
                <h3><input type="submit" value="Искать" /></h3>
            </li>
        </ul>
    </div>

    </form>
</div>
{% endblock %}

{% block content %}

    {% if items %}
        {% if items_display_mode == 'grouped' %}

            <div class="contentBlockNoBorder">
                <h1>Результаты поиска ({{items_found}})</h1>
            </div>

            {% include "public/inc/grouped_wallpaper_collection.tpl" %}

        {% else %}

            <div class="contentBlock">
                <div>
                    <h2>Результаты поиска</h2>
                    <p>Найдено {{items|length}} вариантов</p>

                    <div class="items clear">
                        {% for item in items %}

                            <div class="item new-look" style="background:url('{{item.get_first_image.image.url_170x111}}'); cursor:pointer;" onClick="javascript:document.location.href='{{item.get_absolute_url}}?q={{q}}';">
                                {% if item.get_first_image %}
                                    <a href="{{item.get_absolute_url}}?q={{q}}">
                                        <img src="{{item.get_first_image.image.url_170x111}}" alt="{{item.short_desc}}" />
                                    </a>
                                {% endif %}
                                <p class="title-container">
                                    <a href="{{item.get_absolute_url}}?q={{q}}"><b style="text-decoration:none;">{{item.title}}</b></a><br />
                                    {{item.price|floatformat:"-3"}} руб.
                                </p>
                                <p><a class="buy-link" href="/put-to-cart/{{item.pk}}">Купить</a></p>
                            </div>

                            {% if forloop.counter|divisibleby:"3" %}
                                <div class="spacer"></div>
                            {% endif %}
                        {% endfor %}
                    </div>

                </div>
            </div>

        {% endif %}
    {% else %}
        {% if no_criteria %}
            <div class="contentBlockNoBorder">
                <h1>Поиск</h1>
                <p>Пожалуйста, выберите интересующие Вас критерии поиска в панели слева</p>
            </div>
        {% else %}
            <div class="contentBlockNoBorder">
                <h1>Результаты поиска</h1>
                <p>Сожалеем: по Вашему запросу ничего не найдено.</p>
                <p>Пожалуйста, свяжитесь с нами и сообщите о Вашем запросе — мы попробуем найти подходящие Вам товары в индивидуальном порядке. :)</p>
            </div>
        {% endif %}
    {% endif %}

    {% comment %}
    <code>
    Producers: {{selected_producers}}<br />
    Categories: {{selected_categories}}<br />
    POST: {{POST}}<br />
    items: {{items}}
    </code>
    {% endcomment %}

{% endblock %}