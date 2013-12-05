{% extends "public/inc/common_sitepage.tpl" %}

{% block sorting %}{% endblock %}

{% block page_title %}{{block.super}} — {{flatpage.title}}{% endblock %}
{% block meta_description %}{{flatpage.title}}{% endblock %}
{% block meta_keywords %}{{flatpage.title}}{% endblock %}

{% block content %}
    <div class="contentBlockNoBorder">
        <div id="breadcrumps">
            <a href="/">Главная</a> / {{flatpage.title}}
        </div>

        <h1>{{flatpage.title}}</h1>
        {{flatpage.content|safe}}
    </div>
{% endblock %}