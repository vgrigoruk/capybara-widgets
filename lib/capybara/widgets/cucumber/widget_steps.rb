require 'cucumber'
require_relative '../helpers/string_helpers'
require_relative '../core/dsl'

World Capybara::Widgets::StringHelpers
World Capybara::Widgets::DSL

def resolve_widget(widget_chain)
  elements = widget_chain.split('->')
  widget_klass = to_widget_class(elements[0])
  action_chain = elements[1..-1].map { |e| to_widget_action(e) }

  top_widget = widget_klass.new
  apply_action_chain(top_widget, action_chain)
end

When(/^I click "([^"]*)" [o|i]n a "([^"]*)"$/) do |action, widget_path|
  target_widget = resolve_widget(widget_path)
  target_widget.send(to_widget_action(action, '!'))
end

Then(/^the "([^"]*)" should( not)? be displayed$/) do |widget_path, negated|
  target_widget = resolve_widget(widget_path)
  if negated
    expect(target_widget).to be_not_displayed, "#{target_widget} should not be displayed"
  else
    expect(target_widget).to be_displayed, "#{target_widget} should be displayed"
  end
end

When(/^I set "([^"]*)" to "([^"]*)" in a "([^"]*)"$/) do |field_name, value, widget_path|
  target_widget = resolve_widget(widget_path)
  target_widget.send(to_widget_action(field_name, '='), value)
end

# Example:
# I open "My Report" from a "Reports page"
# is mapped to:
# ReportsPage.new.open!("My Report")
When(/^I (.*) "([^"]*)" from a "([^"]*)"$/) do |action_name, action_param, widget_path|
  target_widget = resolve_widget(widget_path)
  target_widget.send(to_widget_action(action_name, '!'), action_param)
end


And(/^I should see the following "([^"]*)" in a "([^"]*)"$/) do |field_name, widget_path, table|
  expected_values = table.raw.flatten
  target_widget = resolve_widget(widget_path)
  actual_values = target_widget.send(to_widget_action(field_name))
  expect(actual_values).to eq(expected_values)
end

# Expectation. Examples:
# I should see "Do it" action on a "My page"
# is mapped to: expect(MyPage.new).to have_action("Do it")
# I should not see "Do it" action in a "My widget"
# is mapped to: expect(MyWidget.new).to have_no_action("Do it")
# I should see "Do it" value in a "My page -> page component"
# is mapped to: expect(MyPage.new.page_component).to have_value("Do it")
And(/^I should( not)? see "([^"]*)" (.*) (?:in|on) a "([^"]*)"$/) do |negated, content, widget_action, widget_path|
  negation_prefix = (negated && negated.length > 0) ? 'no_' : ''
  target_widget = resolve_widget(widget_path)
  expect(target_widget).to send("have_#{negation_prefix}#{to_widget_action(widget_action)}", content)
end

When(/^I fill in the following in a "([^"]*)"$/) do |widget_name, table|
  fields = table.rows_hash
  within_widget(to_widget_class(widget_name)) do |widget|
    fields.each do |k, v|
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