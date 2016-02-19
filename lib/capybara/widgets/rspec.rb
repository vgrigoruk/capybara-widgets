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

      RSpec::Matchers.define :be_visible do
        match do |widget|
          widget.has_root_element?
        end

        match_when_negated do |widget|
          widget.has_no_root_element?
        end

        failure_message do |widget|
          "Expected that '#{widget.class.name}' to be visible"
        end

        failure_message_when_negated do |widget|
          "Expected that '#{widget.class.name}' not to be visible"
        end
      end
      #
      # RSpec::Matchers.define :be_loaded do
      #   match do |page|
      #     page_opened = page.opened?
      #     if page.respond_to?(:components_loaded?)
      #       components_loaded = page.components_loaded?
      #     end
      #     if page.respond_to?(:elements_loaded?)
      #       elements_loaded = page.elements_loaded?
      #     end
      #     page_opened && components_loaded && elements_loaded
      #   end
      #
      #   match_when_negated do |_|
      #     raise "Unsupported negated matcher"
      #   end
      #
      #   failure_message do |page|
      #     page_opened = page.opened?
      #     components_loaded = page.respond_to?(:components_loaded?) ? page.components_loaded? : true
      #     elements_loaded = page.respond_to?(:elements_loaded?) ? page.elements_loaded? : true
      #     message = "Failed: "
      #     unless page_opened
      #       message = "#{page.class} is not opened.\n Actual: #{page.current_path}\nExpected: #{page.path_matcher || page.url_matcher || page.path }"
      #     end
      #     unless components_loaded
      #       message = "Some components are not loaded on #{page.class}"
      #     end
      #     unless elements_loaded
      #       message = "Some elements are not loaded on #{page.class}"
      #     end
      #     message
      #   end
      #
      #   failure_message_when_negated do |_|
      #     raise "Unsupported negated matcher"
      #   end
      # end
      #
    end
  end
end
