{% extends "public/inc/common_sitepage.tpl" %}

{% block content %}

    <div class="contentBlockNoBorder">
        <div id="breadcrumps">
            <a href="/">Главная</a> / <a href="/catalog/">Каталог</a> / Страны
        </div>
        <div id="producerProfile">
            <h1>Страны-производители обоев</h1>
            {% for country in countries %}
                <div>{{country.get_html}}</div>
            {% endfor %}
        </div>
    </div>

{% endblock %}