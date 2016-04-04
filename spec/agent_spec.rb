require "spec_helper"



describe Hal::Agent do

  let(:bus) { double }
  let(:node) { double path: Hal::Path['/some/node'] }

  subject { described_class.new bus, node, {} }

  %i(subscribe unsubscribe).each do |sym|

    cls = Class.new described_class do
      def some_method(x); end
    end

    context cls, "#subscribe" do

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
end
