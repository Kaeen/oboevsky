{% extends "public/inc/common_sitepage.tpl" %}

{% block page_title %}{{block.super}} — {{item.title}}, обои {{item.producer.title}}, {{item.producer.country.title}}{% endblock %}
{% block meta_description %}{{item.short_desc}}{% endblock %}
{% block meta_keywords %}Обоевский обои {{item.producer.title}} {{item.producer.country.title}}{#{% for t in item.materials %} {{t.title}}{% endfor %}#} {{item.sku}}{% endblock %}


{% block content %}
    <style type="text/css">
        #fullView {
            background-color: rgba(195, 195, 195, 0.7);
            display: block;
            position: absolute;
            width: 100%;
            padding-top: 50px;
            top: 0;
            left: 0;
            width: 100%;
            text-align: center;
        }

        #fullView img {
            border: 3px solid #847171;
            padding: 20px;
            background-color: #FFF;
        }

        .selected_thumb {
            opacity: 0.5;
            cursor: default;
        }
    </style>
    <script type="text/javascript">
        function view(image_url) {
            $('#fullView').remove();
            $('body').append('<div id="fullView" onclick="javascript:$(\'#fullView\').empty().remove();"><img src="' + image_url + '"/></div>');
            $('#fullView').css({'height': $('body').height()});
        }

        function thumbnail_preview(s, image_url, image_shortdesc, full_url) {
            i = $('#itemPreview').get(0);
            $('.thumbsWrapper > img').removeClass( 'selected_thumb' );
            $( s ).addClass('selected_thumb');
            i.src = image_url;
            i.alt = image_shortdesc;
            $(i).removeAttr( 'width' );
            $(i).removeAttr( 'height' );
            $(i).removeAttr('onclick');
            $( i ).click( function () {
                view(full_url);
            } );
            $(i).css({"max-width": "270px"});
        }


        function _blank(url) {
            window.open(url, '_blank');
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
        <style type="text/css">
            #collection-nav-container {
                height: 2em;
                padding: .3em;
                margin: .7em 0 1em;
            }

            .left-collection-nav, 
            .right-collection-nav {
                height: 1em;
                margin: .3em;
                display: block;
            }
        </style>

        {% if no_breadcrumps %}
            <h1>{{item.title}}</h1>
            <div id="collection-nav-container" class="clear">
                {% if previous %}
                    <div class="left left-collection-nav"><a href="{{previous.get_absolute_url}}?q={{q}}">&larr; {{previous.title}}</a></div>
                {% endif %}
                {% if next %}
                    <div class="right right-collection-nav"><a href="{{next.get_absolute_url}}?q={{q}}">{{next.title}} &rarr;</a></div>
                {% endif %}
            </div>
        {% else %}
            <div id="breadcrumps">
                <a href="/">Главная</a> / {{item.title}}
            </div>
        {% endif %}

        <div id="itemInfo" class="clear">
            {%  if not no_breadcrumps %}
            <h1>{{item.title}}</h1>
            {% endif %}

            {% if item.images.all %}
                <div id="itemPreviewWrapper" class="right" {% if no_breadcrumps %}style="margin-top:0px;"{% endif %}>
                    <img id="itemPreview" src="{{item.images.all.0.image.url_284x185}}" alt="{{item.images.all.0.short_desc}}"
                     {#width="270px"#} style="cursor:pointer; max-width:270px;" onclick="javascript:view('{{item.images.all.0.image.url}}');" />
                    {% if item.images.all|length > 1 %}
                    <div class="itemThumbs" class="clear">
                        <div class="thumbsWrapper">
                        {% for thumb in item.images.all %}
                            <img {% if forloop.first %}class="selected_thumb"{% endif %} alt="{{thumb.short_desc}}" src="{{thumb.image.url_170x111}}" height="70px"{# width="" #} 
                             onclick="javascript:thumbnail_preview( this, '{{thumb.image.url_284x185}}', '{{thumb.short_desc}}', '{{thumb.image.url}}');" />
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
                <div class="left"><a href="{{item.producer.country.get_absolute_url}}"><img alt="{{item.producer.country.short_desc}}" align="absmiddle" src="{{item.producer.country.pic.url_13x20}}" /></a> <a href="{{item.producer.get_absolute_url}}" alt="{{item.producer.short_desc}}">{{item.producer.title}}</a></div>
            </div>
            {% if item.texture.all %}
                <div class="itemAttribute clear">
                    <div class="caption">Узоры:</div>
                    <div class="left">
                        {% for texture in item.texture.all %}
                            <a href="{{texture.get_absolute_url}}"><img src="{{texture.pic.url_28x28}}{# TODO?!?!? #}" alt="{{texture.short_desc}}" class="left icon" /></a>
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

            <p>&nbsp;</p>
            <p>&nbsp;</p>

            <div class="itemAttribute clear">
                <div class="caption"><a class="buy-link" href="/put-to-cart/{{item.pk}}">Купить</a></div>
            </div>

        </div>

        <p>&nbsp;</p>

        <div id="itemLongDescription">
        {{item.long_desc|safe}}
        </div>

        <p>&nbsp;</p>

    </div>

    {% for iblock in item.info_blocks.all %}
        <div class="contentBlock">
            <h2>{{iblock.title}}</h2>
            {{iblock.content|safe}}
        </div>
    {% endfor %}

{% endblock %}