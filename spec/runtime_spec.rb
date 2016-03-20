require "spec_helper"

describe Hal::Runtime do

  it "should be created with single-node definition" do
    root = Hal::Definition::Node.new(:gauge, '', '', {}, [], {})
    definition = Hal::Definition.new(root)

    Hal::Runtime.new(definition)
  end

  context "with deep definition" do

    let(:controller) { double(new: nil) }

    let(:aaa) { Hal::Definition::Node.new(:gauge, 'aaa', 'aaa', {}, [[controller, path: 'hhhh']], {}) }
    let(:root) { Hal::Definition::Node.new(:group, '', '', {}, [], {'aaa' => aaa}) }
    let(:definition) { Hal::Definition.new(root) }
    let(:runtime) { described_class.new(definition) }

    it "should be created" do
      runtime
    end

    it "should instantiate controllers" do
      expect(runtime.controllers.size).to eq 1
    end

  end

end
