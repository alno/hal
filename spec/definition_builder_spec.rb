require "spec_helper"

describe Hal::DefinitionBuilder do

  def p(s)
    Hal::Path[s]
  end

  it "builds empty gauge with known controller" do
    subject.controller_definitions[:some_controller_1] = ->(_type, _opts) { :some_controller_cls }

    node = subject.build_node :gauge, :fff, p('aaa'), [:some_controller_1, x: 11], opt1: 111, aaa: 'bbb'

    expect(node.type).to eq :gauge
    expect(node.path).to eq p('aaa/fff')
    expect(node.controllers).to eq [[:some_controller_cls, x: 11]]
    expect(node.options).to eq(opt1: 111, aaa: 'bbb')
  end

  it "builds empty gauge with known controller with no opts" do
    subject.controller_definitions[:some_controller_1] = ->(_type, _opts) { :some_controller_cls }

    node = subject.build_node :gauge, :fff, p('aaa'), :some_controller_1, opt1: 111, aaa: 'bbb'

    expect(node.type).to eq :gauge
    expect(node.path).to eq p('aaa/fff')
    expect(node.controllers).to eq [[:some_controller_cls, {}]]
    expect(node.options).to eq(opt1: 111, aaa: 'bbb')
  end

  it "builds group with known controller" do
    subject.controller_definitions[:some_controller] = ->(_type, _opts) { :some_controller_cls }

    node = subject.build_node :group, :bbb, p('/') do
      controller :some_controller, aa: 'aaaa'
    end

    expect(node.type).to eq :group
    expect(node.path).to eq p('/bbb')
    expect(node.controllers).to eq [[:some_controller_cls, aa: 'aaaa']]
  end

  it "builds group with known controller with no opts" do
    subject.controller_definitions[:some_controller] = ->(_type, _opts) { :some_controller_cls }

    node = subject.build_node :group, :bbb, p('') do
      controller :some_controller
    end

    expect(node.type).to eq :group
    expect(node.path).to eq p('bbb')
    expect(node.controllers).to eq [[:some_controller_cls, {}]]
  end

  it "fails on unknown controller" do
    expect do
      subject.build_node :group, :bbb, p(''), [:some_controller_1, x: 11]
    end.to raise_error Hal::DefinitionBuilder::UnknownControllerError
  end

  it "builds complex group" do
    subject.controller_definitions[:some_controller] = ->(_type, _opts) { :some_controller_cls }
    subject.controller_definitions[:other_contr] = ->(_type, _opts) { :other_contr_cls }
    subject.controller_definitions[:camera_controller] = ->(_type, _opts) { :camera_controller_cls }

    node = subject.build_node :group, :bbb, p('aaa') do

      gauge :fff, kk: 11 do
        controller :some_controller, path: 'aaaa'
      end

      camera :gggg, [:camera_controller, index: 111], [:other_contr, a: 1, b: 'dd'], aaa: 'fbg', bb: 111

      group :ghj do
        switch :xxx
      end

    end

    expect(node.type).to eq :group
    expect(node.path).to eq p('aaa/bbb')
    expect(node.controllers).to eq []

    expect(node.children.keys.sort).to eq %w(fff gggg ghj)

    expect(node.children['fff'].type).to eq :gauge
    expect(node.children['fff'].path).to eq p('aaa/bbb/fff')
    expect(node.children['fff'].controllers).to eq [[:some_controller_cls, path: 'aaaa']]
    expect(node.children['fff'].options).to eq(kk: 11)

    expect(node.children['gggg'].type).to eq :camera
    expect(node.children['gggg'].path).to eq p('aaa/bbb/gggg')
    expect(node.children['gggg'].controllers).to eq [[:camera_controller_cls, index: 111], [:other_contr_cls, a: 1, b: 'dd']]
    expect(node.children['gggg'].options).to eq(aaa: 'fbg', bb: 111)

    expect(node.children['ghj'].type).to eq :group
    expect(node.children['ghj'].path).to eq p('aaa/bbb/ghj')
    expect(node.children['ghj'].controllers).to eq []

    expect(node.children['ghj'].children['xxx'].type).to eq :switch
    expect(node.children['ghj'].children['xxx'].path).to eq p('aaa/bbb/ghj/xxx')
    expect(node.children['ghj'].children['xxx'].controllers).to eq []
  end

  it "builds full def" do
    subject.controller_definitions[:some_controller] = ->(_type, _opts) { :some_controller_cls }

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

    expect(definition.root.children.keys.sort).to eq %w(fg xyz)

    expect(definition.root.children['fg'].type).to eq :gauge
    expect(definition.root.children['fg'].path).to eq p('/fg')
    expect(definition.root.children['fg'].controllers).to eq [[:some_controller_cls, path: 'ggg', kk: 11]]

    expect(definition.root.children['xyz'].type).to eq :group
    expect(definition.root.children['xyz'].path).to eq p('/xyz')
    expect(definition.root.children['xyz'].controllers).to eq []

    expect(definition.root.children['xyz'].children['yyy'].type).to eq :camera
    expect(definition.root.children['xyz'].children['yyy'].path).to eq p('/xyz/yyy')
    expect(definition.root.children['xyz'].children['yyy'].controllers).to eq []
  end

end
