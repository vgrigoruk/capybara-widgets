require 'cucumber'
require_relative '../helpers/string_helpers'

  World Capybara::Widgets::StringHelpers

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
      expect(page).to be_opened
    end
  end
