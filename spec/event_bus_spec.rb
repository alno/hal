require "spec_helper"

describe Hal::EventBus do

  let(:bus) { described_class.new }

  context "subscriber" do

    subject { double(call: nil) }

    context "after calling #subscribe" do

      before do
        bus.subscribe('some-topic', subject.method(:call))
      end

      it "receives events in correct topic" do
        expect(subject).to receive(:call).with('some-event')

        bus.publish('some-topic', 'some-event')
      end

      it "receives events in correct topic if registered as path" do
        expect(subject).to receive(:call).with('some-event')

        bus.publish(Hal::Path['some-topic'], 'some-event')
      end

      it "doesn't receive events in wrong topic" do
        expect(subject).not_to receive(:call).with('some-event')

        bus.publish('wrong-topic', 'some-event')
      end

      it "doesn't receive events after unsubscription" do
        expect(subject).not_to receive(:call).with('some-event')

        bus.unsubscribe('some-topic', subject.method(:call))
        bus.publish('some-topic', 'some-event')
      end

      it "doesn't receive event only once after second subscription" do
        expect(subject).not_to receive(:call).with('some-event').once

        bus.subscribe('some-topic', subject.method(:call))
        bus.publish('some-topic', 'some-event')
      end

    end

    context "after calling #subscribe with path" do

      before do
        bus.subscribe(Hal::Path.root / 'fff' / 'ggg', subject.method(:call))
      end

      it "receives events in correct topic" do
        expect(subject).to receive(:call).with('some-event')

        bus.publish('/fff/ggg', 'some-event')
      end

      it "receives events in correct topic if registered as path" do
        expect(subject).to receive(:call).with('some-event')

        bus.publish(Hal::Path['/fff/ggg'], 'some-event')
      end

      it "doesn't receive events in wrong topic" do
        expect(subject).not_to receive(:call).with('some-event')

        bus.publish('fff/ggg', 'some-event')
      end

    end

    it "doesn't receive events before subscription" do
      expect(subject).not_to receive(:call).with('some-event')

      bus.publish('some-topic', 'some-event')
    end

  end

end
