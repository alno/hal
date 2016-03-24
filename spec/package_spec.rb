require "spec_helper"

describe Hal::Package do

  subject do
    Class.new.tap do |cls|
      cls.send :include, described_class
    end.new
  end

  it "has no controller definitions by default" do
    expect(subject.controller_definitions).to be_empty
    expect(subject.controller_definitions[:aaa]).to be_nil
  end

  it "allows to define controller with block" do
    subject.define_controller(:bbb) { |_t, _o| :bbb_controller }

    expect(subject.controller_definitions).to have_key(:bbb)
    expect(subject.controller_definitions[:bbb].call(:gauge, {})).to be :bbb_controller
  end

  it "allows to define controller with hash" do
    subject.define_controller :aaa, gauge: :gauge_aaa_controller, switch: :switch_aaa_controller

    expect(subject.controller_definitions).to have_key(:aaa)
    expect(subject.controller_definitions[:aaa].call(:gauge, {})).to be :gauge_aaa_controller
    expect(subject.controller_definitions[:aaa].call(:switch, {})).to be :switch_aaa_controller
  end

end
