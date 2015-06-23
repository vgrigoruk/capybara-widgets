module Capybara::Widgets::StringHelpers
  def to_widget_class(name)
    name.to_s.gsub(' ','_').classify.constantize
  end

  def to_widget_action(name, suffix=nil)
    "#{name.to_s.downcase.gsub(' ','_')}#{suffix}"
  end
end