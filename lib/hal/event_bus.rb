module Hal
  class EventBus

    def initialize
      @subscriptions = Hash.new{ |h, k| h[k] = [] }
    end

    def publish(topic, event)
      @subscriptions[topic].each{ |s| s.call(event) }
    end

    def subscribe(topic, handler)
      @subscriptions[topic] << handler unless @subscriptions[topic].include? handler
    end

    def unsubscribe(topic, handler)
      @subscriptions[topic].delete(handler)
    end

  end
end
