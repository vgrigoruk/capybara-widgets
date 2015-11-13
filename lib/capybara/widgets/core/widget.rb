require 'capybara/dsl'
require_relative '../helpers/async_helper'

module Capybara
  module Widgets
    class Widget
      include Capybara::DSL
      include Capybara::Widgets::AsyncHelper

      def initialize(*search_scope)
        case search_scope.length
          when 0
            @root = page
          when 1
            @root = search_scope[0].respond_to?(:find) ? search_scope[0] : page.find(search_scope[0])
          else
            @root = page.find(*search_scope)
        end
        @narrowed = false
      end

      # running narrow only before a first call to root,
      # useful when you want to call a method on widget that uses "page" and you don't want to run "narrow" during init
      def root
        unless @narrowed
          @narrowed = true
          @root = narrow
        end
        @root
      end

      # override this method if you need to narrow down search context for a particular UI widget / block
      def narrow
        @root
      end

      def element(*query)
        root.find(*query)
      end

      def has_element?(*query)
        root.has_selector?(*query)
      end

      class << self
        def component(name, klass, *query)
          define_method name do |*args|
            component_root = query.length > 0 ? root.find(*query, *args) : root
            klass.new(component_root)
          end
        end

        def resolve(*query_with_args)
          query = query_with_args.shift
          args = query_with_args
          if query.is_a?(Proc)
            return query.(*args)
          else
            return query, *args
          end
        end

        def element(name, *query)
          define_method("#{name}!") { |*args| root.find(*Widget.resolve(*query, *args)).click }
          define_method(name) { |*args| root.find(*Widget.resolve(*query, *args)) }
          define_method("#{name}=") { |arg| root.find(*Widget.resolve(*query)).set(arg) }
          define_method("has_#{name}?") { |*args| root.has_selector?(*Widget.resolve(*query, *args)) }
          define_method("has_no_#{name}?") { |*args| root.has_no_selector?(*Widget.resolve(*query, *args)) }
        end

        def required_element(*element_names)
          define_method(:elements_loaded?) { element_names.map { |name| self.send("has_#{name}?") }.count(false) == 0 }
        end

        alias_method :required_elements, :required_element

        def required_component(*component_names)
          define_method(:components_loaded?) do
            component_names.map do |name|
              component = self.send(name)
              if component.respond_to?(:elements_loaded?)
                component.elements_loaded?
              else
                true
              end
            end.count(false) == 0
          end
        end

        alias_method :required_components, :required_component
      end

      def displayed?
        root.visible?
      end

      # delegate missing methods to the @root node
      def method_missing(method_sym, *arguments, &block)
        if root.respond_to? method_sym
          root.send(method_sym, *arguments, &block)
        else
          super
        end
      end
    end
  end
end
