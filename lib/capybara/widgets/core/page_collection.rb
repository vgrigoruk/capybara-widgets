require 'active_support/core_ext/class/attribute'
require 'singleton'

module Capybara
  module Widgets
    class PageCollection
      include Singleton

      attr_accessor :registry

      class_attribute :load_path

      def initialize
        self.registry = Array.new
        @loaded = false
      end

      def current_page_class
        load_classes unless @loaded
        klass = registry.detect do |page_class|
          if page_class.path_matcher?
            if page_class.path_matcher.is_a?(Regexp)
              Capybara.current_path =~ page_class.path_matcher
            elsif page_class.path_matcher.is_a?(String)
              Capybara.current_path.include?(page_class.path_matcher)
            end
          else
            if page_class.path?
              Capybara.current_path.include?(page_class.path)
            else
              false
            end
          end
        end
        raise "Not found" if klass.nil?
        klass
      end

      private

      def load_classes
        Dir[File.join(load_path, "**/*.rb")].each{|f| require f}
        @loaded = true
      end
    end
  end
end

def current_page
  Capybara::Widgets::PageCollection.instance.current_page_class.new
end
