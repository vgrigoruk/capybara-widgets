require "capybara/widgets/version"

module Capybara
  module Widgets
    autoload :Widget, 'capybara/widgets/core/widget'
    autoload :Page, 'capybara/widgets/core/page'
  end
end
