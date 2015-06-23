require 'capybara/dsl'

module Capybara
  module Widgets
    class Widget
      include Capybara::DSL

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

      class << self
        def component(name, klass, *query)
          define_method name do
            component_root = query.length > 0 ? root.find(*query) : root
            klass.new(component_root)
          end
        end
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
