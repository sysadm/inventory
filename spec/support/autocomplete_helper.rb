module AutocompleteHelper
  def fill_autocomplete(field, options = {})
    fill_in field, with: options[:with]

    page.execute_script %Q{ $('##{field}').trigger('focus') }
    page.execute_script %Q{ $('##{field}').trigger('keydown') }
    selector = %Q{ul.ui-autocomplete li.ui-menu-item:contains("#{options[:select]}")}

    page.should have_selector('ul.ui-autocomplete li.ui-menu-item')
    page.execute_script %Q{ $('#{selector}').trigger('mouseenter').click() }
  end
end

