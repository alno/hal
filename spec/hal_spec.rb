require "spec_helper"

describe Hal do

  before do
    subject.remove_instance_variable :@logger if subject.instance_variable_defined? :@logger
  end

  it "allows to set logger" do
    logger = double

    subject.logger = logger
    expect(subject.logger).to be logger
  end

  it "has default logger" do
    expect(subject.logger).to be
  end

end
