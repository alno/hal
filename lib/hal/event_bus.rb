class Hal::EventBus

  def initialize
    @subscriptions = Hash.new { |h, k| h[k] = [] }
  end

  def publish(topic, event)
    topic = topic.to_s

    Hal.logger.debug "Publishing #{event.inspect} in #{topic.inspect} topic"

    @subscriptions[topic].each { |s| s.call(event) }
  end

  def subscribe(topic, handler)
    topic = topic.to_s

    @subscriptions[topic] << handler unless @subscriptions[topic].include? handler
  end

  def unsubscribe(topic, handler)
    topic = topic.to_s

    @subscriptions[topic].delete(handler)
  end

end
