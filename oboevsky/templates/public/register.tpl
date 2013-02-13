{% extends "public/inc/common_sitepage.tpl" %}

{% block content %}
    <div class="contentBlockNoBorder">
        <div id="breadcrumps">
            <a href="/">Главная</a> / Регистрация
        </div>

        {%if error %}

            <h1>Ошибка</h1>
            <p>{{error}}</p>
        
        {%else%}

            <h1>Здравствуйте!</h1>
            <p>Для того, чтобы мы могли всегда Вас узнать и предложить Вам наилучшие условия сотрудничества, лучше всего иметь учётную запись. Это позволит нам запоминать, что Вы заказываете, предлагать Вам новые товары и сокращать время, которые Вы тратите на заполнение различных форм при заполнении заказа. </p>
            <p>Всё, что нужно сделать — это заполнить форму ниже и пройти по ссылке, полученной в письме. </p>

        {%endif%}

        <form action="?do" method="post">
        	<p>
        		Имя: <input name="first_name" type="text" value="{{first_name}}" />
        	</p>
        	<p>
        		Отчество: <input name="second_name" type="text" value="{{second_name}}" />
        	</p>
        	<p>
        		Фамилия: <input name="surname" type="text" value="{{surname}}" />
        	</p>

            <p>
                Пароль: <input name="pass" type="password" /> <br/>
                Подтвержение пароля: <input name="pass2" type="password" />
            </p>

        	<p>
        		e-mail: <input name="email" type="text" value="{{email}}" />
        	</p>
        	<p>
        		Телефон: <input name="phone" type="text" value="{{phone}}" />
        	</p>

			<p>
        		Адрес доставки: <br />
        		<textarea name="address">{{address}}</textarea>
        	</p>

        	<p>
        		<input type="submit" value="Далее" />
        	</p>
        </form>
    </div>
{% endblock %}