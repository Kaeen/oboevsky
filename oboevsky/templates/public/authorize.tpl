{% extends "public/inc/common_sitepage.tpl" %}

{% block content %}
    <div class="contentBlockNoBorder">
        <div id="breadcrumps">
            <a href="/">Главная</a> / Авторизация
        </div>

        <h1>Здравствуйте!</h1>
        <p>Пожалуйста, представьтесь. </p>
        <form action="?do" method="post">
            {% if message %}
                <p class="red">{{message}}</p>
            {% endif %}
            {% csrf_token %}
        	<p>
        		Логин: <input name="login" type="text" value="" />
        	</p>
        	<p>
        		Пароль: <input name="password" type="password" value="" />
        	</p>
        	<p>
        		<input type="submit" value="Отправить" />
        		<a href="#">Зарегистрироваться</a>
        	</p>
        </form>
    </div>
{% endblock %}