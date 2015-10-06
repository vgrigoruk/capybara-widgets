module Capybara
  module Widgets
    module DSL
      def within_widget(klass)
        raise "#{klass.name} is not a subclass of Widget" unless klass < Capybara::Widgets::Widget
        yield klass.new
      end
    end
  end
end