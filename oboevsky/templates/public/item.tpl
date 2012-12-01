{% extends "public/inc/common_sitepage.tpl" %}

{% block content %}
    <style type="text/css">
        .selected_thumb {
            opacity: 0.5;
            cursor: default;
        }
    </style>
    <script type="text/javascript">
        function thumbnail_preview(s, image_url, image_shortdesc) {
            i = $('#itemPreview').get(0);
            $('.thumbsWrapper > img').removeClass( 'selected_thumb' );
            $( s ).addClass('selected_thumb');
            i.src = image_url;
            i.alt = image_shortdesc;
            $(i).removeAttr( 'width' );
            $(i).removeAttr( 'height' );
            $(i).css({width: "270px"});
        }

        (function($){
            $(window).load(function() {
                $(".itemThumbs").mCustomScrollbar({
                    set_height: '86px', 
                    set_width: '270px', 
                    horizontalScroll: true, 
                    scrollInertia: 550,
                    mouseWheel: true,
                    scrollButtons:{ 
                        enable:false, 
                        scrollType:"continuous", 
                        scrollSpeed:70, 
                        scrollAmount:100 
                    }
                });
            });
        })(jQuery);
    </script>

    <div class="contentBlockNoBorder">
        <div id="breadcrumps">
            <a href="/">Главная</a> / {{item.title}}
        </div>
        <div id="itemInfo" class="clear">
            <h1>{{item.title}}</h1>

            {% if item.images.all %}
                <div id="itemPreviewWrapper" class="right">
                    <img id="itemPreview" src="{{item.images.all.0.image.url_284x201}}" alt="{{item.images.all.0.short_desc}}"
                     width="270px" />
                    {% if item.images.all|length > 1 %}
                    <div class="itemThumbs" class="clear">
                        <div class="thumbsWrapper">
                        {% for thumb in item.images.all %}
                            <img {% if forloop.first %}class="selected_thumb"{% endif %} alt="{{thumb.short_desc}}" src="{{thumb.image.url_170x111}}" height="70px"{# width="" #} 
                             onclick="javascript:thumbnail_preview( this, '{{thumb.image.url_284_201}}', '{{thumb.short_desc}}');" />
                        {% endfor %}
                        </div>
                    </div>
                    {% endif %}
                </div>
            {% endif %}

            <div class="itemAttribute clear">
                <div class="caption">Артикул:</div>
                <div class="left">{{item.sku}}</div>
            </div>
            <div class="itemAttribute clear">
                <div class="caption">Торговая марка:</div>
                <div class="left"><a href="{{item.producer.country.get_absolute_url}}"><img alt="{{item.producer.country.short_desc}}" align="absmiddle" src="{{item.producer.country.pic.url}}" /></a> <a href="{{item.producer.get_absolute_url}}" alt="{{item.producer.short_desc}}">{{item.producer.title}}</a></div>
            </div>
            {% if item.texture.all %}
                <div class="itemAttribute clear">
                    <div class="caption">Узоры:</div>
                    <div class="left">
                        {% for texture in item.texture.all %}
                            <a href="{{texture.get_absolute_url}}"><img src="{{texture.pic.url}}{# TODO?!?!? #}" alt="{{texture.short_desc}}" class="left icon" /></a>
                        {% endfor %}
                    </div>
                </div>
            {% endif %}
            {% if item.price %}
                <div class="itemAttribute clear">
                    <div class="caption">Цена:</div>
                    <div class="left">
                        {{item.price}} руб.
                    </div>
                </div>
            {% endif %}
            {% if item.sizes.all|length > 1 %}
                <div class="itemAttribute clear">
                    <div class="caption">Размеры:</div>
                    <div class="left">
                        {% for size in item.sizes.all %}
                            <li>{{size}}</li>
                        {% endfor %}
                    </div>
                </div>
            {% elif item.sizes.all %}
                <div class="itemAttribute clear">
                    <div class="caption">Размер:</div>
                    <div class="left">
                        {{item.sizes.all.0}}
                    </div>
                </div>
            {% endif %}
        </div>

        <p>&nbsp;</p>
        {{item.long_desc|safe}}
    </div>

    {% for iblock in item.info_blocks.all %}
        <div class="contentBlock">
            <h2>{{iblock.title}}</h2>
            {{iblock.content|safe}}
        </div>
    {% endfor %}

{% endblock %}