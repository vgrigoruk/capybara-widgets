require_relative 'widget'
require 'active_support/core_ext/class/attribute'

module Capybara
  module Widgets

    class Page < Widget

      class_attribute :path

      def initialize
        super(page)
      end

      def reload!
        visit(current_url)
      end
    end
  end
end

