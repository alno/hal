require 'database'

class Hal::Persistor::Gauge < Hal::Persistor::Base

  def start
    bus.subscribe node.path, method(:update)
  end

  def stop
  end

  private

  def update(val)
    DB[:gauge_values].insert gauge: path, time: Time.now, value: val
  end

end
