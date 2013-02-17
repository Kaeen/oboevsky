{% extends "public/inc/common_sitepage.tpl" %}

{% block content %}
    <div class="contentBlockNoBorder">
        <div id="breadcrumps">
            <a href="/">Главная</a> / Авторизация
        </div>

        {%if after_register %}

            <h1>Спасибо! </h1>
            <p>Процедура регистрации завершена. Попробуем авторизоваться?</p>
        
        {%else%}

            <h1>Здравствуйте!</h1>
            <p>Для того, чтобы мы могли предложить Вам наилучший сервис, пройдите, пожалуйста, процедуру авторизации.</p>

        {%endif%}

        <form action="?do" method="post">

            {% if error %}<p>{{error}}</p>{% endif %}

            {% csrf_token %}

            <p>
                E-mail: <input name="email" type="text" value="{{email}}" />
            </p>
            <p>
                Пароль: <input name="pass" type="password" />
            </p>

            <p>
                {% if not after_register %}<a href="/register">Зарегистрироваться</a> {% endif %}<input type="submit" value="ОК" />
            </p>
        </form>
    </div>
{% endblock %}