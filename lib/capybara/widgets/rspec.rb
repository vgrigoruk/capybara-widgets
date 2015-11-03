require_relative 'core/dsl'
require 'rspec/expectations'

module Capybara
  module Widgets
    module RSpecMatchers
      RSpec::Matchers.define :have_element do |element|
        match do |widget|
          widget.send("has_#{element}?".to_sym)
        end

        match_when_negated do |widget|
          widget.send("has_no_#{element}?".to_sym)
        end

        failure_message do |widget|
          "Expected that '#{widget.class.name}' has '#{element}' element"
        end

        failure_message_when_negated do |widget|
          "Expected that '#{widget.class.name}' does not have '#{element}' element"
        end
      end
    end
  end
end
