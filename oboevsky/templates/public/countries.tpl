{% extends "public/inc/common_sitepage.tpl" %}

{% block menu_countries %}
{% endblock %}

{% block content %}

    <div class="contentBlockNoBorder">
        <div id="breadcrumps">
            <a href="/">Главная</a> / <a href="/catalog/">Каталог</a> / Страны
        </div>
        <div id="producerProfile">
            <h1>Страны-производители обоев</h1>
            <ul>
            {% for country in countries %}
                <li>{{country.get_html|safe}}</li>
            {% endfor %}
            </ul>
        </div>
    </div>

{% endblock %}