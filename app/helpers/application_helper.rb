module ApplicationHelper

  SITE_TITLE = "Better Draw a District"
  def page_title
    @page_title ? "#{@page_title} | #{SITE_TITLE}" : SITE_TITLE
  end

  def boolean_markup(bool)
    entity = bool ? '&#x2713;' : '&#x2715;'
    css_class = bool ? 'yes' : 'no'
    content_tag(:span, entity.html_safe, :class => css_class)
  end

end
