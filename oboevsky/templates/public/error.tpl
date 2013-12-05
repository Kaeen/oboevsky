{% extends "public/inc/common_sitepage.tpl" %}

{% block sorting %}{% endblock %}

{% block page_title %}{{block.super}} — Ошибка{% endblock %}

{% block content %}
    <div class="contentBlockNoBorder">

        <h1>Ошибка</h1>
        <p>Возникла ошибка. Возможно, ссылка, по которой Вы перешли, устарела. Также советуем проверить правильность запроса. В случае, если данные указанны верно, повторите запрос с <a href="http://oboevsky.ru/">главной</a> страницы.</p>
		<p>При повторном появлении данного сообщения напишите, пожалуйста, по адресу: <a href="mailto:oboevsky@gmail.com">oboevsky@gmail.com</a>.</p>

    </div>
{% endblock %}