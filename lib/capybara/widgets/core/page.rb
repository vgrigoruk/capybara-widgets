require_relative 'widget'
require_relative 'page_collection'
require_relative '../helpers/async_helper'
require 'active_support/core_ext/class/attribute'

module Capybara
  module Widgets
    class Page < Widget

      include Capybara::Widgets::AsyncHelper

      class_attribute :path
      class_attribute :path_matcher

      def self.inherited(subclass)
        PageCollection.instance.registry << subclass
      end

      def initialize
        super(page)
      end

      def loaded?
        result = opened?
        if self.respond_to?(:elements_loaded?)
          result = result && elements_loaded?
        end
        result
      end

      def opened?
        eventually do
          result = self.path_matcher? ?
              current_path =~ self.path_matcher :
              current_path =~ %r{#{Regexp.quote(self.path)}}
          raise "#{self.class.name} is not opened" unless result
          result
        end
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

