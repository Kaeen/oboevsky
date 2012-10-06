{% load i18n admin_static admin_modify %}
<div class="inline-group" id="{{ inline_admin_formset.formset.prefix }}-group">
  <div class="tabular inline-related {% if forloop.last %}last-related{% endif %}">
{{ inline_admin_formset.formset.management_form }}
<fieldset class="module">
   <h2>{{ inline_admin_formset.opts.verbose_name_plural|capfirst }}</h2>
   {{ inline_admin_formset.formset.non_form_errors }}
   <table>
     <thead><tr>
     {% for field in inline_admin_formset.fields %}
       {% if not field.widget.is_hidden %}
         <th{% if forloop.first %} colspan="2"{% endif %}{% if field.required %} class="required"{% endif %}>{{ field.label|capfirst }}
         {% if field.help_text %}&nbsp;<img src="{% static "admin/img/icon-unknown.gif" %}" class="help help-tooltip" width="10" height="10" alt="({{ field.help_text|striptags }})" title="{{ field.help_text|striptags }}" />{% endif %}
         </th>
       {% endif %}
     {% endfor %}
     {% if inline_admin_formset.formset.can_delete %}<th>{% trans "Delete?" %}</th>{% endif %}
     </tr></thead>

     <tbody>
     {% for inline_admin_form in inline_admin_formset %}
        {% if inline_admin_form.form.non_field_errors %}
        <tr><td colspan="{{ inline_admin_form|cell_count }}">{{ inline_admin_form.form.non_field_errors }}</td></tr>
        {% endif %}
        <tr class="form-row {% cycle "row1" "row2" %} {% if inline_admin_form.original or inline_admin_form.show_url %}has_original{% endif %}{% if forloop.last %} empty-form{% endif %}"
             id="{{ inline_admin_formset.formset.prefix }}-{% if not forloop.last %}{{ forloop.counter0 }}{% else %}empty{% endif %}">
        <td class="original">
          {% if inline_admin_form.original or inline_admin_form.show_url %}<p>
            {% if inline_admin_form.original %} {{ inline_admin_form.original }}{% endif %}
            {% if inline_admin_form.show_url %}<a href="../../../r/{{ inline_admin_form.original_content_type_id }}/{{ inline_admin_form.original.id }}/">{% trans "View on site" %}</a>{% endif %}
            </p>
          {% endif %}

          {% if inline_admin_form.has_auto_field %}{{ inline_admin_form.pk_field.field }}{% endif %}
          {{ inline_admin_form.fk_field.field }}
          {% spaceless %}
          {% for fieldset in inline_admin_form %}
            {% for line in fieldset %}
              {% for field in line %}
                {% if field.is_hidden %} {{ field.field }} {% endif %}
              {% endfor %}
            {% endfor %}
          {% endfor %}
          {% endspaceless %}
        </td>
        {% for fieldset in inline_admin_form %}
          {% for line in fieldset %}
            {% for field in line %}
              <td{% if field.field.name %} class="field-{{ field.field.name }}"{% endif %}>
              {% if field.is_readonly %}
                  <p>{{ field.contents }}</p>
              {% else %}
                  {{ field.field.errors.as_ul }}
                  {{ field.field }}
                  {{ get_preview_html }}
              {% endif %}
              </td>
            {% endfor %}
          {% endfor %}
        {% endfor %}
        {% if inline_admin_formset.formset.can_delete %}
          <td class="delete">{% if inline_admin_form.original %}{{ inline_admin_form.deletion_field.field }}{% endif %}</td>
        {% endif %}
        </tr>
     {% endfor %}
     </tbody>
   </table>
</fieldset>
  </div>
</div>

<script type="text/javascript">
(function($) {
    $(document).ready(function($) {
        var rows = "#{{ inline_admin_formset.formset.prefix }}-group .tabular.inline-related tbody tr";
        var alternatingRows = function(row) {
            $(rows).not(".add-row").removeClass("row1 row2")
                .filter(":even").addClass("row1").end()
                .filter(rows + ":odd").addClass("row2");
        }
        var reinitDateTimeShortCuts = function() {
            // Reinitialize the calendar and clock widgets by force
            if (typeof DateTimeShortcuts != "undefined") {
                $(".datetimeshortcuts").remove();
                DateTimeShortcuts.init();
            }
        }
        var updateSelectFilter = function() {
            // If any SelectFilter widgets are a part of the new form,
            // instantiate a new SelectFilter instance for it.
            if (typeof SelectFilter != "undefined"){
                $(".selectfilter").each(function(index, value){
                  var namearr = value.name.split('-');
                  SelectFilter.init(value.id, namearr[namearr.length-1], false, "{% static "admin/" %}");
                });
                $(".selectfilterstacked").each(function(index, value){
                  var namearr = value.name.split('-');
                  SelectFilter.init(value.id, namearr[namearr.length-1], true, "{% static "admin/" %}");
                });
            }
        }
        var initPrepopulatedFields = function(row) {
            row.find('.prepopulated_field').each(function() {
                var field = $(this);
                var input = field.find('input, select, textarea');
                var dependency_list = input.data('dependency_list') || [];
                var dependencies = [];
                $.each(dependency_list, function(i, field_name) {
                  dependencies.push('#' + row.find('.field-' + field_name).find('input, select, textarea').attr('id'));
                });
                if (dependencies.length) {
                    input.prepopulate(dependencies, input.attr('maxlength'));
                }
            });
        }
        $(rows).formset({
            prefix: "{{ inline_admin_formset.formset.prefix }}",
            addText: "{% blocktrans with verbose_name=inline_admin_formset.opts.verbose_name|title %}Add another {{ verbose_name }}{% endblocktrans %}",
            formCssClass: "dynamic-{{ inline_admin_formset.formset.prefix }}",
            deleteCssClass: "inline-deletelink",
            deleteText: "{% trans "Remove" %}",
            emptyCssClass: "empty-form",
            removed: alternatingRows,
            added: (function(row) {
                initPrepopulatedFields(row);
                reinitDateTimeShortCuts();
                updateSelectFilter();
                alternatingRows(row);
            })
        });
    });
})(django.jQuery);
</script>
