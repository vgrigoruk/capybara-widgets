require_relative '../spec_helper'

describe Capybara::Widgets::Widget do
  let(:klass) { Capybara::Widgets::Widget }
  let(:stub_node) { Capybara::Node::Base.new(nil, nil) }

  it 'has capybara page as a default root node' do
    expect(subject.root).to eq(page)
  end

  it 'can be initialized with Capybara::Node::Base' do
    expect(klass.new(stub_node).root).to eq(stub_node)
  end

  it 'can be initialized with string query' do
    allow_any_instance_of(Capybara::Session).to receive(:driver).and_return(nil)
    allow_any_instance_of(Capybara::Session).to receive(:find).with('.css-class').and_return(stub_node)
    expect(klass.new('.css-class').root).to eq(stub_node)
  end

  it 'can be initialized with full query' do
    allow_any_instance_of(Capybara::Session).to receive(:driver).and_return(nil)
    allow_any_instance_of(Capybara::Session).to receive(:find).with(:xpath, '//somexpath', text: 'text', wait: 2).and_return(stub_node)
    expect(klass.new(:xpath, '//somexpath', text: 'text', wait: 2).root).to eq(stub_node)
  end

  it 'can have lazy-initialized root node' do
    # Arrange 
    class MyWidget < klass   
      attr_accessor :loaded
      def initialize; self.loaded = false; end
      def narrow; self.loaded = true; @root; end
    end
    # Act and Assert
    widget = MyWidget.new
    expect(widget.loaded).to be_false
    widget.root
    expect(widget.loaded).to be_true
  end
end
