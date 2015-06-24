require 'active_support/core_ext/string/inflections'

module Capybara::Widgets::StringHelpers
  def to_widget_class(name)
    name.to_s.strip.gsub(' ','_').classify.constantize
  end

  def to_widget_action(name, suffix=nil)
    "#{name.to_s.strip.downcase.gsub(' ','_')}#{suffix}"
  end

  def apply_action_chain(widget, chain)
    if chain.length > 0
      next_widget = widget.send(chain[0])
      return apply_action_chain(next_widget, chain[1..-1])
    else
      return widget
    end
  end
end