require "spec_helper"

describe Hal::EventBus do

  let(:bus) { described_class.new }

  context "subscriber" do

    subject { double(call: nil) }

    context "after calling #subscribe" do

      before do
        bus.subscribe('some-topic', subject.method(:call))
      end

      it "should receive events in correct topic" do
        expect(subject).to receive(:call).with('some-event')

        bus.publish('some-topic', 'some-event')
      end

      it "should not receive events in wrong topic" do
        expect(subject).to_not receive(:call).with('some-event')

        bus.publish('wrong-topic', 'some-event')
      end

      it "should not receive events after unsubscription" do
        expect(subject).to_not receive(:call).with('some-event')

        bus.unsubscribe('some-topic', subject.method(:call))
        bus.publish('some-topic', 'some-event')
      end

      it "should not receive event only once after second subscription" do
        expect(subject).to_not receive(:call).with('some-event').once

        bus.subscribe('some-topic', subject.method(:call))
        bus.publish('some-topic', 'some-event')
      end

    end

    it "should not receive events before subscription" do
      expect(subject).to_not receive(:call).with('some-event')

      bus.publish('some-topic', 'some-event')
    end

  end

end
