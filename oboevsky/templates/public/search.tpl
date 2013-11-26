{% extends "public/inc/common_sitepage.tpl" %}

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
                {% if menu_categories|length > 0 %}
                <li>
                    <h3>Обои по назначению</h3>
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
                    <h1>Результаты поиска</h1>
                    <p>Найдено {{items|length}} вариантов</p>

                    <div class="items clear">
                        {% for item in items %}

                                {% comment %}
                                    {% if forloop.counter == 9 %}
                                        <script>
                                            function trigger_{{item.id}}() {
                                                $('#trigger-{{item.id}}').hide();
                                                $('#items-group-{{item.id}}').show();
                                            }
                                        </script>
                                        <a id="trigger-{{item.id}}" href="javascript:trigger_{{item.id}}();" style="width:169px; height:169px; line-height: 160px; text-align:center; display:block; float: left;">Показать&nbsp;остальные</a>
                                        <div style="display:none" id="items-group-{{item.id}}">
                                    {% endif %}
                                {% endcomment %}

                                {% include "public/inc/wallpapers_list_item.tpl" %}

                                {% if forloop.counter|divisibleby:"3" %}
                                    <div class="spacer"></div>
                                {% endif %}

                                {% comment %}
                                    {% if forloop.counter > 9 %}
                                        {% if forloop.last %}
                                            </div>
                                        {% endif %}
                                    {% endif %}
                                {% endcomment %}

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