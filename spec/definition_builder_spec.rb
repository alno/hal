require "spec_helper"

describe Hal::DefinitionBuilder do

  def p(s)
    Hal::Path[s]
  end

  it "builds empty gauge with known controller" do
    subject.controller_definitions[:some_controller_1] = ->(_type, _opts) { :some_controller_cls }

    definition = subject.build do
      gauge :fff, [:some_controller_1, x: 11], opt1: 111, aaa: 'bbb'
    end

    expect(definition.root['fff'].type).to eq :gauge
    expect(definition.root['fff'].path).to eq p('/fff')
    expect(definition.root['fff'].controllers).to eq [[:some_controller_cls, x: 11]]
    expect(definition.root['fff'].options).to eq(opt1: 111, aaa: 'bbb')
  end

  it "builds empty gauge with known controller with no opts" do
    subject.controller_definitions[:some_controller_1] = ->(_type, _opts) { :some_controller_cls }

    definition = subject.build do
      gauge :fff, :some_controller_1, opt1: 111, aaa: 'bbb'
    end

    expect(definition.root['fff'].type).to eq :gauge
    expect(definition.root['fff'].path).to eq p('/fff')
    expect(definition.root['fff'].controllers).to eq [[:some_controller_cls, {}]]
    expect(definition.root['fff'].options).to eq(opt1: 111, aaa: 'bbb')
  end

  it "builds group with known controller" do
    subject.controller_definitions[:some_controller] = ->(_type, _opts) { :some_controller_cls }

    definition = subject.build do
      group :bbb do
        controller :some_controller, aa: 'aaaa'
      end
    end

    expect(definition.root['bbb'].type).to eq :group
    expect(definition.root['bbb'].path).to eq p('/bbb')
    expect(definition.root['bbb'].controllers).to eq [[:some_controller_cls, aa: 'aaaa']]
  end

  it "builds group with known controller with no opts" do
    subject.controller_definitions[:some_controller] = ->(_type, _opts) { :some_controller_cls }

    definition = subject.build do
      group :bbb do
        controller :some_controller
      end
    end

    expect(definition.root['bbb'].type).to eq :group
    expect(definition.root['bbb'].path).to eq p('/bbb')
    expect(definition.root['bbb'].controllers).to eq [[:some_controller_cls, {}]]
  end

  it "fails on unknown controller" do
    expect do
      subject.build do
        group :bbb, [:some_controller_1, x: 11]
      end
    end.to raise_error Hal::DefinitionBuilder::UnknownControllerError
  end

  it "builds complex group" do
    subject.controller_definitions[:some_controller] = ->(_type, _opts) { :some_controller_cls }
    subject.controller_definitions[:other_contr] = ->(_type, _opts) { :other_contr_cls }
    subject.controller_definitions[:camera_controller] = ->(_type, _opts) { :camera_controller_cls }

    definition = subject.build do
      group :bbb do
        gauge :fff, kk: 11 do
          controller :some_controller, path: 'aaaa'
        end

        camera :gggg, [:camera_controller, index: 111], [:other_contr, a: 1, b: 'dd'], aaa: 'fbg', bb: 111

        group :ghj do
          switch :xxx
        end
      end
    end

    expect(definition.root['bbb'].type).to eq :group
    expect(definition.root['bbb'].path).to eq p('/bbb')
    expect(definition.root['bbb'].controllers).to eq []

    expect(definition.root['bbb'].children.keys.sort).to eq %w(fff gggg ghj)

    expect(definition.root['bbb']['fff'].type).to eq :gauge
    expect(definition.root['bbb']['fff'].path).to eq p('/bbb/fff')
    expect(definition.root['bbb']['fff'].controllers).to eq [[:some_controller_cls, path: 'aaaa']]
    expect(definition.root['bbb']['fff'].options).to eq(kk: 11)

    expect(definition.root['bbb']['gggg'].type).to eq :camera
    expect(definition.root['bbb']['gggg'].path).to eq p('/bbb/gggg')
    expect(definition.root['bbb']['gggg'].controllers).to eq [[:camera_controller_cls, index: 111], [:other_contr_cls, a: 1, b: 'dd']]
    expect(definition.root['bbb']['gggg'].options).to eq(aaa: 'fbg', bb: 111)

    expect(definition.root['bbb']['ghj'].type).to eq :group
    expect(definition.root['bbb']['ghj'].path).to eq p('/bbb/ghj')
    expect(definition.root['bbb']['ghj'].controllers).to eq []

    expect(definition.root['bbb']['ghj']['xxx'].type).to eq :switch
    expect(definition.root['bbb']['ghj']['xxx'].path).to eq p('/bbb/ghj/xxx')
    expect(definition.root['bbb']['ghj']['xxx'].controllers).to eq []
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
    expect(definition.root.path).to eq Hal::Path.root
    expect(definition.root.controllers).to eq []

    expect(definition.root.children.keys.sort).to eq %w(fg xyz)

    expect(definition.root['fg'].type).to eq :gauge
    expect(definition.root['fg'].path).to eq p('/fg')
    expect(definition.root['fg'].controllers).to eq [[:some_controller_cls, path: 'ggg', kk: 11]]

    expect(definition.root['xyz'].type).to eq :group
    expect(definition.root['xyz'].path).to eq p('/xyz')
    expect(definition.root['xyz'].controllers).to eq []

    expect(definition.root['xyz']['yyy'].type).to eq :camera
    expect(definition.root['xyz']['yyy'].path).to eq p('/xyz/yyy')
    expect(definition.root['xyz']['yyy'].controllers).to eq []
  end

end
