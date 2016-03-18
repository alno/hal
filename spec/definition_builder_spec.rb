require "spec_helper"

describe Hal::DefinitionBuilder do

  it "should build empty gauge" do
    node = subject.build_node :gauge, :fff, 'aaa', [:some_controller_1, x: 11], opt1: 111, aaa: 'bbb'

    expect(node.type).to eq :gauge
    expect(node.path).to eq 'aaa/fff'
    expect(node.controllers).to eq [[:some_controller_1, {x: 11}]]
    expect(node.options).to eq(opt1: 111, aaa: 'bbb')
  end

  it "should build group with controller" do
    node = subject.build_node :group, :bbb, '' do
      controller :some_controller, aa: 'aaaa'
    end

    expect(node.type).to eq :group
    expect(node.path).to eq 'bbb'
    expect(node.controllers).to eq [[:some_controller, {aa: 'aaaa'}]]
  end

  it "should build complex group" do
    node = subject.build_node :group, :bbb, 'aaa' do

      gauge :fff, kk: 11 do
        controller :some_controller, path: 'aaaa'
      end

      camera :gggg, [:camera_controller, index: 111], [:other_contr, a: 1, b: 'dd'], aaa: 'fbg', bb: 111

      group :ghj do
        switch :xxx
      end

    end

    expect(node.type).to eq :group
    expect(node.path).to eq 'aaa/bbb'
    expect(node.controllers).to eq []

    expect(node.children.keys.sort).to eq ['fff', 'gggg', 'ghj']

    expect(node.children['fff'].type).to eq :gauge
    expect(node.children['fff'].path).to eq 'aaa/bbb/fff'
    expect(node.children['fff'].controllers).to eq [[:some_controller, {path: 'aaaa'}]]
    expect(node.children['fff'].options).to eq(kk: 11)

    expect(node.children['gggg'].type).to eq :camera
    expect(node.children['gggg'].path).to eq 'aaa/bbb/gggg'
    expect(node.children['gggg'].controllers).to eq [[:camera_controller, {index: 111}], [:other_contr, a: 1, b: 'dd']]
    expect(node.children['gggg'].options).to eq(aaa: 'fbg', bb: 111)

    expect(node.children['ghj'].type).to eq :group
    expect(node.children['ghj'].path).to eq 'aaa/bbb/ghj'
    expect(node.children['ghj'].controllers).to eq []

    expect(node.children['ghj'].children['xxx'].type).to eq :switch
    expect(node.children['ghj'].children['xxx'].path).to eq 'aaa/bbb/ghj/xxx'
    expect(node.children['ghj'].children['xxx'].controllers).to eq []
  end

  it "should build full def" do
    definition = subject.build do

      gauge :fg do
        controller :some_controller, path: 'ggg', kk: 11
      end

      group :xyz do
        camera :yyy
      end

    end

    expect(definition.root.type).to eq :group
    expect(definition.root.path).to eq ''
    expect(definition.root.controllers).to eq []

    expect(definition.root.children.keys.sort).to eq ['fg', 'xyz']

    expect(definition.root.children['fg'].type).to eq :gauge
    expect(definition.root.children['fg'].path).to eq 'fg'
    expect(definition.root.children['fg'].controllers).to eq [[:some_controller, path: 'ggg', kk: 11]]

    expect(definition.root.children['xyz'].type).to eq :group
    expect(definition.root.children['xyz'].path).to eq 'xyz'
    expect(definition.root.children['xyz'].controllers).to eq []

    expect(definition.root.children['xyz'].children['yyy'].type).to eq :camera
    expect(definition.root.children['xyz'].children['yyy'].path).to eq 'xyz/yyy'
    expect(definition.root.children['xyz'].children['yyy'].controllers).to eq []
  end

end
