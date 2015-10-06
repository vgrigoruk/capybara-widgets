require 'cucumber'
require_relative '../helpers/string_helpers'
require_relative '../helpers/async_helper'

World Capybara::Widgets::StringHelpers
World Capybara::Widgets::AsyncHelper

Given(/^I am on a (.* page)/) do |page_name|
  within_widget(to_widget_class(page_name)) do |page|
    page.open!
  end
end

When(/^I navigate to a (.* page)/) do |page_name|
  within_widget(to_widget_class(page_name)) do |page|
    page.open!
  end
end

Then(/^I should be on a (.* page)/) do |page_name|
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

