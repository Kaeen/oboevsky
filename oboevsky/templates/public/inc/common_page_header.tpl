<div id="headerWrapper" class="clear">
    <div id="logoWrapper" class="left">
        <a href="http://oboevsky.ru/"><img alt="Обоевский" title="" src="/static/images/oboevsky.png" /></a>
    </div>
    <div id="phoneWrapper" class="left">
        <h2>+7-495-201-38-68</h2>
        <p>
            пн-пт с 9:00 до 20:00<br />
            сб-вс с 10:00 до 18:00
        </p>
        <h3>
            skype: oboevsky
        </h3>
    </div>

    <div id="bannersWrapper" class="right">
        <a{# href="#"#}><img class="right" alt="" src="/static/images/sample_banner1.jpg" /></a>
        <a{# href="#"#}><img class="right" alt="" src="/static/images/sample_banner2.jpg" /></a>
    </div>

</div>
<div id="menuWrapper">
    <a href="/">Главная</a>
    {#<a href="/catalog/">Каталог обоев</a>#}
    {% for flatpage in flatpages %}
        <a href="{{flatpage.url}}">{{flatpage.title}}</a>
    {% endfor %}

    {% if user.is_authenticated %}
        {#<a href="/account">Личный кабинет</a>#}
    {% else %}
        <a href="/login">Авторизация</a>
    {% endif %}
</div>