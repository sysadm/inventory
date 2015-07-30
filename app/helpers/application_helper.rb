module ApplicationHelper
  def other_langs
    (I18n.available_locales.map(&:to_s) - [I18n.locale.to_s]).sort
  end
  def sortable(column, title = nil)
    title ||= column.titleize
    title = title
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column.downcase == sort_column.downcase && sort_direction == "desc" ? "asc" : "desc"
    unless css_class.nil?
      if direction.downcase == 'desc'
        title = title + ' ' + fa_icon('sort-desc')
      else
        title = title + ' ' + fa_icon('sort-asc')
      end
    end
    link_to title.html_safe, {:sort => column, :direction => direction.downcase}, {:class => css_class}
  end

end
