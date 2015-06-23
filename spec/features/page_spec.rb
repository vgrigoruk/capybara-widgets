require_relative '../spec_helper'

describe Capybara::Widgets::Page do
  let(:klass) { Capybara::Widgets::Page }

  it 'has page as a root' do
    expect(klass.new.root).to eq(page)
  end
end
