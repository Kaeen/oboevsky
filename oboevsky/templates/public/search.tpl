{% extends "public/inc/common_sitepage.tpl" %}

{% block left_sidebar %}
<div class="pageSidebar left">
    <form action="?do" method="POST">
    {% csrf_token %}
    <div class="pageColumn">
        <h2>Категории обоев</h2>
        <ul>
            {% block menu_categories %}
                {% if menu_categories|length > 0 %}
                <li>
                    <h3>Обои по назначению</h3>
                    <ul>
                        {% for temp in menu_categories %}
                        <li><input type="checkbox" name="categories" value="{{temp.pk}}" {% if temp.pk in selected_categories %}checked="checked"{% endif %}/> {{temp.title}}</li>
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
                            <li><input type="checkbox" name="countries" value="{{temp.pk}}" {% if temp.pk in selected_countries %}checked="checked"{% endif %}/> {{temp.get_html|safe}}</li>
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
                        <li><input type="checkbox" name="producers" value="{{temp.pk}}" {% if temp.pk in selected_producers %}checked="checked"{% endif %}/><img alt="{{item.producer.country.short_desc}}" src="{{temp.producer.country.pic.url_13x20}}"/> {{temp.title}}</li>
                    {% endfor %}
                </ul>
            </li>
            {% endif %}

            {% if menu_materials|length > 0 %}
            <li>
                <h3>Материалы:</h3>
                <ul>
                    {% for temp in menu_materials %}
                        <li><input type="checkbox" name="materials" value="{{temp.pk}}" {% if temp.pk in selected_materials %}checked="checked"{% endif %}/> {{temp.title}}</li>
                    {% endfor %}
                </ul>
            </li>
            {% endif %}
        </ul>
    </div>

    <input type="submit" value="Искать" />

    </form>
</div>
{% endblock %}

{% block content %}

    <div class="contentBlockNoBorder">
        <div id="breadcrumps">
            <a href="/">Главная</a> / <a href="/search/">Поиск</a>
        </div>
    </div>

    {% if items %}
        {% if items_display_mode == 'grouped' %}

            {% include "public/inc/grouped_wallpaper_collection.tpl" %}

        {% else %}

            <div class="contentBlock">
                <div>
                    <h2>Найденные обои</h2>

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
        <div class="contentBlockNoBorder">
            <h1>Сожалеем</h1>
            <p>По Вашему запросу ничего не найдено</p>

        </div>
    {% endif %}

    <code>
    Producers: {{selected_producers}}<br />
    Categories: {{selected_categories}}<br />
    POST: {{POST}}<br />
    items: {{items}}
    </code>

{% endblock %}