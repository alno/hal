require 'database'

class Hal::GaugePersistor < Hal::Persistor

  def start
    bus.subscribe path, method(:update)
  end

  def stop
  end

  private

  def update(val)
    DB[:gauge_values].insert gauge: path, time: Time.now, value: val
  end

end
