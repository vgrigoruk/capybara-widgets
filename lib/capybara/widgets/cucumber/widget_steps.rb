module Capybara::Widgets::Cucumber

  include Capybara::Widgets::StringHelpers

  def within_widget(klass)
    raise "#{klass.name} is not a subclass of Widget" unless klass < Capybara::Widgets::Widget
    yield klass.new
  end

  When(/^I click "([^"]*)" in a "([^"]*)"$/) do |action, widget_name|
    within_widget(to_widget_class(widget_name)) do |widget|
      widget.send(to_widget_action(action, '!'))
    end
  end

  Then(/^the "([^"]*)" should( not)? be displayed$/) do |widget_name, negated|
    widget_class = to_widget_class(widget_name)
    within_widget(widget_class) do |widget|
      if negated
        expect(widget).to be_not_displayed, "#{widget_class} should not be displayed"
      else
        expect(widget).to be_displayed, "#{widget_class} should be displayed"
      end
    end
  end

  When(/^I set "([^"]*)" to "([^"]*)" in a "([^"]*)"$/) do |field_name, value, widget_name|
    within_widget(to_widget_class(widget_name)) do |widget|
      widget.send(to_widget_action(field_name, '='), value)
    end
  end

  And(/^I should see the following "([^"]*)" in a "([^"]*)"$/) do |field_name, widget_name, table|
    expected_values = table.raw.flatten
    within_widget(to_widget_class(widget_name)) do |widget|
      actual_values = widget.send(to_widget_action(field_name))
      expect(actual_values).to eq(expected_values)
    end
  end

  When(/^I fill in the following in a "([^"]*)"$/) do |widget_name, table|
    fields = table.rows_hash
    within_widget(to_widget_class(widget_name)) do |widget|
      fields.each do |k,v|
        widget.send(to_widget_action(k, '='), v)
      end
    end
  end

  And(/^the "([^"]*)" should be "([^"]*)" in a "([^"]*)"$/) do |field_name, expected, widget_name|
    within_widget(to_widget_class(widget_name)) do |widget|
      action = to_widget_action(field_name)
      if widget.respond_to? "has_#{action}?"
        expect(widget.send("has_#{action}?", expected)).to be_true
      else
        actual = widget.send(action)
        expect(actual).to eq(expected)
      end
    end
  end
end