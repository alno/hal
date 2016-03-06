require "spec_helper"

describe Hal::Definition do

  it "should return root node" do
    root = Hal::Definition::Node.new(:gauge, '', '', [], {})
    definition = described_class.new(root)

    expect(definition.root).to be root
  end

  it "should collect controllers" do
    aaa = Hal::Definition::Node.new(:gauge, 'aaa', 'aaa', [[:other, path: 'hhhh']], {})
    root = Hal::Definition::Node.new(:group, '', '', [[:some, a: 11, b: 12]], {'aaa' => aaa})
    definition = described_class.new(root)

    expect(definition.controllers).to eq [['', :some, a: 11, b: 12], ['aaa', :other, path: 'hhhh']]
  end

end
