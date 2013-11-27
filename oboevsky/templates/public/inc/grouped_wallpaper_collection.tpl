    {% for group in items %}
        <div class="contentBlock">
            <div>
                <a href="{{group.1}}"><h2>{{group.0}}</h2></a>
                <div class="items clear">
                    {% for item in group.2 %}

                        {% if forloop.counter == 9 %}

                        	{% if forloop.last %}

                        		{% include "public/inc/wallpapers_list_item.tpl" %}
                        		<div class="spacer"></div>

                        	{% else %}
	                            <script>
	                            function hide_items_{{item.id}}() {
	                            	$('#trigger-{{item.id}}').text('Показать ({{group.2|slice:"8:"|length}})').attr('href', 'javascript: show_items_{{item.id}}();');
	                            	$('#items-group-{{item.id}}').before($('#trigger-{{item.id}}'));
	                                $('#items-group-{{item.id}}').hide();

	                            }

	                            function show_items_{{item.id}}() {
	                            	$('#trigger-{{item.id}}').text('Свернуть').attr('href', 'javascript: hide_items_{{item.id}}();').appendTo('#items-group-{{item.id}}');
	                                $('#items-group-{{item.id}}').show();
	                            }

	                            function fetch_items_{{item.id}}() {
	                                $('#trigger-{{item.id}}').text('Секундочку...');
	                                $.getJSON('http://oboevsky.ru/get-items-collection/{{item.id}}{% for t in group.2|slice:"8:" %},{{t.id}}{% endfor %}/',
	                                    function(data) {
	                                        $.each(data, function(k, v) {

	                                            $('#items-group-{{item.id}}').append(
	                                                $('<div class="item new-look" style="background:url(\''+v['image']+'\'); cursor:pointer;" onClick="javascript:document.location.href="'+v['url']+'?q={{group.2.0.id}}{% for t in group.2|slice:"1:" %},{{t.id}}{% endfor %}"><a href="'+v['url']+'?q={{group.2.0.id}}{% for t in group.2|slice:"1:" %},{{t.id}}{% endfor %}"><img src="'+v['image']+'" alt="'+v['shortdesc']+'" /></a><p class="title-container"><a href="'+v['url']+'?q={{group.2.0.id}}{% for t in group.2|slice:"1:" %},{{t.id}}{% endfor %}"><b style="text-decoration:none;">'+v['title']+'</b></a><br />'+v['price']+' руб.</p><p><a class="buy-link" href="/put-to-cart/'+v['pk']+'">Купить</a></p></div>')
	                                            );
	                                            if( (k + 3) % 3 == 0) {$('#items-group-{{item.id}}').append('<div class="spacer"></div>');}
	                                        });
	                                    })
										.done(function() {
											show_items_{{item.id}}();
										})
										.fail(function() {
											alert('Произошла ошибка при попытке загрузки коллекции обоев. Пожалуйста, попробуйте обновить страницу и загрузить их снова, а также проверьте соединение с интернетом. ');
											$('#trigger-{{item.id}}').text('Показать&nbsp;остальные ({{group.2|slice:"8:"|length}})');
										});
	                            }
	                            </script>
	                            <a id="trigger-{{item.id}}" href="javascript:fetch_items_{{item.id}}();" style="width:169px; height:169px; line-height: 160px; text-align:center; display:block; float: left;">Показать&nbsp;остальные ({{group.2|slice:"8:"|length}})</a>
	                            <div style="display:none" id="items-group-{{item.id}}">


	                            {% if group.2|slice:"8:"|length < 2 %}
	                                </div>
	                            {% endif %}

	                        {% endif %}
                        {% endif %}

                        {% if forloop.counter < 9 %}
                            {% include "public/inc/wallpapers_list_item.tpl" %}
                            {% if forloop.counter|divisibleby:"3" %}
                                <div class="spacer"></div>
                            {% endif %}
                        {% endif %}


                        {% if forloop.counter > 9 %}
                            {% if forloop.last %}
                                </div>
                            {% endif %}
                        {% endif %}

                    {% endfor %}

                </div>
            </div>
        </div>
    {% endfor %}