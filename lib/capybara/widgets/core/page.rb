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
      class_attribute :url_matcher

      def self.inherited(subclass)
        PageCollection.instance.registry << subclass
      end

      def initialize
        super(page)
      end

      def loaded?
        result = opened?
        if self.respond_to?(:components_loaded?)
          result = result && self.components_loaded?
        end
        if self.respond_to?(:elements_loaded?)
          result = result && self.elements_loaded?
        end
        result
      end

      def opened?
        if self.path_matcher?
          has_current_path?(self.path_matcher, only_path: true)
        elsif self.url_matcher?
          has_current_path?(self.url_matcher, url: true)
        else
          has_current_path?(%r{#{Regexp.quote(self.path)}}, only_path: true)
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


