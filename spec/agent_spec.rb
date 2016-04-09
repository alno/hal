require "spec_helper"

describe Hal::Agent do

  let(:bus) { double }
  let(:node) { double path: Hal::Path['/some/node'] }

  let :cls do
    Class.new described_class do
      def some_method(x); end
    end
  end

  subject { cls.new bus, node, {} }

  let(:subject_timers) { double("Timers") }
  let(:subject_thread) { double("Thread", terminate: nil) }

  before do
    allow(subject).to receive(:create_timers).and_return(subject_timers)
    allow(subject).to receive(:create_thread).and_return(subject_thread)
  end

  %i(subscribe unsubscribe).each do |sym|

    context "##{sym}" do

      it "delegates to bus with relative path" do
        expect(bus).to receive(sym).with(Hal::Path['/some/node/ddd'], subject.method(:some_method))

        subject.send sym, 'ddd', :some_method
      end

      it "delegates to bus with absolute path" do
        expect(bus).to receive(sym).with(Hal::Path['/other/node'], subject.method(:some_method))

        subject.send sym, '/other/node', :some_method
      end

      it "delegates to bus with self path" do
        expect(bus).to receive(sym).with(Hal::Path['/some/node'], subject.method(:some_method))

        subject.send sym, '', :some_method
      end
    end
  end

  context "static subscribe" do

    let :cls do
      Class.new described_class do
        subscribe :fff, :other_method

        def other_method(x); end
      end
    end

    it "subscribes when starting" do
      expect(bus).to receive(:subscribe).with(Hal::Path['/some/node/fff'], subject.method(:other_method))

      subject.start
    end

    it "unsubscribes when stopping" do
      allow(bus).to receive(:subscribe)

      subject.start

      expect(bus).to receive(:unsubscribe).with(Hal::Path['/some/node/fff'], subject.method(:other_method))

      subject.stop
    end

  end

  context "static every" do

    let :cls do
      Class.new described_class do
        every 15, :do_something

        def do_something(x); end
      end
    end

    it "created timer when starting" do
      expect(subject_timers).to receive(:every).with(15)

      subject.start
    end

  end
end
