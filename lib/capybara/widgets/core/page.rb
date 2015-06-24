require_relative 'widget'
require 'active_support/core_ext/class/attribute'

module Capybara
  module Widgets
    class Page < Widget

      class_attribute :path

      def initialize
        super(page)
      end

      def loaded?
        true
      end

      def reload!
        visit(current_url)
        loaded?
        self
      end

      def open!
        visit(self.path)
        loaded?
        self
      end
    end
  end
end

