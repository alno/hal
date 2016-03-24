require "spec_helper"

describe Hal::Definition do

  it "returns root node" do
    root = Hal::Definition::Node.new(:gauge, '', '', {}, [], {})
    definition = described_class.new(root)

    expect(definition.root).to be root
  end

  context "in deep definition" do

    let(:aaa) { Hal::Definition::Node.new(:gauge, 'aaa', 'aaa', {}, [[:other, path: 'hhhh']], {}) }
    let(:root) { Hal::Definition::Node.new(:group, '', '', {}, [[:some, a: 11, b: 12]], 'aaa' => aaa) }
    let(:definition) { described_class.new(root) }

    it "collects controllers" do
      expect(definition.controllers).to eq [[root, :some, a: 11, b: 12], [aaa, :other, path: 'hhhh']]
    end

    it "collects persistors" do
      expect(definition.persistors).to eq [[root, nil, {}], [aaa, nil, {}]]
    end

  end

end
