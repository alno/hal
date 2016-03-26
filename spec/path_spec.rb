require "spec_helper"

describe Hal::Path do

  def p(s)
    described_class.new(s)
  end

  it "allows to create absolute path" do
    expect(p('/some/node')).to be_absolute
    expect(p('/node')).to be_absolute
    expect(p('/')).to be_absolute

    expect(p('/some/node')).not_to be_relative
    expect(p('/node')).not_to be_relative
  end

  it "allows to create relative paths" do
    expect(p('node')).to be_relative
    expect(p('other/node')).to be_relative
    expect(p('')).to be_relative

    expect(p('node')).not_to be_absolute
    expect(p('other/node')).not_to be_absolute
    expect(p('')).not_to be_absolute
  end

  it "normalizes absolute path" do
    expect(p('/some//node').to_s).to eq '/some/node'
    expect(p('//other').to_s).to eq '/other'
    expect(p('/').to_s).to eq '/'
    expect(p('////').to_s).to eq '/'
  end

  it "normalizes relative path" do
    expect(p('node//').to_s).to eq 'node'
    expect(p('other///node').to_s).to eq 'other/node'
  end

  it "checks path equality" do
    expect(p('/some')).to eq p('/some')
    expect(p('/some')).not_to eq p('some')
  end

  it "checks path uniqueness" do
    expect([p('/some'), p('/some')].uniq.size).to eq 1
  end

  it "allows to concat relative path to relative" do
    expect(p('some') / p('other')).to eq p('some/other')
  end

  it "allows to concat relative path to absolute" do
    expect(p('/obj') / p('aaa')).to eq p('/obj/aaa')
    expect(p('/') / p('x')).to eq p('/x')
  end

  it "doesn't allow to concat absolute path to relative" do
    expect do
      p('obj') / p('/aaa')
    end.to raise_error RuntimeError
  end

  it "doesn't allow to concat absolute path to absolute" do
    expect do
      p('/fewss') / p('/jjj')
    end.to raise_error RuntimeError
  end

  it "doesn't allow modifying segments array" do
    path = p('some/path')

    expect do
      path.segments << 'kkk'
    end.to raise_error RuntimeError
  end

  it "doesn't allow modifying segments" do
    path = p('some/path')

    expect do
      path.segments[0].tr! 'o', 'a'
    end.to raise_error RuntimeError
  end

end
