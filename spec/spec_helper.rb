require 'rspec'
require 'capybara/dsl'
require 'capybara/widgets'

Capybara.run_server = false

RSpec.configure do |c|
  c.include Capybara::Widgets
  c.include Capybara::DSL
end