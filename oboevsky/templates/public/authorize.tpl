{% extends "public/inc/common_sitepage.tpl" %}

{% block content %}
    <div class="contentBlockNoBorder">
        <div id="breadcrumps">
            <a href="/">Главная</a> / Авторизация
        </div>

        {%if registered %}

            <h1>Спасибо! </h1>
            <p>Регистрация прошла успешно! В течение 10 минут на указанный Вами e-mail придёт письмо с подтверждением.</p>
        
        {%else%}

            <h1>Здравствуйте!</h1>
            <p>Для того, чтобы мы могли предложить Вам наилучший сервис, пройдите, пожалуйста, процедуру авторизации.</p>

        {%endif%}


        <style type="text/css">
            #order-form-table input {
                height: 18px;
            }
            #order-form-table textarea {
                height: 40px;
            }

            #order-form-table {
                margin-top: 10px;
            }

            #order-form-table td {
                vertical-align: top;
            }

            #order-form-table input,
            #order-form-table textarea {
                border: 1px solid #ccc;
                width: 300px;
                padding: 0 2px 2px 2px;
                margin: 0px;
                font-size: 13px;
            }

            .field-caption-wrapper {
                width: 120px;
                font-size: 14px;
            }

            #order-form .red {
                color: #C00;
            }

            #order-form p {
                padding-bottom: 10px;
            }
        </style>

        <form action="?do" method="post">

            {% if error %}<p>Ошибка: неправильные e-mail и/или пароль.</p>{% endif %}

            {% csrf_token %}
            <table id="order-form-table">

                <tr>
                    <td class="field-caption-wrapper red">E-mail:</td>
                    <td><input name="email" type="text" value="{{email}}" /></td>
                </tr>

                <tr>
                    <td class="field-caption-wrapper red">Пароль:</td>
                    <td><input name="pass" type="password" /></td>
                </tr>

            </table>

            <p>
                {% if not registered %}<a href="/register">Зарегистрироваться</a> {% endif %}<input type="submit" value="Войти" />
            </p>
        </form>
    </div>
{% endblock %}