require 'capybara/dsl'
require 'active_support/core_ext/class/attribute'
require_relative '../helpers/async_helper'
require_relative 'execution_hooks'


module Capybara
  module Widgets
    class Widget
      include Capybara::DSL
      include Capybara::Widgets::AsyncHelper

      include ExecutionHooks

      before_hook :set_target_app,
                  ignore: [
                      :driver, :driver=, :driver?,
                      :session_name, :session_name=, :session_name?,
                      :default_selector, :default_selector=, :default_selector?
                  ]

      class_attribute :driver, :session_name, :default_selector

      self.driver = Capybara.current_driver
      self.session_name = Capybara.session_name
      self.default_selector = Capybara.default_selector

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

      # @deprecated, use :root_element method instead
      def narrow
        @root
      end

      def resolve(*query_with_args)
        query = query_with_args.shift
        args = query_with_args
        if query.is_a?(Proc)
          # resolve lambda selector in scope of widget instance
          return self.instance_exec(*args, &query)
        else
          return query, *args
        end
      end

      class << self

        ## override :narrow method if :root_element is used in a class
        def root_element(*query)
          define_method(:root_query) { resolve(*query) }
          define_method(:narrow) { root.find(*resolve(*query)) }
          define_method(:has_root_element?) { page.has_selector?(*resolve(*query))}
          define_method(:has_no_root_element?) { page.has_no_selector?(*resolve(*query))}
        end

        def component(name, klass, *query)
          define_method name do |*args|
            component_root = query.length > 0 ? root.find(*resolve(*query, *args)) : root
            klass.new(component_root)
          end
          define_method "has_#{name}?".to_sym do |*args|
            root.has_selector?(*resolve(*query, *args))
          end
          define_method "has_no_#{name}?" do |*args|
            root.has_no_selector?(*resolve(*query, *args))
          end
        end

        def element(name, *query)
          define_method("#{name}!") { |*args| root.find(*resolve(*query, *args)).click }
          define_method(name) { |*args| root.find(*resolve(*query, *args)) }
          define_method("#{name}=") { |arg| root.find(*resolve(*query)).set(arg) }
          define_method("has_#{name}?") { |*args| root.has_selector?(*resolve(*query, *args)) }
          define_method("has_no_#{name}?") { |*args| root.has_no_selector?(*resolve(*query, *args)) }
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

      # delegate missing methods to the @root node
      def method_missing(method_sym, *arguments, &block)
        if root.respond_to? method_sym
          root.send(method_sym, *arguments, &block)
        else
          super
        end
      end

      private

      def set_target_app
        if Capybara.current_driver != driver || Capybara.session_name != session_name || Capybara.default_selector != default_selector
          puts "Switching target: #{driver}:#{session_name}:#{default_selector}"
          Capybara.current_driver = self.driver
          Capybara.session_name = self.session_name
          Capybara.default_selector = self.default_selector
        end
      end
    end
  end
end
