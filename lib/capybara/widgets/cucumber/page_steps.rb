require 'cucumber'
require_relative '../helpers/string_helpers'
require_relative '../helpers/async_helper'
require_relative '../core/dsl'

World Capybara::Widgets::StringHelpers
World Capybara::Widgets::AsyncHelper
World Capybara::Widgets::DSL

Given(/^I am on (?:a\s|an\s)?(.* page)/) do |page_name|
  within_widget(to_widget_class(page_name)) do |page|
    page.open!
  end
end

When(/^I navigate to (?:a\s|an\s)?(.* page)/) do |page_name|
  within_widget(to_widget_class(page_name)) do |page|
    page.open!
  end
end

Then(/^I should be on (?:a\s|an\s)?(.* page)/) do |page_name|
  within_widget(to_widget_class(page_name)) do |page|
    eventually { expect(page).to be_loaded }
  end
end

When(/^I click "([^"]*)"$/) do |action|
  current_page.send(to_widget_action(action, '!'))
end

When(/^I set "([^"]*)" to "([^"]*)"$/) do |field_name, value|
  current_page.send(to_widget_action(field_name, '='), value)
end

And(/^I should( not)? see( \d+)? "([^"]*)" ([^"]*s?)$/) do |negated, count, content, widget_action|
  negation_prefix = (negated && negated.length > 0) ? 'no_' : ''
  expected_count = (count && count.length > 0) ? count.strip.to_i : 1
  if expected_count > 1
    expect(current_page).to send("have_#{negation_prefix}#{to_widget_action(widget_action)}", content, count)
  else
    expect(current_page).to send("have_#{negation_prefix}#{to_widget_action(widget_action)}", content)
  end
end

