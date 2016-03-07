class Hal::EventBus

  def initialize
    @subscriptions = Hash.new{ |h, k| h[k] = [] }
  end

  def publish(topic, event)
    puts "Publishing #{event.inspect} in #{topic.inspect} topic"

    @subscriptions[topic].each{ |s| s.call(event) }
  end

  def subscribe(topic, handler)
    @subscriptions[topic] << handler unless @subscriptions[topic].include? handler
  end

  def unsubscribe(topic, handler)
    @subscriptions[topic].delete(handler)
  end

end
