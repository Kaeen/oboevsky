{% extends "public/inc/common_template.tpl" %}

{% block page_title %}Обоевский{% endblock %}

{% block body %}
<div id="pageWrapper">
    {% block page_header %}
        {% include "public/inc/common_page_header.tpl" %}
    {% endblock %}

    {% block page_content_wrapper %}
    <div id="contentWrapper" class="clear">
        {% block left_sidebar %}
        <div class="pageSidebar left">
            <div class="pageColumn">
                <h2>Категории обоев</h2>
                <ul>
                    <li>
                        <h3>Обои по назначению</h3>
                        <ul>
                            <li><a href="#">Для спальни</a></li>
                            <li><a href="#">Для гостинной</a></li>
                            <li><a href="#">Для кузни</a></li>
                            <li><a href="#">Для детской</a></li>
                            <li><a href="#">Для прихожей</a></li>
                            <li><a href="#">Для офиса</a></li>
                        </ul>
                    </li>
                    <li>
                        <h3>Обои по странам</h3>
                        <ul>
                            <li><a href="#"><img src="static/images/sample_italy.png" align="absmiddle" /> Италия</a></li>
                            <li><a href="#"><img src="static/images/sample_sweden.png" align="absmiddle" /> Швеция</a></li>
                            <li><a href="#"><img src="static/images/sample_england.png" align="absmiddle" /> Англия</a></li>
                        </ul>
                    </li>
                    <li>
                        <h3>Виды обоев</h3>
                        <ul>
                            <li><a href="#">Бумажные</a></li>
                            <li><a href="#">Виниловые</a></li>
                            <li><a href="#">Флезилиновые</a></li>
                            <li><a href="#">Текстильные</a></li>
                            <li><a href="#">Флоковые</a></li>
                            <li><a href="#">Натуральные</a></li>
                        </ul>
                    </li>
                </ul>
            </div>

            <div class="pageColumn">
                <h2>Категории обоев</h2>
                <ul class="no-list">
                    <li><a href="#">ABC</a></li>
                    <li><a href="#">АРТ</a></li>
                    <li><a href="#">Alev Designs</a></li>
                    <li><a href="#">Artshow</a></li>
                    <li><a href="#">AS Creation</a></li>
                    <li><a href="#">Blue Mountain</a></li>
                    <li><a href="#">BN international</a></li>
                    <li><a href="#">Carl Robinson</a></li>
                    <li><a href="#">Cosmos Wallpaper</a></li>
                    <li><a href="#">Cosca</a></li>
                    <li><a href="#">Coswig</a></li>
                    <li><a href="#">Decor Maison</a></li>
                    <li><a href="#">Decori &amp; Decori</a></li>
                    <li><a href="#">Duro</a></li>
                    <li><a href="#">Emiliana Parati</a></li>
                    <li><a href="#">Erismann-R</a></li>
                    <li><a href="#">Father &amp; Sons</a></li>
                    <li><a href="#">Graham &amp; Brown</a></li>
                    <li><a href="#">Grandeco</a></li>
                    <li><a href="#">Grantil</a></li>
                    <li><a href="#">Hohenberger</a></li>
                    <li><a href="#">Holden Decor</a></li>
                    <li><a href="#">Hookedonwalls</a></li>
                    <li><a href="#">Ideco</a></li>
                    <li><a href="#">Inverno</a></li>
                    <li><a href="#">Jannelli &amp; Volpi</a></li>
                    <li><a href="#">Jacquards</a></li>
                    <li><a href="#">KT Exclusive</a></li>
                    <li><a href="#">LG</a></li>
                    <li><a href="#">Limonta</a></li>
                    <li><a href="#">Living in Style</a></li>
                    <li><a href="#">Marburg</a></li>
                    <li><a href="#">Nextwall</a></li>
                    <li><a href="#">Norwall</a></li>
                    <li><a href="#">Portofino</a></li>
                    <li><a href="#">P+S International</a></li>
                    <li><a href="#">Rasch</a></li>
                    <li><a href="#">Rasch-Textil</a></li>
                    <li><a href="#">Sandudd</a></li>
                    <li><a href="#">Seabrook</a></li>
                    <li><a href="#">SergioRossellini</a></li>
                    <li><a href="#">Sintra</a></li>
                    <li><a href="#">Sirpi</a></li>
                    <li><a href="#">Texdecor</a></li>
                    <li><a href="#">Thibaut</a></li>
                    <li><a href="#">Victoria Stenova</a></li>
                    <li><a href="#">Wallquest</a></li>
                    <li><a href="#">Wilman</a></li>
                    <li><a href="#">York</a></li>
                    <li><a href="#">Zambaiti</a></li>
                    <li><a href="#">Палитра</a></li>
                </ul>
            </div>
        </div>
        {% endblock %}

        {% block right_sidebar %}
        <div class="pageSidebar right">
            <div class="pageColumn">
                <h2>Поиск</h2>
                <p class="text-center">TODO</p>
            </div>

            <div class="pageColumn">
                <h2>Корзина</h2>
                <p class="text-center">В Вашей корзине нет товаров</p>
            </div>

            <a href="#">
            <div class="pageColumn">
                <br />
                <h2>Заказать образец</h2>
            </div>
            </a>
        </div>
        {% endblock %}

        <div id="content">
            {% block content %}-- CONTENT!? --{% endblock %}
        </div>
    </div>
    {% endblock %}

    {% block page_footer %}
        {% include "public/inc/common_page_footer.tpl" %}
    {% endblock %}
</div>
{% endblock %}