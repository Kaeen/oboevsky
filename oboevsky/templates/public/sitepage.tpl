{% extends "public/inc/common_sitepage.tpl" %}

{% block content %}
    <div class="contentBlockNoBorder">
        <div id="breadcrumps">
            <a href="/">Главная</a> / {{flatpage.title}}
        </div>

        <h1>{{flatpage.title}}</h1>
        {{flatpage.content}}
    </div>
{% endblock %}