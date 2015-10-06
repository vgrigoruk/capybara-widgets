require "capybara/widgets/version"

module Capybara
  module Widgets
    autoload :Widget, 'capybara/widgets/core/widget'
    autoload :Page, 'capybara/widgets/core/page'
    autoload :PageCollection, 'capybara/widgets/core/page_collection'
  end
end
